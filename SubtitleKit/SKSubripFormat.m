//
//  SKSubripFormat.m
//  Subtitler
//
//  Created by Maxthon Chan on 13-6-12.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "SKSubripFormat.h"
#import "SKSubtitleLine.h"
#import "SKSubtitleTrack.h"

#import "SKCommon_private.h"

@implementation NSScanner (SKSubrip)

- (BOOL)_SKSubripScanTimetag:(NSTimeInterval *)time
{
    NSUInteger hour, min, sec, msec;
    _SKPrepareRollback();
    
    _SKAssertRollback([self scanInteger:&hour]);
    _SKAssertRollback([self scanString:@":" intoString:NULL]);
    _SKAssertRollback([self scanInteger:&min]);
    _SKAssertRollback([self scanString:@":" intoString:NULL]);
    _SKAssertRollback([self scanInteger:&sec]);
    _SKAssertRollback([self scanString:@"," intoString:NULL]);
    _SKAssertRollback([self scanInteger:&msec]);
    
    NSAssignPointer(time, SKTimeIntervalFromComponents(hour, min, sec, msec, 0.0));
    return YES;
}

- (BOOL)_SKSubripScanTimetagAssemblyWithIdentifer:(NSUInteger *)identifier
                                             from:(NSTimeInterval *)from
                                               to:(NSTimeInterval *)to
{
    NSUInteger ident;
    NSTimeInterval ftime, ttime;
    NSCharacterSet *ignores = [self charactersToBeSkipped];
    _SKPrepareRollback();
    
    [self setCharactersToBeSkipped:nil];
    
    _SKAssertRollback([self scanInteger:&ident]);
    [self scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                         intoString:NULL];
    _SKAssertRollback([self scanCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                       intoString:NULL]);
    _SKAssertRollback([self _SKSubripScanTimetag:&ftime]);
    _SKAssertRollback([self scanString:@" --> " intoString:NULL]);
    _SKAssertRollback([self _SKSubripScanTimetag:&ttime]);
    
    [self setCharactersToBeSkipped:ignores];
    
    NSAssignPointer(identifier, ident);
    NSAssignPointer(from, ftime);
    NSAssignPointer(to, ttime);
    return YES;
}

@end

@interface SKSubtitleLine (SKSubripOutput)

- (NSString *)_SKSubripRepresentationWithIdentifier:(NSUInteger)identifier;

@end

static __inline NSString *_SKStringFromTimetag(NSTimeInterval tag)
{
    NSUInteger hour, minute, second, millisecond;
    SKComponentsFromTimeInterval(tag, &hour, &minute, &second, &millisecond);
    return NSSTR(@"%02lu:%02lu:%02lu,%03lu", hour, minute, second, millisecond);
}

@implementation SKSubtitleLine (SKSubripOutput)

- (NSString *)_SKSubripRepresentationWithIdentifier:(NSUInteger)identifier
{
    NSString *contentRepresentation = nil;
    
    if ([self.content isKindOfClass:[NSAttributedString class]])
    {
        // Attributed string - handle attriution!
        contentRepresentation = [self.content string];
    }
    else
    {
        contentRepresentation = [self.content description];
    }
    
    return NSSTR(@"%lu\n%@ --> %@\n%@\n\n",
                 identifier,
                 _SKStringFromTimetag(self.start),
                 _SKStringFromTimetag([self end]),
                 [contentRepresentation stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
}

@end

@implementation SKSubripFormat

+ (SKSubtitleTrack *)trackFromString:(NSString *)string
{
    SKSubtitleTrack *track = [[SKSubtitleTrack alloc] init];
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    [scanner setCharactersToBeSkipped:nil];
    NSTimeInterval start, end;
    
    // Search for the first time tag
    
    while (![scanner _SKSubripScanTimetagAssemblyWithIdentifer:NULL
                                                          from:&start
                                                            to:&end])
    {
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                intoString:NULL];
    }
    
    // Scan up the document;
    
    NSTimeInterval oldstart = start, oldend = end;
    NSString *buffer = [NSString string];
    BOOL inLine = NO;
    
    [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                            intoString:NULL];
    [scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                        intoString:NULL];
    
    while (![scanner isAtEnd])
    {
        if ([scanner _SKSubripScanTimetagAssemblyWithIdentifer:NULL
                                                          from:&start
                                                            to:&end])
        {
            // New line.
            
            SKSubtitleLine *line = [[SKSubtitleLine alloc] init];
            line.content = [buffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            line.start = oldstart;
            [line setEnd:oldend];
            [track addLine:line];
            
            // Reset environment.
            
            oldstart = start;
            oldend = end;
            buffer = [NSString string];
            inLine = NO;
            
            [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                    intoString:NULL];
            [scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                intoString:NULL];
        }
        else
        {
            NSString *line = nil;
            
            [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                    intoString:&line];
            [scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                intoString:NULL];
            if (line)
                buffer = [buffer stringByAppendingFormat:@"%@\n", line];
            inLine = YES;
        }
    }
    
    if (inLine)
    {
        SKSubtitleLine *line = [[SKSubtitleLine alloc] init];
        line.content = [buffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        line.start = oldstart;
        [line setEnd:oldend];
        [track addLine:line];
    }
    
    [track sortLines];
    
    return track;
}

+ (NSString *)stringFromTrack:(SKSubtitleTrack *)track
{
    NSArray *lines = [track lines];
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[lines count]];
    
    for (NSUInteger i = 0; i < [lines count]; i++)
    {
        SKSubtitleLine *line = lines[i];
        [annotations addObject:[line _SKSubripRepresentationWithIdentifier:i + 1]];
    }
    
    return [annotations componentsJoinedByString:@""];
}

@end
