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

@interface SKTextSubtitleFormat : SKSubtitleFormat

// Must-overrides
+ (NSString *)stringFromTrack:(SKSubtitleTrack *)track;
+ (SKSubtitleTrack *)trackFromString:(NSString *)string;

+ (SKSubtitleTrack *)trackFromData:(NSData *)data encoding:(NSStringEncoding)encoding;
+ (NSData *)dataFromTrack:(SKSubtitleTrack *)track encoding:(NSStringEncoding)encoding;

@end

__END_DECLS
