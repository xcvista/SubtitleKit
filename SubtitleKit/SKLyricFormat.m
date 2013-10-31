//
//  SKLyricFormat.m
//  Subtitler
//
//  Created by Maxthon Chan on 13-6-12.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "SKLyricFormat.h"

#import "SKSubtitleLine.h"
#import "SKSubtitleTrack.h"

#define __REQUIRE_OBJC_DICTIONARY_LITERALS
#define __REQUIRE_OBJC_ARRAY_LITERALS
#define __REQUIRE_OBJC_SUBSCRIPTING
#import "SKCommon_private.h"

NSDictionary *_SKLyricTranslationTable(void)
{
    static NSDictionary *table;
    if (!table)
    {
        table = @{
                  SKLyricAlbumMetadataKey:              SKAlbumMetadataKey,
                  SKLyricApplicationMetadataKey:        SKApplicationMetadataKey,
                  SKLyricApplicationVersionMetadataKey: SKApplicationVersionMetadataKey,
                  SKLyricArtistMetadataKey:             SKArtistMetadataKey,
                  SKLyricMakerMetadataKey:              SKMakerMetadataKey,
                  SKLyricTitleMetadataKey:              SKTitleMetadataKey,
                  SKLyricWriterMetadataKey:             SKWriterMetadataKey
                  };
    }
    return table;
}

NSDictionary *_SKLyricTranslationTable2(void)
{
    static NSDictionary *table;
    if (!table)
    {
        table = @{
                  SKAlbumMetadataKey:               SKLyricAlbumMetadataKey,
                  SKApplicationMetadataKey:         SKLyricApplicationMetadataKey,
                  SKApplicationVersionMetadataKey:  SKLyricApplicationVersionMetadataKey,
                  SKArtistMetadataKey:              SKLyricArtistMetadataKey,
                  SKMakerMetadataKey:               SKLyricMakerMetadataKey,
                  SKTitleMetadataKey:               SKLyricTitleMetadataKey,
                  SKWriterMetadataKey:              SKLyricWriterMetadataKey
                  };
    }
    return table;
}

static __inline NSString *_SKLyricMonoline(id obj)
{
    if (!obj)
        return [NSString string];
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"%@", obj];
    NSCharacterSet *newlines = [NSCharacterSet newlineCharacterSet];
    
    for (NSUInteger i = [string length] - 1; i < [string length]; i--) // Unsigned integer wraps.
    {
        unichar ch = [string characterAtIndex:i];
        if ([newlines characterIsMember:ch]) // If the character is a newline...
            [string deleteCharactersInRange:NSMakeRange(i, 1)]; // ... kill it.
    }
    
    return [NSString stringWithString:string];
}

@implementation NSScanner (SKLyricScanner)

// Stay dry.
// I was wet, very wet.

- (BOOL)_SKLyricsScanSquareBrackers:(NSString *__autoreleasing *)string
{
    _SKPrepareRollback();
    NSString *buf = nil;
    
    _SKAssertRollback([self scanString:@"[" intoString:NULL]);
    _SKAssertRollback([self scanUpToString:@"]" intoString:&buf]);
    _SKAssertRollback([self scanString:@"]" intoString:NULL]);
    
    NSAssignPointer(string, buf);
    return YES;
}

- (BOOL)_SKLyricsScanMetadata:(NSString *__autoreleasing *)value withKey:(NSString *__autoreleasing *)key
{
    _SKPrepareRollback();
    NSString *buf = nil;
    NSString *skey = nil;
    NSString *sval = nil;
    
    _SKAssertRollback([self _SKLyricsScanSquareBrackers:&buf]);
    
    NSScanner *scanner = [NSScanner scannerWithString:buf];
    _SKAssertRollback([scanner scanUpToString:@":" intoString:&skey]);
    _SKAssertRollback([scanner scanString:@":" intoString:NULL]);
    sval = [buf substringFromIndex:[scanner scanLocation]];
    
    NSCharacterSet *whitenewline = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSAssignPointer(key, [skey stringByTrimmingCharactersInSet:whitenewline]);
    NSAssignPointer(value, [sval stringByTrimmingCharactersInSet:whitenewline]);
    return YES;
}

