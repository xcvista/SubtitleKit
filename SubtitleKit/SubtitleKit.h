//
//  SubtitleKit.h
//  SubtitleKit
//
//  Created by Maxthon Chan on 10/31/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#import <SubtitleKit/SKLyricFormat.h>
#import <SubtitleKit/SKPropertyListFormat.h>
#import <SubtitleKit/SKSubripFormat.h>
#import <SubtitleKit/SKSubtitleFormat.h>
#import <SubtitleKit/SKSubtitleLine.h>
#import <SubtitleKit/SKSubtitleTrack.h>
#import <SubtitleKit/SKTextSubtitleFormat.h>

#import <SubtitleKit/SKLyricFormatStrings.h>
#import <SubtitleKit/SKSubtitleTrackStrings.h>