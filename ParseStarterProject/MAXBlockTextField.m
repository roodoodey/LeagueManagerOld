//
//  MAXBlockTextField.m
//  ReusableComponentsApp
//
//  Created by Mathieu Grettir Skulason on 5/10/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXBlockTextField.h"

typedef BOOL (^BoolCompletion)(void);

@interface MAXBlockTextField () <UITextFieldDelegate> {
    
    BOOL (^_textFieldShouldBeginEditingBlock)(void);
    NSMutableArray *_textFieldDidBeginEditingBlocks;
    BOOL (^_textFieldShouldEndEditingBlock)(void);
    NSMutableArray *_textFieldDidEndEditingBlocks;
    
    BOOL (^_textFieldShouldChangeCharacterInRangeBlock)(NSRange, NSString *);
    BOOL (^_textFieldShouldClearBlock)(void);
    BOOL (^_textFieldShouldReturnBlock)(void);
}

@end

@implementation MAXBlockTextField

-(id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self p_setupMAXBlockTextField];
        
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self p_setupMAXBlockTextField];
        
    }
    
    return self;
}

-(id)init {
    
    if (self = [super init]) {
        
        [self p_setupMAXBlockTextField];
        
    }
    
    return self;
}

-(void)p_setupMAXBlockTextField {
    
    _textFieldShouldBeginEditingBlock = nil;
    _textFieldDidBeginEditingBlocks = [NSMutableArray array];
    _textFieldShouldEndEditingBlock = nil;
    _textFieldDidEndEditingBlocks = [NSMutableArray array];
    
    _textFieldShouldChangeCharacterInRangeBlock = nil;
    _textFieldShouldClearBlock = nil;
    _textFieldShouldReturnBlock = nil;
    
    self.delegate = self;
}

#pragma mark - Setters

-(void)textFieldShouldBeginEditingWithCompletion:(BOOL (^)(void))completion {
    
    _textFieldShouldBeginEditingBlock = [completion copy];
    
}

-(void)textFieldDidBeginEditingWithCompletion:(void (^)(void))completion {
    
    [_textFieldDidBeginEditingBlocks addObject: [completion copy]];
    
}

-(void)textFieldShouldEndEditingWithCompletion:(BOOL (^)(void))completion {
    
    _textFieldShouldEndEditingBlock = [completion copy];
    
}

-(void)textFieldDidEndEditingWithCompletion:(void (^)(void))completion {
    
    [_textFieldDidEndEditingBlocks addObject: [completion copy]];
    
}

-(void)textFieldShouldChangeCharactersInRangeWithCompletion:(BOOL (^)(NSRange, NSString *))completion {
    
    _textFieldShouldChangeCharacterInRangeBlock = [completion copy];
    
}

-(void)textFieldShouldClearWithCompletion:(BOOL (^)(void))completion {
    
    _textFieldShouldClearBlock = [completion copy];
    
}

-(void)textFieldShouldReturnWithCompletion:(BOOL (^)(void))completion {
    
    _textFieldShouldReturnBlock = [completion copy];
    
}

#pragma mark - Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ( _textFieldShouldBeginEditingBlock != nil ) {
        return _textFieldShouldBeginEditingBlock();
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    for ( BoolCompletion completion in _textFieldDidBeginEditingBlocks ) {
        completion();
    }
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if ( _textFieldShouldEndEditingBlock != nil ) {
        return _textFieldShouldEndEditingBlock();
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    for ( BoolCompletion completion in _textFieldDidEndEditingBlocks ) {
        completion();
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ( _textFieldShouldChangeCharacterInRangeBlock != nil ) {
        return _textFieldShouldChangeCharacterInRangeBlock( range, string );
    }
    
    return YES;
    
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if (_textFieldShouldClearBlock != nil) {
        return _textFieldShouldClearBlock();
    }
    
    return NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ( _textFieldShouldReturnBlock != nil ) {
        return  _textFieldShouldReturnBlock();
    }
    
    return YES;
}

#pragma mark - Setter override

-(void)setDelegate:(id<UITextFieldDelegate>)delegate {
    if (delegate == self) {
        [super setDelegate:delegate];
    }
}

@end
