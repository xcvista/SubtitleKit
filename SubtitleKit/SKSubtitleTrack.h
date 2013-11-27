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

/**
 `SKSubtitleTrack` represents a track of subtitles.
 
 @note      `SKSubtitleTrack` implements `NSFastEnumeration` that enumerates
            through `lines`.
 */
@interface SKSubtitleTrack : NSObject <NSFastEnumeration, NSCopying, NSCoding>
{
    @private
    NSMutableArray *_lines;
    NSMutableDictionary *_metadata;
}

/// @name   Content of track

/// Tag of the track.
@property id tag;

/// All lines of the track.
@property NSArray *lines;

/// All metadata of the track.
@property NSDictionary *metadata;

/// @name   Comparing tracks

/**
 Comparing tracks.
 
 @param     track       The other track to compare with.
 */
- (BOOL)isEqualToTrack:(SKSubtitleTrack *)track;

/// @name   Line manipulation

/**
 Get line at a given index.
 
 @param     index       Index of the line.
 */
- (SKSubtitleLine *)lineAtIndex:(NSUInteger)index;

/**
 Get lines at indexes
 
 @param     indexes     Indexes of the lines.
 */
- (NSArray *)linesAtIndexes:(NSIndexSet *)indexes;

/**
 Get all lines at a given time.
 
 @param     time        The occuring time of the line.
 */
- (NSArray *)linesAtTime:(NSTimeInterval)time;

/**
 Set a line at a certain index.
 
 @param     line        The line to be set.
 @param     index       The index where the line will be set.
 */
- (void)setLine:(SKSubtitleLine *)line atIndex:(NSUInteger)index;

/**
 Append a line at the end of the track.
 
 @param     line        The line to be appended.
 */
- (void)addLine:(SKSubtitleLine *)line;

/**
 Remove the line at the given index.
 
 @param     index       The index of the line to be removed.
 */
- (void)removeLineAtIndex:(NSUInteger)index;

#if __has_feature(objc_subscripting)

/**
 Set a line at a certain index.
 
 @param     object      The line to be set.
 @param     index       The index where the line will be set.
 @see       setLine:atIndex:
 */
- (void)setObject:(SKSubtitleLine *)object atIndexedSubscript:(NSUInteger)index;

/**
 Get line at a given index.
 
 @param     index       Index of the line.
 @see       lineAtIndex:
 */
- (SKSubtitleLine *)objectAtIndexedSubscript:(NSUInteger)index;

#endif // __has_feature(objc_subscripting)

/**
 Sort the contents of the track according to its time.
 
 @see       -[SKSubtitleLine timeCompare:]
 */
- (void)sortLines;

/**
 Get the count of lines in the track.
 */
- (NSUInteger)lineCount;

/// @name   Metadata manipulation

/**
 Get the metadata according to its key.
 
 @param     key         Metadata key.
 */
- (id)metadataForKey:(NSString *)key;

/**
 Set the metadata of the given key.
 
 @param     metadata    Metadata contents.
 @param     key         Metadata key.
 */
- (void)setMetadata:(id)metadata forKey:(NSString *)key;

/**
 Remove the metadata with the key.
 
 @param     key         Metadata key.
 */
- (void)removeMetadataForKey:(NSString *)key;

#if __has_feature(objc_subscripting)

/**
 Set the metadata of the given key.
 
 @param     object      Metadata contents.
 @param     key         Metadata key.
 @see       setMetadata:forKey:
 */
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;

/**
 Get the metadata according to its key.
 
 @param     key         Metadata key.
 @see       metadataForKey:
 */
- (id)objectForKeyedSubscript:(NSString *)key;

#endif // __has_feature(objc_subscripting)

/// @name   Offsetting lines in track

/**
 Offset all lines in the track.
 
 @param     offset  Offset.
 */
- (void)offsetAllLines:(NSTimeInterval)offset;

@end

// Common metadata keys

#include <SubtitleKit/SKSubtitleTrackStrings.h>

__END_DECLS

#endif // #include guard

