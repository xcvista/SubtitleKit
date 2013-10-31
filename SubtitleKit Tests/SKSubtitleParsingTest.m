//
//  SKSubtitleParsingTest.m
//  SubtitleKit
//
//  Created by Maxthon Chan on 10/31/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <SubtitleKit/SubtitleKit.h>

@interface SKSubtitleParsingTest : SenTestCase

@end

@implementation SKSubtitleParsingTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class. 
    [super tearDown];
}

- (void)testSubtitleParsing
{
    // Load the file
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    
    SKSubtitleTrack *track = [SKSubripFormat trackFromContentsOfURL:[thisBundle URLForResource:@"Test" withExtension:@"srt"]];
    STAssertNotNil(track, nil);
    
    // Timetags
    for (SKSubtitleLine *line in track.lines)
    {
        STAssertEqualObjects(MSSTR(@"%.1lf-%.1lf", line.start, line.duration), line.content, nil);
    }
}

- (void)testOverlappingSubtitleParsing
{
    // Load the file
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    
    SKSubtitleTrack *track = [SKSubripFormat trackFromContentsOfURL:[thisBundle URLForResource:@"TestOverlapping" withExtension:@"srt"]];
    STAssertNotNil(track, nil);
    
    // Timetags
    for (SKSubtitleLine *line in track.lines)
    {
        STAssertEqualObjects(MSSTR(@"%.1lf-%.1lf", line.start, line.duration), line.content, nil);
    }
}

- (void)testSkippingSubtitleParsing
{
    // Load the file
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    
    SKSubtitleTrack *track = [SKSubripFormat trackFromContentsOfURL:[thisBundle URLForResource:@"TestSkipping" withExtension:@"srt"]];
    STAssertNotNil(track, nil);
    
    // Timetags
    for (SKSubtitleLine *line in track.lines)
    {
        STAssertEqualObjects(MSSTR(@"%.1lf-%.1lf", line.start, line.duration), line.content, nil);
    }
}

- (void)testEmptyFile
{
    // Load the file
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    
    SKSubtitleTrack *track = [SKSubripFormat trackFromContentsOfURL:[thisBundle URLForResource:@"Empty" withExtension:@"txt"]];
    STAssertEqualObjects(track, [[SKSubtitleTrack alloc] init], nil);
}

- (void)testOneReturnFile
{
    // Load the file
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    
    SKSubtitleTrack *track = [SKSubripFormat trackFromContentsOfURL:[thisBundle URLForResource:@"Oneline" withExtension:@"txt"]];
    STAssertEqualObjects(track, [[SKSubtitleTrack alloc] init], nil);
}

@end
