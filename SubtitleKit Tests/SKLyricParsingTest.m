//
//  SKLyricParsingTest.m
//  SubtitleKit
//
//  Created by Maxthon Chan on 10/31/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <SubtitleKit/SubtitleKit.h>

@interface SKLyricParsingTest : SenTestCase

@end

@implementation SKLyricParsingTest

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

- (void)testLRCParsing
{
    // Load the file
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    
    SKSubtitleTrack *track = [SKLyricFormat trackFromContentsOfURL:[thisBundle URLForResource:@"Test" withExtension:@"lrc"]];
    STAssertNotNil(track, nil);
    
    // Metadata
    STAssertEqualObjects(track[SKArtistMetadataKey], @"Test", nil);
    STAssertEqualObjects(track[SKAlbumMetadataKey], @"Foo", nil);
    STAssertEqualObjects(track[SKTitleMetadataKey], @"Bar", nil);
    STAssertEqualObjects(track[SKMakerMetadataKey], @"Someone", nil);
    
    // Timetags
    for (SKSubtitleLine *line in track.lines)
    {
        STAssertEqualObjects(MSSTR(@"%.1lf-%.1lf", line.start, line.duration), line.content, nil);
    }
}

- (void)testLRCOffset
{
    // Load the file
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    
    SKSubtitleTrack *track = [SKLyricFormat trackFromContentsOfURL:[thisBundle URLForResource:@"TestOffset" withExtension:@"lrc"]];
    STAssertNotNil(track, nil);
    
    // Metadata
    STAssertEqualObjects(track[SKArtistMetadataKey], @"Test", nil);
    STAssertEqualObjects(track[SKAlbumMetadataKey], @"Foo", nil);
    STAssertEqualObjects(track[SKTitleMetadataKey], @"Bar", nil);
    STAssertEqualObjects(track[SKMakerMetadataKey], @"Someone", nil);
    
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
    
    SKSubtitleTrack *track = [SKLyricFormat trackFromContentsOfURL:[thisBundle URLForResource:@"Empty" withExtension:@"txt"]];
    STAssertEqualObjects(track, [[SKSubtitleTrack alloc] init], nil);
}

- (void)testOneReturnFile
{
    // Load the file
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    
    SKSubtitleTrack *track = [SKLyricFormat trackFromContentsOfURL:[thisBundle URLForResource:@"Oneline" withExtension:@"txt"]];
    STAssertEqualObjects(track, [[SKSubtitleTrack alloc] init], nil);
}

@end
