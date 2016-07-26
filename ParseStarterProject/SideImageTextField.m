//
//  GLOOPSTextField.m
//  Gloops
//
//  Created by Mathieu Skulason on 25/04/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "SideImageTextField.h"
#import "UIColor+Extension.h"
#import "Chameleon.h"
#import "UIFont+ArialAndHelveticaNeue.h"

@implementation SideImageTextField

@synthesize iconBackgroundView;
@synthesize iconImageView;
@synthesize textField;

-(id)init {
    if (self = [super init]) {
        self.layer.cornerRadius = 4.0f;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.borderColor = [UIColor flatGrayColor].CGColor;
        self.layer.borderWidth = 0.8f;
        self.layer.masksToBounds = YES;
        
        iconBackgroundView = [[UIView alloc] init];
        iconBackgroundView.backgroundColor = [UIColor flatWhiteColorDark];
        [self addSubview:iconBackgroundView];
        
        iconImageView = [[UIImageView alloc] init];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iconImageView];
        
        textField = [[UITextField alloc] init];
        textField.font = [UIFont openSansItalicWithSize:15.0];
        textField.textColor = [UIColor flatBlackColor];
        textField.returnKeyType = UIReturnKeyDone;
        [self addSubview:textField];
        
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 4.0f;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.layer.borderColor = [UIColor flatGrayColor].CGColor;
        self.layer.borderWidth = 0.8f;
        self.layer.masksToBounds = YES;
        
         iconBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame))];
        iconBackgroundView.backgroundColor = [UIColor flatWhiteColorDark];
        [self addSubview:iconBackgroundView];
        
        iconImageView = [[UIImageView alloc] initWithFrame:iconBackgroundView.frame];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iconImageView];
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(iconBackgroundView.frame) + 3, 0, CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame) - 6, CGRectGetHeight(self.frame))];
        textField.font = [UIFont helveticaNeueItalicWithSize:13.0f];
        textField.textColor = [UIColor flatBlackColor];
        textField.returnKeyType = UIReturnKeyDone;
        [self addSubview:textField];
        
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    iconBackgroundView.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
    iconImageView.frame = iconBackgroundView.frame;
    textField.frame = CGRectMake(CGRectGetWidth(iconBackgroundView.frame) + 3, 0, CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame) - 6, CGRectGetHeight(self.frame));
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
