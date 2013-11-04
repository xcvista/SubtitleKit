//
//  SKLyricWritingTest.m
//  SubtitleKit
//
//  Created by Maxthon Chan on 11/4/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <SubtitleKit/SubtitleKit.h>

@interface SKLyricWritingTest : SenTestCase

@end

@implementation SKLyricWritingTest

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

- (NSArray *)lastThreeLines:(NSString *)string
{
    NSArray *lines = [[string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return [lines subarrayWithRange:NSMakeRange([lines count] - 3, 3)];
}

- (void)testLyricWritingUncompressed
{
    SKSubtitleTrack *track = [[SKSubtitleTrack alloc] init];
    
    track[SKArtistMetadataKey] = @"Test";
    track[SKAlbumMetadataKey] = @"Foo";
    track[SKTitleMetadataKey] = @"Bar";
    track[SKMakerMetadataKey] = @"Someone";
    
    [track addLine:[self lineWithStart:0 duration:1 showStart:YES]];
    [track addLine:[self lineWithStart:1 duration:0.5 showStart:YES]];
    [track addLine:[self lineWithStart:1.5 duration:0 showStart:YES]];
    
    // Load the file
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    NSString *string = [NSString stringWithContentsOfURL:[thisBundle URLForResource:@"Test" withExtension:@"lrc"]
                                            usedEncoding:NULL
                                                   error:NULL];
    NSString *result = [SKLyricFormat stringFromTrack:track compressed:NO];
    
    STAssertNotNil(track, nil);
    STAssertNotNil(string, nil);
    STAssertEqualObjects([self lastThreeLines:string], [self lastThreeLines:result], nil);
}

- (void)testLyricWritingCompressed
{
    SKSubtitleTrack *track = [[SKSubtitleTrack alloc] init];
    
    track[SKArtistMetadataKey] = @"Test";
    track[SKAlbumMetadataKey] = @"Foo";
    track[SKTitleMetadataKey] = @"Bar";
    track[SKMakerMetadataKey] = @"Someone";
    
    for (NSNumber *time in @[@0, @1, @2])
        [track addLine:[self lineWithStart:[time doubleValue] duration:1 showStart:NO]];
    for (NSNumber *time in @[@3, @3.5, @4])
        [track addLine:[self lineWithStart:[time doubleValue] duration:0.5 showStart:NO]];
    [track addLine:[self lineWithStart:4.5 duration:0 showStart:NO]];
    
    // Load the file
    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    NSString *string = [NSString stringWithContentsOfURL:[thisBundle URLForResource:@"TestCompressed" withExtension:@"lrc"]
                                            usedEncoding:NULL
                                                   error:NULL];
    NSString *result = [SKLyricFormat stringFromTrack:track compressed:YES];
    
    STAssertNotNil(track, nil);
    STAssertNotNil(string, nil);
    STAssertEqualObjects([self lastThreeLines:string], [self lastThreeLines:result], nil);
}

@end
