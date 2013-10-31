//
//  SKSubtitleFormat.h
//  Subtitler
//
//  Created by Maxthon Chan on 13-6-14.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <SubtitleKit/SKCommon.h>

__BEGIN_DECLS

__class SKSubtitleTrack;

@interface SKSubtitleFormat : NSObject

// Must-overrides

+ (SKSubtitleTrack *)trackFromData:(NSData *)data;
+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track;

@end

@interface SKSubtitleFormat (SKHelpers)

// Helpers

+ (SKSubtitleTrack *)trackFromContentsOfFile:(NSString *)filename;
+ (SKSubtitleTrack *)trackFromContentsOfURL:(NSURL *)URL;
+ (BOOL)writeTrack:(SKSubtitleTrack *)track
            toFile:(NSString *)fileName
        atomically:(BOOL)atomically;
+ (BOOL)writeTrack:(SKSubtitleTrack *)track
             toURL:(NSURL *)URL
        atomically:(BOOL)atomically;

@end

__END_DECLS
