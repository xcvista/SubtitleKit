//
//  SKSubtitleTrack.h
//  Subtitler
//
//  Created by Maxthon Chan on 13-6-12.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <MSBooster/MSBooster.h>

#ifndef _SUBTITLEKIT_SKSUBTITLETRACK_H_
#define _SUBTITLEKIT_SKSUBTITLETRACK_H_

__BEGIN_DECLS

__class SKSubtitleLine;

@interface SKSubtitleTrack : NSObject <NSFastEnumeration>
{
    @private
    NSMutableArray *_lines;
    NSMutableDictionary *_metadata;
}

@property id tag;
@property NSArray *lines;
@property NSDictionary *metadata;

- (BOOL)isEqualToTrack:(SKSubtitleTrack *)track;

@end

@interface SKSubtitleTrack (NSCopying) <NSCopying>

@end

@interface SKSubtitleTrack (NSCoding) <NSCoding>

@end

@interface SKSubtitleTrack (SKManipulation)

// Line manipulation

- (SKSubtitleLine *)lineAtIndex:(NSUInteger)index;
- (void)setLine:(SKSubtitleLine *)line atIndex:(NSUInteger)index;
- (void)addLine:(SKSubtitleLine *)line;
- (void)removeLineAtIndex:(NSUInteger)index;
#if __has_feature(objc_subscripting)
- (void)setObject:(SKSubtitleLine *)object atIndexedSubscript:(NSUInteger)index;
- (SKSubtitleLine *)objectAtIndexedSubscript:(NSUInteger)index;
#endif // __has_feature(objc_subscripting)
- (void)sortLines;
- (NSUInteger)lineCount;

// Metadata manipulation

- (id)metadataForKey:(NSString *)key;
- (void)setMetadata:(id)metadata forKey:(NSString *)key;
- (void)removeMetadataForKey:(NSString *)key;
#if __has_feature(objc_subscripting)
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;
- (id)objectForKeyedSubscript:(NSString *)key;
#endif // __has_feature(objc_subscripting)

@end

// Common metadata keys

#include <SubtitleKit/SKSubtitleTrackStrings.h>

__END_DECLS

#endif // #include guard