- (BOOL)_SKLyricsScanTimeTag:(NSTimeInterval *)time
{
    _SKPrepareRollback();
    NSUInteger minute, second, centisecond; // note this!
    NSString *buf = nil;
    
    _SKAssertRollback([self _SKLyricsScanSquareBrackers:&buf]);
    
    NSScanner *scanner = [NSScanner scannerWithString:buf];
    _SKAssertRollback([scanner scanInteger:&minute]);
    _SKAssertRollback([scanner scanString:@":" intoString:NULL]);
    _SKAssertRollback([scanner scanInteger:&second]);
    _SKAssertRollback([scanner scanString:@"." intoString:NULL]);
    _SKAssertRollback([scanner scanInteger:&centisecond]);
    _SKAssertRollback([[[buf substringFromIndex:[scanner scanLocation]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0);
    
    NSAssignPointer(time, SKTimeIntervalFromComponents(0, minute, second, centisecond * 10, 0.0));
    return YES;
}

@end

@implementation SKLyricFormat

#pragma mark - Lyric files -> object

+ (SKSubtitleTrack *)trackFromString:(NSString *)string
{
    NSScanner *scanner = [NSScanner scannerWithString:string]; // Lexer.
    
    NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
    NSMutableArray *lines = [NSMutableArray array];
    
    NSString *key = nil, *value = nil;
    NSTimeInterval timetag = NAN; // NAN is used as a null marker.
    
    NSTimeInterval offset = 0.0;
    NSTimeInterval length = NAN;
    
    while (![scanner isAtEnd])
    {
        if ([scanner _SKLyricsScanTimeTag:&timetag])
        {
            // Scan off all remaining timetags.
            NSMutableArray *times = [@[@(timetag)] mutableCopy];
            while ([scanner _SKLyricsScanTimeTag:&timetag])
                [times addObject:@(timetag)];
            
            NSString *content = nil;
            [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                    intoString:&content];
            
            for (NSNumber *timetag in times)
            {
                SKSubtitleLine *line = [[SKSubtitleLine alloc] init];
                line.start = [timetag doubleValue] + offset;
                line.content = [content copy];
                [lines addObject:line];
            }
            
        }
        else if ([scanner _SKLyricsScanMetadata:&value withKey:&key])
        {
            if ([key isEqualToString:SKLyricLengthMetadataKey]) // [length: mm:ss]
            {
                NSString *scanoff = NSSTR(@"[%@.00]", value);
                NSScanner *_scanner = [NSScanner scannerWithString:scanoff];
                NSTimeInterval _time = NAN;
                if ([_scanner _SKLyricsScanTimeTag:&_time])
                    timetag = _time;
            }
            else if ([key isEqualToString:SKLyricOffsetMetadataKey]) // [offset: [+-]xxx]
            {
                NSInteger milliseconds = [value integerValue];
                offset = ((NSTimeInterval)milliseconds) / 1000.0;
            }
            else // everything else
            {
                metadata[key] = value;
            }
        }
    }
    
    [lines sortedArrayUsingSelector:@selector(compare:)];
    [lines enumerateObjectsWithOptions:NSEnumerationConcurrent
                            usingBlock:^(SKSubtitleLine *obj, NSUInteger idx, BOOL *stop) {
                                SKSubtitleLine *next = (idx < [lines count] - 1) ? lines[idx + 1] : nil;
                                obj.duration = next ? next.start - obj.start :
                                              (isnan(length) ? 1.0 : length - obj.start);
                                *stop = NO;
                            }];
    
    SKSubtitleTrack *track = [[SKSubtitleTrack alloc] init];
    [track setLines:lines];
    
    for (id key in metadata)
    {
        id realKey = _SKLyricTranslationTable()[key];
        if (!realKey) realKey = key;
        track[realKey] = metadata[key];
    }
    
    return track;
}

#pragma mark - Object -> lyric files

+ (NSString *)_stringFromTrack:(SKSubtitleTrack *)track
{
    NSMutableString *output = [NSMutableString string];
    
    // Write metadata
    
    NSDictionary *metadata = [track metadata];
    for (NSString *key in metadata)
    {
        NSString *value = metadata[key];
        
        [output appendFormat:@"[%@:%@]\n", key, value];
    }
    
    // Compress lines
    
    NSMutableDictionary *allLines = [NSMutableDictionary dictionaryWithCapacity:[track lineCount]];
    NSArray *lines = [track lines];
    for (SKSubtitleLine *line in lines)
    {
        NSMutableArray *existing = allLines[line.content];
        id startTime = @(line.start);
        
        if (existing)
        {
            [existing addObject:startTime];
        }
        else
        {
            allLines[line.content] = [NSMutableArray arrayWithObject:startTime];
        }
    }
    
    // Process the output sequence
    
    NSArray *outputSequence = [[allLines allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSArray *times1 = allLines[obj1];
        NSArray *times2 = allLines[obj2];
        return [times1[0] compare:times2[0]];
    }];
    
    for (id line in outputSequence)
    {
        // Time tag
        NSArray *times = allLines[line];
        for (NSNumber *time in times)
        {
            NSTimeInterval timeInterval = [time doubleValue];
            NSUInteger minute, second, millisecond;
            SKComponentsFromTimeInterval(timeInterval, NULL, &minute, &second, &millisecond);
            
            [output appendFormat:@"[%02lu:%02lu.%02lu]", minute, second, millisecond];
        }
        
        [output appendFormat:@"%@\n", _SKLyricMonoline(line)];
    }
    
    return output;
}

+ (NSString *)_stringFromTrackNoCompress:(SKSubtitleTrack *)track
{
    NSMutableString *output = [NSMutableString string];
    
    // Write metadata
    
    NSDictionary *metadata = [track metadata];
    for (NSString *key in metadata)
    {
        NSString *value = metadata[key];
        
        [output appendFormat:@"[%@:%@]\n", key, value];
    }
    
    // Write lines
    
    NSArray *lines = [track lines];
    for (SKSubtitleLine *line in lines)
    {
        // Time tag
        NSUInteger minute, second, millisecond;
        SKComponentsFromTimeInterval(line.start, NULL, &minute, &second, &millisecond);
        
        [output appendFormat:@"[%02lu:%02lu.%02lu]%@\n", minute, second, millisecond / 10, _SKLyricMonoline(line.content)];
    }
    
    return output;
}

+ (NSString *)stringFromTrack:(SKSubtitleTrack *)track compressed:(BOOL)compress
{
    // Process metadata tags
    
    SKSubtitleTrack *thisTrack = [track copy];
    [thisTrack sortLines];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[[thisTrack metadata] count]];
    for (id key in [thisTrack metadata])
    {
        NSDictionary *translation = _SKLyricTranslationTable2();
        id realKey = translation[key];
        if (!realKey)
            realKey = key;
        dictionary[realKey] = [thisTrack metadata][key];
    }
    
    NSUInteger lmin, lsec;
    SKComponentsFromTimeInterval([[[thisTrack lines] lastObject] end], NULL, &lmin, &lsec, NULL);
    dictionary[SKLyricLengthMetadataKey] = NSSTR(@"%lu:%02lu", lmin, lsec);
    
    [thisTrack setMetadata:dictionary];
    
    return [NSString stringWithString:compress ? [self _stringFromTrack:thisTrack] : [self _stringFromTrackNoCompress:thisTrack]];
}

+ (NSString *)stringFromTrack:(SKSubtitleTrack *)track
{
    return [self stringFromTrack:track compressed:NO];
}

+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track compressed:(BOOL)compress
{
    return [self dataFromTrack:track
                      encoding:NSUTF8StringEncoding
                    compressed:compress];
}

+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track encoding:(NSStringEncoding)encoding compressed:(BOOL)compress
{
    return [[self stringFromTrack:track compressed:compress] dataUsingEncoding:encoding];
}

@end

@implementation SKLyricFormat (SKHelper)

+ (BOOL)writeTrack:(SKSubtitleTrack *)track
            toFile:(NSString *)fileName
        compressed:(BOOL)compress
        atomically:(BOOL)atomically
{
    NSData *data = [self dataFromTrack:track compressed:compress];
    return [data writeToFile:fileName
                  atomically:atomically];
}

+ (BOOL)writeTrack:(SKSubtitleTrack *)track
             toURL:(NSURL *)URL
        compressed:(BOOL)compress
        atomically:(BOOL)atomically
{
    NSData *data = [self dataFromTrack:track compressed:compress];
    return [data writeToURL:URL
                 atomically:atomically];
}

@end

# pragma mark - LRC metadata keys

NSStringConstant(SKLyricTitleMetadataKey, ti);
NSStringConstant(SKLyricMakerMetadataKey, by);
NSStringConstant(SKLyricArtistMetadataKey, ar);
NSStringConstant(SKLyricAlbumMetadataKey, al);
NSStringConstant(SKLyricWriterMetadataKey, au);
NSStringConstant(SKLyricOffsetMetadataKey, offset);
NSStringConstant(SKLyricApplicationMetadataKey, re);
NSStringConstant(SKLyricApplicationVersionMetadataKey, ve);
NSStringConstant(SKLyricLengthMetadataKey, length);
