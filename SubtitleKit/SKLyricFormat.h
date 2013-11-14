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

/**
 @brief     Class encapsulating the parser and writer of text lyrics format.
 
 SKLyricFormat class implements the parser and writer of text lyrics format.
 
 Text lyrics format is a commonly-used file format for timed lyrics of songs. A
 platheora of software have the ability to open and display this format.
 
 It is a text-based format with the following format:

     [key:value]
     [mm:ss.cc]line
 
 the <tt>[key:value]</tt> lines provides text-based metadata support, 
 */
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

// LRC metadata keys
#include <SubtitleKit/SKLyricFormatStrings.h>

__END_DECLS