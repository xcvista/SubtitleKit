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

#import <MSBooster/MSBooster_Private.h>

@interface NSScanner (SKSubrip)

- (BOOL)_SKSubripScanTimetagAssemblyWithIdentifer:(NSUInteger *)identifier
                                             from:(NSTimeInterval *)from
                                               to:(NSTimeInterval *)to;
- (BOOL)_SKSubripScanTimetag:(NSTimeInterval *)time;

@end

@implementation NSScanner (SKSubrip)

- (BOOL)_SKSubripScanTimetag:(NSTimeInterval *)time
{
    NSInteger hour, min, sec, msec;
    MSScannerBegin();
    
    MSScannerAssert([self scanInteger:&hour]);
    MSScannerAssert([self scanString:@":" intoString:NULL]);
    MSScannerAssert([self scanInteger:&min]);
    MSScannerAssert([self scanString:@":" intoString:NULL]);
    MSScannerAssert([self scanInteger:&sec]);
    MSScannerAssert([self scanString:@"," intoString:NULL]);
    MSScannerAssert([self scanInteger:&msec]);
    
    MSAssignPointer(time, SKTimeIntervalFromComponents(hour, min, sec, msec, 0.0));
    return YES;
}

- (BOOL)_SKSubripScanTimetagAssemblyWithIdentifer:(NSUInteger *)identifier
                                             from:(NSTimeInterval *)from
                                               to:(NSTimeInterval *)to
{
    NSInteger ident;
    NSTimeInterval ftime, ttime;
    NSCharacterSet *ignores = [self charactersToBeSkipped];
    MSScannerBegin();
    
    [self setCharactersToBeSkipped:nil];
    
    MSScannerAssert([self scanInteger:&ident]);
    [self scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                         intoString:NULL];
    MSScannerAssert([self scanCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                       intoString:NULL]);
    MSScannerAssert([self _SKSubripScanTimetag:&ftime]);
    MSScannerAssert([self scanString:@" --> " intoString:NULL]);
    MSScannerAssert([self _SKSubripScanTimetag:&ttime]);
    
    [self setCharactersToBeSkipped:ignores];
    
    MSAssignPointer(identifier, ident);
    MSAssignPointer(from, ftime);
    MSAssignPointer(to, ttime);
    return YES;
}

@end

@interface SKSubtitleLine (SKSubripOutput)

- (NSString *)_SKSubripRepresentationWithIdentifier:(NSUInteger)identifier sender:(Class)class;

@end

static MSInline NSString *_SKStringFromTimetag(NSTimeInterval tag)
{
    NSUInteger hour, minute, second, millisecond;
    SKComponentsFromTimeInterval(tag, &hour, &minute, &second, &millisecond);
    return MSSTR(@"%02lu:%02lu:%02lu,%03lu", hour, minute, second, millisecond);
}

@implementation SKSubtitleLine (SKSubripOutput)

- (NSString *)_SKSubripRepresentationWithIdentifier:(NSUInteger)identifier sender:(Class)class
{
    NSString *contentRepresentation = [class lineFromLineContent:self.content];

    return MSSTR(@"%lu\n%@ --> %@\n%@\n\n",
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
    NSTimeInterval start = NAN, end = NAN;
    
    if (![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
        return [[SKSubtitleTrack alloc] init];
    
    // Search for the first time tag
    
    while (![scanner _SKSubripScanTimetagAssemblyWithIdentifer:NULL
                                                          from:&start
                                                            to:&end])
    {
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                intoString:NULL];
        if ([scanner isAtEnd])
            return [[SKSubtitleTrack alloc] init];
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
            line.content = [self lineContentFromLine:buffer];
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
        line.content = [self lineContentFromLine:buffer];
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
        [annotations addObject:[line _SKSubripRepresentationWithIdentifier:i + 1 sender:self]];
    }
    
    return [annotations componentsJoinedByString:@""];
}

+ (id)lineContentFromLine:(NSString *)content
{
    return [content stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

+ (NSString *)lineFromLineContent:(id)content
{
    return [content description];
}

@end
