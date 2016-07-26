//
//  NSString+Extension.h
//  ParseStarterProject
//
//  Created by Mathieu Skulason on 26/06/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

+(NSString*)generateRandStringWithLength:(int)length;

-(CGFloat)heightForTextWithdWidth:(CGFloat)theWidth andFont:(UIFont*)theFont;
-(NSString*)lastSeperatedComponentWithSeparator:(NSString*)separator;

@end
