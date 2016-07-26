//
//  MatchCollectionViewCell.m
//  LeagueManager
//
//  Created by Mathieu Skulason on 10/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "MatchCollectionViewCell.h"
#import "UIColor+Chameleon.h"
#import "UIFont+ArialAndHelveticaNeue.h"

@interface MatchCollectionViewCell () <UITextFieldDelegate> {
    void (^comletionBlock)(BOOL succeeded, NSError *error);
}

@end

@implementation MatchCollectionViewCell

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSLog(@"initializing match collection view cell");
        
        self.layer.masksToBounds = YES;
        
        _isTeamOne = NO;
        
        _scoreTextField = [[UITextField alloc] init];
        _scoreTextField.text = @"0";
        _scoreTextField.font = [UIFont openSansBoldWithSize:13.0];
        _scoreTextField.textColor = [UIColor flatBlackColor];
        _scoreTextField.textAlignment = NSTextAlignmentCenter;
        _scoreTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _scoreTextField.textAlignment = NSTextAlignmentCenter;
        _scoreTextField.returnKeyType = UIReturnKeyDone;
        _scoreTextField.delegate = self;
        [self.contentView addSubview:_scoreTextField];
        
        _teamDisplayImageView = [[UIImageView alloc] init];
        _teamDisplayImageView.layer.cornerRadius = _teamDisplayImageView.frame.size.width/2.0;
        _teamDisplayImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_teamDisplayImageView];
        
        _teamNameLabel = [[UILabel alloc] init];
        _teamNameLabel.textColor = [UIColor flatBlackColor];
        _teamNameLabel.textAlignment = NSTextAlignmentCenter;
        _teamNameLabel.font = [UIFont openSansBoldWithSize:12.0];
        _teamNameLabel.textColor = [UIColor flatBlackColor];
        _teamNameLabel.numberOfLines = 2;
        _teamNameLabel.minimumScaleFactor = 0.7;
        [self.contentView insertSubview:_teamNameLabel belowSubview:_scoreTextField];
        
        [self setupLeftPosition];
    }
    
    return self;
}

-(void)invertInterfaceComponents:(BOOL)inverted withAnimation:(BOOL)anim {
    
        
    if (anim) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            if (inverted) {
                [self setupRightPosition];
            }
            else {
                [self setupLeftPosition];
            }
            
        }];
        
    }
    else {
        
        if (inverted) {
            [self setupRightPosition];
        }
        else {
            [self setupLeftPosition];
        }
        
    }
    
}

-(void)setupRightPosition {
    NSLog(@"setting up right position for item");
    _scoreTextField.frame = CGRectMake(10, 0, 40, CGRectGetHeight(self.frame));
    //_teamDisplayImageView.frame = CGRectMake(CGRectGetWidth(self.frame) - 50, 0, 40, CGRectGetMidY(self.frame) - 20);
    _teamNameLabel.frame = CGRectMake(CGRectGetMaxX(_scoreTextField.frame) + 10, 0, CGRectGetWidth(self.frame) - 20 - CGRectGetMaxX(_scoreTextField.frame), CGRectGetHeight(self.frame));
}

-(void)setupLeftPosition {
    NSLog(@"setting up left position for item");
    _scoreTextField.frame = CGRectMake(CGRectGetWidth(self.frame) - 50, 0, 40, CGRectGetHeight(self.frame));
    //_teamDisplayImageView.frame = CGRectMake(10, 10, 40, CGRectGetMidY(self.frame) - 20);
    _teamNameLabel.frame = CGRectMake( 10, 0, CGRectGetMinX(_scoreTextField.frame) - 20, CGRectGetHeight(self.frame));
    
}

#pragma mark - Text Field Delegate and save of match input

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_scoreTextField resignFirstResponder];
    [self saveScore];
    
    return YES;
}

-(void)saveScore {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    
    if ([formatter numberFromString:_scoreTextField.text] == nil) {
        comletionBlock(NO, [[NSError alloc] initWithDomain:@"Input error" code:0 userInfo:@{ NSLocalizedDescriptionKey: @"The format for the score is incorrect, please input a different number." }]);
        return ;
    }
    
    if (_isTeamOne) {
        _matchObject[@"teamOneGoals"] = [formatter numberFromString:_scoreTextField.text];
    }
    else {
        _matchObject[@"teamTwoGoals"] = [formatter numberFromString:_scoreTextField.text];
    }
    
    /*
    [_matchObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        NSLog(@"saved new score");
        
    }];
    */
     
    [_matchObject saveInBackgroundWithBlock:comletionBlock];
}

-(void)saveScoreCompletion:(void (^)(BOOL, NSError *))block {
    [block copy];
    
    comletionBlock = block;
    
}

@end
