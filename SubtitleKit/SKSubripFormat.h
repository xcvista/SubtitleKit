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

@interface SKSubripFormat : SKTextSubtitleFormat

@end

@interface NSScanner (SKSubrip)

- (BOOL)_SKSubripScanTimetagAssemblyWithIdentifer:(NSUInteger *)identifier
                                             from:(NSTimeInterval *)from
                                               to:(NSTimeInterval *)to;
- (BOOL)_SKSubripScanTimetag:(NSTimeInterval *)time;

@end

__END_DECLS
