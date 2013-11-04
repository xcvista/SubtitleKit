//
//  SKTextSubtitleFormat.m
//  Subtitler
//
//  Created by Maxthon Chan on 6/18/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "SKTextSubtitleFormat.h"

@implementation SKTextSubtitleFormat

#pragma mark - File -> object

+ (SKSubtitleTrack *)trackFromData:(NSData *)data
{
    return [self trackFromData:data
                      encoding:NSUTF8StringEncoding];
}

+ (SKSubtitleTrack *)trackFromData:(NSData *)data
                          encoding:(NSStringEncoding)encoding
{
    return [self trackFromString:[[NSString alloc] initWithData:data
                                                       encoding:encoding]];
}

+ (SKSubtitleTrack *)trackFromString:(NSString *)string
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark Object -> file

+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track
{
    return [self dataFromTrack:track
                      encoding:NSUTF8StringEncoding];
}

+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track
                 encoding:(NSStringEncoding)encoding
{
    return [[self stringFromTrack:track] dataUsingEncoding:encoding];
}

+ (NSString *)stringFromTrack:(SKSubtitleTrack *)track
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
