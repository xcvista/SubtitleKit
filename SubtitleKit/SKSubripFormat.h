//
//  SKSubripFormat.h
//  Subtitler
//
//  Created by Maxthon Chan on 13-6-12.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <SubtitleKit/SKTextSubtitleFormat.h>

__BEGIN_DECLS

__class SKSubtitleTrack;

/**
 `SKSubripFormat` is a concrete subclass of `SKTextSubtitleFormat` implementing
 the parser and writer of Subrip format.
 
 Subrip is a common timed text format for video. A platheora of player software
 have the ability to open and display this format.
 
 It is a text-based format with the following format for each line of subtitle:

    ID
    hh:mm:ss,ccc --> hh:mm:ss,ccc
    contents that can <i>be</i> <b>styled</b> <u>freely</u>
    or span multiple lines
    <empty line>
 
 like:
 
    1
    00:00:00,000 --> 00:00:01,000
    22 - Taylor Swift
    
    2
    00:00:04,605 --> 00:00:05,530
    It, feels like the perfect night,
 
    ...
 
 The leading number is not important, but misaligned numbers may confuse some
 certain players.
 
 The second line provided a time tag with a resolution up to a millisecond and
 both starting and ending points.
 
 The contents can span multiple lines and can be styled. This class dors not
 support styles, but its concrete subclass, `SKStyledSubripFormat` do.
 
 ## Notes on subclassing
 
 Methods `lineContentFromLine:` and `lineFromLineContent:` can be overrided to
 provide additional parsing of lines in the content.
 */
@interface SKSubripFormat : SKTextSubtitleFormat

/// @name   Additional parsing

/**
 Parse the contents of the subtitle line.
 
 @param     content     Content to be parsed.
 */
+ (id)lineContentFromLine:(NSString *)content;

/**
 Generate the string representation of the line.
 
 @param     content     Content of the line.
 */
+ (NSString *)lineFromLineContent:(id)content;

@end

__END_DECLS
