//
//  SKTextSubtitleFormat.h
//  Subtitler
//
//  Created by Maxthon Chan on 6/18/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <SubtitleKit/SKSubtitleFormat.h>

__BEGIN_DECLS

__class SKSubtitleTrack;

/**
 `SKTextSubtitleFormat` is an abstract subclass of `SKSubtitleFormat` providing
 common implementation of text-based subtitle format handling.
 
 You cannot instantiate this class or its subclasses.
 
 ## Notes on subclassing
 
 You must override `stringFromTrack:` and `trackFromString:` methods in your
 subclass.
 
 `dataFromTrack:` and `trackFromData:` methods from `SKSubtitleFormat` is
 implemented in this class, calling `dataFromTrack:encoding:` and 
 `trackFromData:encoding:` with default encoding, `NSUTF8StringEncoding`.
 */
@interface SKTextSubtitleFormat : SKSubtitleFormat

/// @name   Parsing subtitle text

/**
 Parse the text content into a subtitle track.
 
 @param     string      The string to be parsed
 @return    If the parsing is successful, the parsed track is returned. Else,
            return `nil`.
 */
+ (SKSubtitleTrack *)trackFromString:(NSString *)string;

/**
 Parse the input data, with the given encoding.
 
 @param     data        The input data.
 @param     encoding    The string encoding.
 @return    If the parsing is successful, the parsed track is returned. Else,
            return `nil`.
 */
+ (SKSubtitleTrack *)trackFromData:(NSData *)data encoding:(NSStringEncoding)encoding;

/// @name   Generating subtitle text

/**
 Generate the text content of the subtitle track.
 
 @param     track   The track the subtitle should be generated from.
 */
+ (NSString *)stringFromTrack:(SKSubtitleTrack *)track;

/**
 Generate the data representation of the subtitle track.
 
 @param     track       The track the subtitle should be generated from.
 @param     encoding    The string encoding.
 */
+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track encoding:(NSStringEncoding)encoding;

@end

__END_DECLS
