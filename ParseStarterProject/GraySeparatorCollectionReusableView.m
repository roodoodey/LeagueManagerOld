//
//  GraySeparatorCollectionReusableView.m
//  LeagueManager
//
//  Created by Mathieu Skulason on 12/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "GraySeparatorCollectionReusableView.h"
#import "UIColor+Chameleon.h"

@implementation GraySeparatorCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor flatGrayColor];
    }
    
    return self;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.frame = layoutAttributes.frame;
}

@end
