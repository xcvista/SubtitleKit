//
//  SKSubtitleWritingTest.m
//  SubtitleKit
//
//  Created by Maxthon Chan on 11/4/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <SubtitleKit/SubtitleKit.h>

@interface SKSubtitleWritingTest : SenTestCase

@end

@implementation SKSubtitleWritingTest

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

- (SKSubtitleLine *)lineWithStart:(NSTimeInterval)start duration:(NSTimeInterval)duration showStart:(BOOL)show
{
    SKSubtitleLine *line = [[SKSubtitleLine alloc] init];
    line.start = start;
    line.duration = duration;
    line.content = MSSTR(@"%@-%.1lf", (show) ? MSSTR(@"%.1lf", start) : @"x.x", duration);
    return line;
}

- (void)testSubtitleWriting
{
    SKSubtitleTrack *track = [[SKSubtitleTrack alloc] init];
    
    [track addLine:[self lineWithStart:0 duration:1 showStart:YES]];
    [track addLine:[self lineWithStart:1 duration:0.5 showStart:YES]];
    [track addLine:[self lineWithStart:5 duration:2 showStart:YES]];
    
    // Load the file
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    NSString *string = [NSString stringWithContentsOfURL:[thisBundle URLForResource:@"Test" withExtension:@"srt"]
                                            usedEncoding:NULL
                                                   error:NULL];
    NSString *result = [SKSubripFormat stringFromTrack:track];
    
    STAssertNotNil(track, nil);
    STAssertNotNil(string, nil);
    STAssertEqualObjects([string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]],
                         [result stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]], nil);
}

- (void)testSubtitleWritingOverlapping
{
    SKSubtitleTrack *track = [[SKSubtitleTrack alloc] init];
    
    [track addLine:[self lineWithStart:0 duration:1 showStart:YES]];
    [track addLine:[self lineWithStart:0.5 duration:1 showStart:YES]];
    [track addLine:[self lineWithStart:0 duration:2 showStart:YES]];
    
    // Load the file
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    NSString *string = [NSString stringWithContentsOfURL:[thisBundle URLForResource:@"TestOverlapping" withExtension:@"srt"]
                                            usedEncoding:NULL
                                                   error:NULL];
    NSString *result = [SKSubripFormat stringFromTrack:track];
    
    STAssertNotNil(track, nil);
    STAssertNotNil(string, nil);
    STAssertEqualObjects([string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]],
                         [result stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]], nil);
}

@end
