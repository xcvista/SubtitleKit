//
//  SKSubtitleTrack.m
//  Subtitler
//
//  Created by Maxthon Chan on 13-6-12.
//  Copyright (c) 2013年 muski. All rights reserved.
//

#import "SKSubtitleTrack.h"
#import "SKSubtitleLine.h"

#define __REQUIRE_OBJC_ARC_OR_GC
#define __REQUIRE_OBJC_SUBSCRIPTING
#define __REQUIRE_BLOCKS
#import "SKCommon_private.h"

NSStringConstant(_SKSubtitleTrackLinesKey, lines);
NSStringConstant(_SKSubtitleTrackMetadataKey, metadata);

@implementation SKSubtitleTrack

@synthesize tag = _tag;
@dynamic lines;
@dynamic metadata;

- (id)init
{
    self = [super init];
    if (self) {
        _lines = [NSMutableArray array];
        _metadata = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray *)lines
{
    @synchronized (_lines)
    {
        return [NSArray arrayWithArray:_lines];
    }
}

- (void)setLines:(NSArray *)lines
{
    if (lines)
    {
        NSSynchronizedModifyWithLock(self,
                                     _lines,
                                     _SKSubtitleTrackLinesKey,
                                     ^{
                                         _lines = [NSMutableArray arrayWithArray:lines];
                                     });
    }
}

- (NSDictionary *)metadata
{
    @synchronized (_metadata)
    {
        return [NSDictionary dictionaryWithDictionary:_metadata];
    }
}

- (void)setMetadata:(NSDictionary *)metadata
{
    if (metadata)
    {
        NSSynchronizedModifyWithLock(self,
                                     _metadata,
                                     _SKSubtitleTrackMetadataKey,
                                     ^{
                                         _metadata = [NSMutableDictionary dictionaryWithDictionary:metadata];
                                     });
    }
}

#pragma mark - Fast enumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])buffer
                                    count:(NSUInteger)len
{
    return [_lines countByEnumeratingWithState:state
                                       objects:buffer
                                         count:len];
}

@end

@implementation SKSubtitleTrack (NSCopying)

- (id)copyWithZone:(NSZone *)zone
{
    id newSelf = [[[self class] allocWithZone:zone] init];
    if (newSelf)
    {
        for (SKSubtitleLine *line in [self lines])
        {
            [newSelf addLine:[line copy]];
        }
        for (id key in [self metadata])
        {
            id value = self[key];
            if ([value conformsToProtocol:@protocol(NSCopying)])
                value = [value copy];
            newSelf[key] = value;
        }
    }
    return newSelf;
}

@end

@implementation SKSubtitleTrack (NSCoding)

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        [self setMetadata:[coder decodeObjectForKey:_SKSubtitleTrackMetadataKey]];
        [self setLines:[coder decodeObjectForKey:_SKSubtitleTrackLinesKey]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self metadata] forKey:_SKSubtitleTrackMetadataKey];
    [aCoder encodeObject:[self lines] forKey:_SKSubtitleTrackLinesKey];
}

@end

@implementation SKSubtitleTrack (SKManipulation)

#pragma mark - Line manipulation

- (SKSubtitleLine *)lineAtIndex:(NSUInteger)index
{
    @synchronized (_lines)
    {
        return _lines[index];
    }
}

- (void)setLine:(SKSubtitleLine *)line atIndex:(NSUInteger)index
{
    NSSynchronizedModifyWithLock(self,
                                 _lines,
                                 _SKSubtitleTrackLinesKey,
                                 ^{
                                     _lines[index] = line;
                                 });
}

- (void)addLine:(SKSubtitleLine *)line
{
    NSSynchronizedModifyWithLock(self,
                                 _lines,
                                 _SKSubtitleTrackLinesKey,
                                 ^{
                                     [_lines addObject:line];
                                 });
}

- (void)removeLineAtIndex:(NSUInteger)index
{
    NSSynchronizedModifyWithLock(self,
                                 _lines,
                                 _SKSubtitleTrackLinesKey,
                                 ^{
                                     [_lines removeObjectAtIndex:index];
                                 });
}

- (void)setObject:(SKSubtitleLine *)object atIndexedSubscript:(NSUInteger)index
{
    [self setLine:object atIndex:index];
}

- (SKSubtitleLine *)objectAtIndexedSubscript:(NSUInteger)index
{
    return [self lineAtIndex:index];
}

- (void)sortLines
{
    NSSynchronizedModifyWithLock(self,
                                 _lines,
                                 _SKSubtitleTrackLinesKey,
                                 ^{
                                     [_lines sortUsingSelector:@selector(compare:)];
                                 });
}

- (NSUInteger)lineCount
{
    @synchronized (_lines)
    {
        return [_lines count];
    }
}

#pragma mark - Metadata manipulation

- (id)metadataForKey:(NSString *)key
{
    @synchronized (_metadata)
    {
        return _metadata[key];
    }
}

- (void)setMetadata:(id)metadata forKey:(NSString *)key
{
    NSSynchronizedModifyWithLock(self,
                                 _metadata,
                                 _SKSubtitleTrackMetadataKey,
                                 ^{
                                     if (metadata)
                                         _metadata[key] = metadata;
                                     else
                                         [_metadata removeObjectForKey:key];
                                 });
}

- (void)removeMetadataForKey:(NSString *)key
{
    NSSynchronizedModifyWithLock(self,
                                 _metadata,
                                 _SKSubtitleTrackMetadataKey,
                                 ^{
                                     [_metadata removeObjectForKey:key];
                                 });
}

- (void)setObject:(id)object forKeyedSubscript:(NSString *)key
{
    [self setMetadata:object forKey:key];
}

- (id)objectForKeyedSubscript:(NSString *)key
{
    return [self metadataForKey:key];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@:\n%@\n%@", self.metadata[SKTitleMetadataKey], self.metadata, self.lines];
}

@end

#pragma mark - Constants

NSStringConstant(SKTitleMetadataKey, Title);
NSStringConstant(SKArtistMetadataKey, Artist);
NSStringConstant(SKAlbumMetadataKey, Album);
NSStringConstant(SKWriterMetadataKey, Writer);
NSStringConstant(SKComposerMetadataKey, Composer);
NSStringConstant(SKProducerMetadataKey, Producer);
NSStringConstant(SKCopyrightMetadataKey, Copyright);
NSStringConstant(SKMakerMetadataKey, Maker);
NSStringConstant(SKApplicationMetadataKey, Application);
NSStringConstant(SKApplicationVersionMetadataKey, Version);
