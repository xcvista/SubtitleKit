//
//  SKSGMLScannerTest.m
//  SubtitleKit
//
//  Created by Maxthon Chan on 11/6/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <SubtitleKit/SubtitleKit.h>

@interface SKSGMLScannerTest : SenTestCase

@end

@implementation SKSGMLScannerTest

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

- (void)testStyledSubtitleParsing
{
    // Load the file
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    
    SKSubtitleTrack *track = [SKStyledSubripFormat trackFromContentsOfURL:[thisBundle URLForResource:@"TestStyled" withExtension:@"srt"]];
    STAssertNotNil(track, nil);
    
    // Timetags
    for (SKSubtitleLine *line in track.lines)
    {
        NSString *content = ([line.content isKindOfClass:[NSAttributedString class]]) ? [line.content string] : line.content;
        STAssertEqualObjects(MSSTR(@"%.1lf-%.1lf", line.start, line.duration), content, nil);
    }
}

@end
