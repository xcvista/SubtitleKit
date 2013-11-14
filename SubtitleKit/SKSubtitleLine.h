//
//  SKSubtitleLine.h
//  Subtitler
//
//  Created by Maxthon Chan on 13-6-13.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import <MSBooster/MSBooster.h>
#import <SubtitleKit/SKSubtitleTrack.h>

__BEGIN_DECLS

/**
 Generate the float point time from components.
 
 @param     hour        Number of hours.
 @param     minute      Number of minutes.
 @param     second      Number of seconds.
 @param     millisecond Number of milliseconds.
 @param     offset      Time offset.
 @return    Float point time interval.
 */
extern NSTimeInterval SKTimeIntervalFromComponents(NSUInteger hour, NSUInteger minute, NSUInteger second, NSUInteger millisecond, NSTimeInterval offset);

/**
 Break float point time into components.
 
 @param     interval    Float point time interval.
 @param     hour        Number of hours.
 @param     minute      Number of minutes.
 @param     second      Number of seconds.
 @param     millisecond Number of milliseconds.
 */
extern void SKComponentsFromTimeInterval(NSTimeInterval interval, NSUInteger *hour, NSUInteger *minute, NSUInteger *second, NSUInteger *millisecond);

/**
 `SKSubtitleLine` represents a timed line in subtitle file.
 */
@interface SKSubtitleLine : NSObject <NSCopying, NSCoding>

/// @name   Time tag

/**
 Start time of the line.
 */
@property NSTimeInterval start;

/**
 Duration of the line.
 */
@property NSTimeInterval duration;

/**
 End time of the line.
 */
@property NSTimeInterval end;

/// @name   Content of the line

/**
 Content of the line.
 */
@property id content;

/**
 Tag of the line.
 */
@property id tag;

/**
 String representation of the line's content.
 */
- (NSString *)stringContent;

/// @name   Comparing lines

/**
 Compare two lines' starting time.
 
 @param     other       Comparison target.
 @see       -[SKSubtitleTrack sortLines]
 */
- (NSComparisonResult)timeCompare:(SKSubtitleLine *)other;

/**
 Tell if the lines are equal.
 
 @param     line        Comparison target.
 */
- (BOOL)isEqualToLine:(SKSubtitleLine *)line;

@end

__END_DECLS
