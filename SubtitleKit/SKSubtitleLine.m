//
//  SKSubtitleLine.m
//  Subtitler
//
//  Created by Maxthon Chan on 13-6-13.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "SKSubtitleLine.h"

#define __REQUIRE_OBJC_SUBSCRIPTING
#define __REQUIRE_OBJC_ARRAY_LITERALS
#import "SKCommon_private.h"

NSStringConstant(_SKSubtitleLineStartKey, start);
NSStringConstant(_SKSubtitleLineDurationKey, duration);
NSStringConstant(_SKSubtitleLineContentKey, content);

@implementation SKSubtitleLine

@synthesize start = _start;
@synthesize duration = _duration;
@synthesize content = _content;
@synthesize tag = _tag;

- (id)copyWithZone:(NSZone *)zone
{
    SKSubtitleLine *newSelf = [[[self class] allocWithZone:zone] init];
    if (newSelf)
    {
        newSelf.start = self.start;
        newSelf.duration = self.duration;
        newSelf.content = ([self.content conformsToProtocol:@protocol(NSCopying)]) ? [self.content copy] : self.content;
    }
    return newSelf;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        NSArray *keys = @[_SKSubtitleLineStartKey, _SKSubtitleLineDurationKey, _SKSubtitleLineContentKey];
        for (NSString *key in keys)
            [self setValue:[coder decodeObjectForKey:key] forKey:key];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *keys = @[_SKSubtitleLineStartKey, _SKSubtitleLineDurationKey, _SKSubtitleLineContentKey];
    for (NSString *key in keys)
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
}

- (NSTimeInterval)end
{
    @synchronized (self)
    {
        return _start + _duration;
    }
}

- (void)setEnd:(NSTimeInterval)end
{
    __block BOOL dead = NO;
    NSSynchronizedModifyWithLock(self,
                                 self,
                                 @"duration",
                                 ^{
                                     if (end >= _start)
                                         _duration = end - _start;
                                     else
                                         dead = YES;
                                 });
    if (dead)
        [NSException raise:NSInvalidArgumentException
                    format:@"End time earlier than start time: %.2lf > %.2lf", end, _start];
}

- (NSComparisonResult)compare:(SKSubtitleLine *)other
{
    if (self.start < other.start)
        return NSOrderedAscending;
    else if (self.start > other.start)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%.2lf + %.2lf: %@", self.start, self.duration, self.content];
}

@end

void SKComponentsFromTimeInterval(NSTimeInterval interval, NSUInteger *hour, NSUInteger *minute, NSUInteger *second, NSUInteger *millisecond)
{
    if (hour)
    {
        NSAssignPointer(hour, (NSUInteger)(interval / 3600.0));
        interval -= (*hour) * 3600.0;
    }
    
    if (minute)
    {
        NSAssignPointer(minute, (NSUInteger)(interval / 60.0));
        interval -= (*minute) * 60.0;
    }
    
    if (second)
    {
        NSAssignPointer(second, (NSUInteger)interval);
        interval -= (*second);
    }
    
    NSAssignPointer(millisecond, (NSUInteger)(round(interval * 1000.0)));
}

@implementation SKSubtitleTrack (SKOffsetting)

- (void)offsetAllLines:(NSTimeInterval)offset
{
    for (SKSubtitleLine *line in self)
    {
        line.start += offset;
    }
}

@end
