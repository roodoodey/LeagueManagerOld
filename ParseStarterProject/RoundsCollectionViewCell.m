//
//  RoundsCollectionViewCell.m
//  ParseStarterProject
//
//  Created by Mathieu Skulason on 28/06/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "RoundsCollectionViewCell.h"
#import "UIColor+Chameleon.h"
#import "UIFont+ArialAndHelveticaNeue.h"

@interface RoundsCollectionViewCell () {
    UIBezierPath *path;
}

@end

@implementation RoundsCollectionViewCell

@synthesize roundNumberLabel;

-(id)init {
    if (self = [super init]) {
        [self addBezierPath];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSLog(@"initializing collection view cell");
        [self addBezierPath];
        self.backgroundColor = [UIColor flatWhiteColor];
        roundNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) * 0.7, CGRectGetHeight(self.frame))];
        roundNumberLabel.font = [UIFont openSansBoldWithSize:17.0];
        roundNumberLabel.textAlignment = NSTextAlignmentCenter;  
        [self addSubview:roundNumberLabel];
    }
    
    return self;
}

-(void)addBezierPath {
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(CGRectGetWidth(self.frame) * 0.7, 0)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - 1.5, CGRectGetHeight(self.frame) * 0.5)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) * 0.7, CGRectGetHeight(self.frame) - 1.5)];
    [path addLineToPoint:CGPointMake(0, CGRectGetHeight(self.frame) - 1.5)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 1.5)];
    
    path.lineWidth = 3.0;
    
}

-(void)drawRect:(CGRect)rect {
    [[UIColor flatBlackColor] setStroke];
    [path stroke];
}

@end
