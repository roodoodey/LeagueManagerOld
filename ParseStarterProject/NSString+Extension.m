//
//  NSString+Extension.m
//  ParseStarterProject
//
//  Created by Mathieu Skulason on 26/06/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "NSString+Extension.h"

const CGFloat maxHeight = 900;

@implementation NSString (Extension)

+(NSString*)generateRandStringWithLength:(int)length
{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    
    NSMutableString *string = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        u_int32_t pos = arc4random()%[alphabet length];
        unichar c = [alphabet characterAtIndex:pos];
        
        [string appendFormat:@"%C", c];
    }
    
    
    return string;
}

-(CGFloat)heightForTextWithdWidth:(CGFloat)theWidth andFont:(UIFont *)theFont
{
    if (self) {
        
        CGSize size = CGSizeMake(theWidth, maxHeight);
        
        CGRect newRect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: theFont } context:nil];
        
        return newRect.size.height;
    }
    
    return 0;
}

-(NSString*)lastSeperatedComponentWithSeparator:(NSString*)separator {
    
    NSArray *separatedStrings = [self componentsSeparatedByString:separator];
    
    return [separatedStrings objectAtIndex:separatedStrings.count -1];
    
}

@end
