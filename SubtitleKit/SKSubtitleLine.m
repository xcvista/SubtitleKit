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
#import <MSBooster/MSBooster_Private.h>

MSConstantString(_SKSubtitleLineStartKey, start);
MSConstantString(_SKSubtitleLineDurationKey, duration);
MSConstantString(_SKSubtitleLineContentKey, content);

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
    BOOL dead = NO;
    [self willChangeValueForKey:@"duration"];
    @synchronized (self)
    {
        if (end >= _start)
            _duration = end - _start;
        else
            dead = YES;
    }
    [self didChangeValueForKey:@"duration"];
    if (dead)
        [NSException raise:NSInvalidArgumentException
                    format:@"End time earlier than start time: %.2lf > %.2lf", end, _start];
}

- (NSComparisonResult)timeCompare:(SKSubtitleLine *)other
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

- (BOOL)isEqualToLine:(SKSubtitleLine *)line
{
    return (self.start == line.start) && (self.duration == line.duration) && [self.content isEqual:line.content];
}

- (NSUInteger)hash
{
    return [@(self.start) hash] ^ [@(self.duration) hash] ^ [self.content hash];
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[self class]])
        return [self isEqualToLine:object];
    else
        return NO;
}

@end

void SKComponentsFromTimeInterval(NSTimeInterval interval, NSUInteger *hour, NSUInteger *minute, NSUInteger *second, NSUInteger *millisecond)
{
    if (hour)
    {
        MSAssignPointer(hour, (NSUInteger)(interval / 3600.0));
        interval -= (*hour) * 3600.0;
    }
    
    if (minute)
    {
        MSAssignPointer(minute, (NSUInteger)(interval / 60.0));
        interval -= (*minute) * 60.0;
    }
    
    if (second)
    {
        MSAssignPointer(second, (NSUInteger)interval);
        interval -= (*second);
    }
    
    MSAssignPointer(millisecond, (NSUInteger)(round(interval * 1000.0)));
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
