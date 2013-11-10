//
//  SKStyledSubripFormat.m
//  SubtitleKit
//
//  Created by Maxthon Chan on 11/4/13.
//  Copyright (c) 2013 muski. All rights reserved.
//

#import "SKStyledSubripFormat.h"
#if TARGET_OS_IPHONE || TARGET_OS_EMBEDDED
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

/*
 
#import <MSBooster/MSBooster.h>

@interface NSScanner (SKHTMLScanner)

- (BOOL)_SKStyledSubripScanUpToHTMLTag:(NSString **)buffer;
- (BOOL)_SKStyledSubripScanHTMLTag:(NSString **)tagContent isTerminatng:(BOOL *)terminating attributes:(NSDictionary **)attributes;

@end

@implementation NSScanner (SKHTMLScanner)

- (BOOL)_SKStyledSubripScanUpToHTMLTag:(NSString *__autoreleasing *)buffer
{
    NSString *buf = nil;
    MSScannerBegin();
    MSScannerAssert([self scanUpToString:@"<" intoString:&buf]);
    MSAssignPointer(buffer, buf);
    return YES;
}

- (BOOL)_SKStyledSubripScanHTMLTag:(NSString *__autoreleasing *)tagContent
{
    MSScannerBegin();
    NSString *buf = nil;
    MSScannerAssert([self scanString:@"<" intoString:NULL]);
    MSScannerAssert([self scanUpToString:@">" intoString:&buf]);
    MSScannerAssert([self scanString:@">" intoString:NULL]);
    MSAssignPointer(tagContent, buf);
    return YES;
}

- (BOOL)_SKStyledSubripScanHTML:(NSString *__autoreleasing *)tagContent
                   isTerminatng:(BOOL *)terminating
                     attributes:(NSDictionary *__autoreleasing *)attributes
{
    NSString *name = nil;
    NSString *terminator = nil;
    NSMutableDictionary *attrib = [NSMutableDictionary dictionary];
    MSScannerBegin();
    
    NSCharacterSet *ignores = [self charactersToBeSkipped];
    [self setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self scanString:@"/" intoString:&terminator] && [terminator length])
    {
        MSScannerAssert([self scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
                                             intoString:&name]);
        
        MSAssignPointer(tagContent, name);
        MSAssignPointer(terminating, YES);
    }
    else
    {
        MSScannerAssert([self scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
                                             intoString:&name]);
        
        while (![self isAtEnd])
        {
            NSString *attribName = nil, *attribValue = nil, *quote = nil, *equals = nil;
            [self scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]
                             intoString:NULL];
            if ([self scanUpToCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:&attribName] && [attribName length])
            {
                if ([self scanString:@"=" intoString:&equals] && [equals length])
                {
                    if ([self scanString:@"\"" intoString:&quote] && [quote length])
                    {
                        MSScannerAssert([self scanUpToString:@"\"" intoString:&attribValue]);
                        MSScannerAssert([self scanString:@"\"" intoString:NULL]);
                    }
                    else
                    {
                        NSString *remains = [[self string] substringFromIndex:[self scanLocation]];
                        if ([remains rangeOfString:@" "].location != NSNotFound)
                        {
                            MSScannerAssert([self scanUpToString:@" " intoString:&attribValue]);
                        }
                        else
                        {
                            attribValue = remains;
                            [self setScanLocation:[self scanLocation] + [remains length]];
                        }
                    }
                    
                    attrib[attribName] = attribValue;
                }
                else
                {
                    attrib[attribName] = attribName;
                }
            }
            
            [self scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:NULL];
        }
        
        MSAssignPointer(tagContent, name);
        MSAssignPointer(terminating, NO);
        MSAssignPointer(attributes, attrib);
        
    }
    
    [self setCharactersToBeSkipped:ignores];
    return YES;
}

- (BOOL)_SKStyledSubripScanHTMLTag:(NSString *__autoreleasing *)tagContent
                      isTerminatng:(BOOL *)terminating
                        attributes:(NSDictionary *__autoreleasing *)attributes
{
    MSScannerBegin();
    NSString *tag = nil;
    
    MSScannerAssert([self _SKStyledSubripScanHTMLTag:&tag]);
    
    NSScanner *tagScanner = [NSScanner scannerWithString:tag];
    MSScannerAssert([tagScanner _SKStyledSubripScanHTML:tagContent isTerminatng:terminating attributes:attributes]);
    return YES;
}

@end

@interface _SKStyledLyricsOptionsStack : NSObject

@property NSString *tag;
@property NSDictionary *attrib;
@property NSUInteger location;

+ (instancetype)stackItemWithTag:(NSString *)tag attributes:(NSDictionary *)attributes location:(NSUInteger)loc;

@end

@implementation _SKStyledLyricsOptionsStack

+ (instancetype)stackItemWithTag:(NSString *)tag attributes:(NSDictionary *)attributes location:(NSUInteger)loc
{
    _SKStyledLyricsOptionsStack *_self = [[self alloc] init];
    if (_self)
    {
        _self.tag = tag;
        _self.attrib = attributes;
        _self.location = loc;
    }
    return _self;
}

@end

@interface _SKAttributeStorage : NSObject

@property NSRange range;
@property NSDictionary *attributes;

@end

@implementation _SKAttributeStorage

@end

@implementation SKStyledSubripFormat

+ (id)lineContentFromLine:(NSString *)content
{
    NSMutableString *string = [NSMutableString stringWithCapacity:[content length]];
    NSMutableArray *attributes = [NSMutableArray array];
    NSMutableArray *symbolStack = [NSMutableArray array];
    
    NSScanner *scanner = [NSScanner scannerWithString:[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    while (![scanner isAtEnd])
    {
        NSString *buffer = nil;
        if ([scanner _SKStyledSubripScanUpToHTMLTag:&buffer] && [buffer length])
        {
            [string appendString:buffer];
        }
        
        NSString *tag = nil;
        BOOL terminating = NO;
        NSDictionary *attrib;
        if ([scanner _SKStyledSubripScanHTMLTag:&tag isTerminatng:&terminating attributes:&attrib] && [tag length])
        {
            if (terminating)
            {
                // Pop a level of
                
            }
        }
    }
    
    return nil;
}

+ (NSString *)lineFromLineContent:(id)content
{
    if ([content isKindOfClass:[NSAttributedString class]])
    {
        return nil;
    }
    else
        return content;
}

@end
 */

@implementation SKStyledSubripFormat

+ (id)lineContentFromLine:(NSString *)content
{
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTML:[content dataUsingEncoding:NSUTF8StringEncoding]
                                                       documentAttributes:NULL];
    if (![string isKindOfClass:[NSAttributedString class]])
        string = [[NSAttributedString alloc] initWithString:content];
    return string;
}

+ (NSString *)lineFromLineContent:(id)content
{
    if ([content isKindOfClass:[NSAttributedString class]])
    {
        NSAttributedString *string = content;
        NSDictionary *HTMLAttributes = @{
                                         NSDocumentTypeDocumentAttribute:
                                             NSHTMLTextDocumentType,
                                         NSExcludedElementsDocumentAttribute:
                                             @[
                                                 @"DOCTYPE",
                                                 @"html"
                                                 @"head"
                                                 @"body"
                                                 @"meta"
                                                 ],
                                         };
        NSData *data = [string dataFromRange:NSMakeRange(0, [string length])
                          documentAttributes:HTMLAttributes
                                       error:NULL];
        if (!data)
            return nil;
        
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else
    {
        return [super lineFromLineContent:content];
    }
}

@end
