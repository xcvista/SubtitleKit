//
//  SKLyricFormat.h
//  Subtitler
//
//  Created by Maxthon Chan on 13-6-12.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <SubtitleKit/SKTextSubtitleFormat.h>

__BEGIN_DECLS

__class SKSubtitleTrack;

@interface SKLyricFormat : SKTextSubtitleFormat

+ (NSString *)stringFromTrack:(SKSubtitleTrack *)track
                   compressed:(BOOL)compress;

+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track
                 encoding:(NSStringEncoding)encoding
               compressed:(BOOL)compress;

+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track
               compressed:(BOOL)compress;

@end

@interface SKLyricFormat (SKHelper)

+ (BOOL)writeTrack:(SKSubtitleTrack *)track
            toFile:(NSString *)fileName
        compressed:(BOOL)compress
        atomically:(BOOL)atomically;
+ (BOOL)writeTrack:(SKSubtitleTrack *)track
             toURL:(NSURL *)URL
        compressed:(BOOL)compress
        atomically:(BOOL)atomically;

@end

@interface NSScanner (SKLyricScanner)

- (BOOL)_SKLyricsScanSquareBrackers:(NSString **)string;
- (BOOL)_SKLyricsScanTimeTag:(NSTimeInterval *)time; // [key:value]
- (BOOL)_SKLyricsScanMetadata:(NSString **)value withKey:(NSString **)key; // [mm:ss.xx] (as NSTimeInterval)

@end

// LRC metadata keys
#include <SubtitleKit/SKLyricFormatStrings.h>

__END_DECLS