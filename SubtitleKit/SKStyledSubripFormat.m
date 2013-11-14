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

@implementation SKStyledSubripFormat

+ (id)lineContentFromLine:(NSString *)content
{
    // Translate outdated HTML into HTML5+CSS3
    
    NSMutableString *buffer = [NSMutableString string];
    NSScanner *scanner = [NSScanner scannerWithString:content];
    
    while (![scanner isAtEnd])
    {
        NSString *buf = NULL;
        if ([scanner _SKStyledSubripScanUpToHTMLTag:&buf])
        {
            [buffer appendString:buf];
        }
        
        NSString *tagname = NULL;
        BOOL status;
        NSDictionary *properties = NULL;
        if ([scanner _SKStyledSubripScanHTMLTag:&tagname
                                   isTerminatng:&status
                                     attributes:&properties])
        {
            NSString *tagname2 = [[tagname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
            
            if ([@[@"b", @"i", @"u", @"font"] containsObject:tagname2])
            {
                if (status)
                {
                    [buffer appendString:@"</span>"];
                }
                else
                {
                    if ([tagname2 isEqualToString:@"b"])
                    {
                        [buffer appendString:@"<span style=\"font-weight: bold;\">"];
                    }
                    else if ([tagname2 isEqualToString:@"i"])
                    {
                        [buffer appendString:@"<span style=\"font-style: italic;\">"];
                    }
                    else if ([tagname2 isEqualToString:@"u"])
                    {
                        [buffer appendString:@"<span style=\"text-decoration: underline\">"];
                    }
                    else if ([tagname2 isEqualToString:@"font"])
                    {
                        NSMutableString *agg = [NSMutableString string];
                        
                        for (NSString *key in properties)
                        {
                            NSString *k = [[key lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            NSString *v = properties[key];
                            if ([k isEqualToString:@"color"])
                            {
                                [agg appendFormat:@"color: %@;", v];
                            }
                            else if ([k isEqualToString:@"size"])
                            {
                                [agg appendFormat:@"font-size: %@;", v];
                            }
                            else if ([k isEqualToString:@"face"])
                            {
                                [agg appendFormat:@"font-family: %@", v];
                            }
                        }
                        
                        [buffer appendFormat:@"<span style=\"%@\">", agg];
                    }
                }
            }
            else
            {
                NSMutableString *agg = [NSMutableString string];
                [properties enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    [agg appendFormat:@"%@=\"%@\"", key, obj];
                }];
                
                [buffer appendFormat:@"<%@%@ %@>", status ? @"/" : @"", tagname, status ? @"" : agg];
            }
        }
    }
    
    NSDictionary *HTMLAttributes = @{
                                     NSDocumentTypeDocumentAttribute:
                                         NSHTMLTextDocumentType};
    NSAttributedString *string = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options:HTMLAttributes
                                                       documentAttributes:NULL
                                                                    error:NULL];
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
