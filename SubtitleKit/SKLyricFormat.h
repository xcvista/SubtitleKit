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
 `SKLyricFormat` is a concrete subclass of `SKTextSubtitleFormat` implementing
 the parser and writer of text lyrics format.
 
 ## Introduction to lyric file format
 
 Text lyrics format is a commonly-used file format for timed lyrics of songs. A
 platheora of software have the ability to open and display this format.
 
 It is a text-based format with the following format:

    [key:value]
    [mm:ss.cc]line
 
 like:

    [ti:22]
    [ar:Taylor Swift]
    [al:Red]
    
    [00:00.00]22 - Taylor Swift
    [00:04.60]It, feels like the perfect night,
    ...
 
 The `[key:value]` lines provides metadata, with a special metadata key `offset`
 allowing offsetting the contents of the entire file.
 
 The `[mm:ss:cc]contents` lines provides timing of lines with a resolution of up
 to 10 milliseconds. The notation provides no closing time, so this parser
 assumes every line lasts until the next line shows up, and the last line have a
 duration of 0 seconds.
 
 Optionally, the file can be compressed by combining multiple time tags with the
 same content into a single line. This parser can handle such lines.
 
 By default, when generating a lyric file, it is not compressed.
 */
@interface SKLyricFormat : SKTextSubtitleFormat

/// @name   Generating compressed representations

/**
 Generate the text content of the subtitle track.

 @param     track       The track the subtitle should be generated from.
 @param     compress    Whether the output should be compressed.
 @see       +[SKTextSubtitleFormat stringFromTrack:]
 */
+ (NSString *)stringFromTrack:(SKSubtitleTrack *)track
                   compressed:(BOOL)compress;

/**
 Generate the data representation of the subtitle track.
 
 @param     track       The track the subtitle should be generated from.
 @param     encoding    The string encoding.
 @param     compress    Whether the output should be compressed.
 @see       +[SKTextSubtitleFormat dataFromTrack:encoding:]
 */
+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track
                 encoding:(NSStringEncoding)encoding
               compressed:(BOOL)compress;

/**
 Generate the data representation of the subtitle track.
 
 @param     track       The track the subtitle should be generated from.
 @param     compress    Whether the output should be compressed.
 @see       +[SKSubtitleFormat dataFromTrack:]
 */
+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track
               compressed:(BOOL)compress;

/**
 Write the data representation of the subtitle track to a file.
 
 @param     track       The track the subtitle should be generated from.
 @param     filename    The file to be written to.
 @param     atomically  Whether to write the file atomically.
 @param     compress    Whether the output should be compressed.
 @see       +[SKSubtitleFormat writeTrack:toFile:atomically:]
 */
+ (BOOL)writeTrack:(SKSubtitleTrack *)track
            toFile:(NSString *)filename
        compressed:(BOOL)compress
        atomically:(BOOL)atomically;

/**
 Write the data representation of the subtitle track to a URL.
 
 @param     track       The track the subtitle should be generated from.
 @param     URL         The URL to be written to.
 @param     atomically  Whether to write the file atomically.
 @param     compress    Whether the output should be compressed.
 @see       +[SKSubtitleFormat writeTrack:toURL:atomically:]
 */
+ (BOOL)writeTrack:(SKSubtitleTrack *)track
             toURL:(NSURL *)URL
        compressed:(BOOL)compress
        atomically:(BOOL)atomically;

@end

// LRC metadata keys
#include <SubtitleKit/SKLyricFormatStrings.h>

__END_DECLS