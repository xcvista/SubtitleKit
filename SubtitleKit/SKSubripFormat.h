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

+ (id)lineContentFromLine:(NSString *)content;
+ (NSString *)lineFromLineContent:(id)content;

@end

__END_DECLS
