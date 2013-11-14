//
//  SKSubtitleFormat.h
//  Subtitler
//
//  Created by Maxthon Chan on 13-6-14.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MSBooster/MSBooster.h>

__BEGIN_DECLS

__class SKSubtitleTrack;

/**
 `SKSubtitleFormat` is an abstract class of describing common traits of subtitle
 format handlers.
 
 You cannot instantiate this class or its subclasses.
 
 ## Notes on subclassing
 
 You must override `dataFromTrack:` and `trackFromData:` methods in your
 subclass.
 */
@interface SKSubtitleFormat : NSObject

/// @name   Parsing data into track

/**
 Parse the data content into a subtitle track.

 @param     data        The data to be parsed
 @return    If the parsing is successful, the parsed track is returned. Else,
            return `nil`.
*/
+ (SKSubtitleTrack *)trackFromData:(NSData *)data;

/**
 Parse the content from a file into a subtitle track.
 
 @param     filename    The file to be parsed
 @return    If the parsing is successful, the parsed track is returned. Else,
            return `nil`.
 */
+ (SKSubtitleTrack *)trackFromContentsOfFile:(NSString *)filename;

/**
 Parse the content of a URL into a subtitle track.
 
 @param     URL         The URL to be parsed
 @return    If the parsing is successful, the parsed track is returned. Else,
            return `nil`.
 */
+ (SKSubtitleTrack *)trackFromContentsOfURL:(NSURL *)URL;

/// @name   Generating data from track

/**
 Generate the data representation of the subtitle track.
 
 @param     track       The track the subtitle should be generated from.
 */
+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track;

/**
 Write the data representation of the subtitle track to a file.
 
 @param     track       The track the subtitle should be generated from.
 @param     filename    The file to be written to.
 @param     atomically  Whether to write the file atomically.
 */
+ (BOOL)writeTrack:(SKSubtitleTrack *)track
            toFile:(NSString *)filename
        atomically:(BOOL)atomically;

/**
 Write the data representation of the subtitle track to a URL.
 
 @param     track       The track the subtitle should be generated from.
 @param     URL         The URL to be written to.
 @param     atomically  Whether to write the file atomically.
 */
+ (BOOL)writeTrack:(SKSubtitleTrack *)track
             toURL:(NSURL *)URL
        atomically:(BOOL)atomically;

@end

__END_DECLS
