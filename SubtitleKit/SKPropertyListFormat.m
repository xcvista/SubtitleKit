//
//  SKPropertyListFormat.m
//  Subtitler
//
//  Created by Maxthon Chan on 13-6-14.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "SKPropertyListFormat.h"

@implementation SKPropertyListFormat

+ (SKSubtitleTrack *)trackFromData:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track
{
    return [NSKeyedArchiver archivedDataWithRootObject:track];
}

@end
