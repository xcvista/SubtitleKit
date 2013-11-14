//
//  SKSubtitleFormat.m
//  Subtitler
//
//  Created by Maxthon Chan on 13-6-14.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "SKSubtitleFormat.h"

@implementation SKSubtitleFormat

+ (SKSubtitleTrack *)trackFromData:(NSData *)data
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (SKSubtitleTrack *)trackFromContentsOfFile:(NSString *)filename
{
    NSData *data = [NSData dataWithContentsOfFile:filename];
    if (data)
    {
        return [self trackFromData:data];
    }
    else
    {
        return nil;
    }
}

+ (SKSubtitleTrack *)trackFromContentsOfURL:(NSURL *)URL
{
    NSData *data = [NSData dataWithContentsOfURL:URL];
    if (data)
    {
        return [self trackFromData:data];
    }
    else
    {
        return nil;
    }
}

+ (BOOL)writeTrack:(SKSubtitleTrack *)track
            toFile:(NSString *)fileName
        atomically:(BOOL)atomically
{
    NSData *data = [self dataFromTrack:track];
    return [data writeToFile:fileName
                  atomically:atomically];
}

+ (BOOL)writeTrack:(SKSubtitleTrack *)track
             toURL:(NSURL *)URL
        atomically:(BOOL)atomically
{
    NSData *data = [self dataFromTrack:track];
    return [data writeToURL:URL
                 atomically:atomically];
}

- (id)init
{
    return self = nil;
}

@end
