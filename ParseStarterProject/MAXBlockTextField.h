//
//  MAXBlockTextField.h
//  ReusableComponentsApp
//
//  Created by Mathieu Grettir Skulason on 5/10/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAXBlockTextField : UITextField

/**
 @abstract When the textFieldShouldBeginEditing: method is called on the uitextfield we return the completion blocks value, if none is provided it will defaults YES. Called to ask if the text field should become the first responder when interacted.
 */
-(void)textFieldShouldBeginEditingWithCompletion:(BOOL (^)(void))completion;

/**
 @abstract When the textFieldDidBeginEditing: method is called on the uitextfield we call the completion blocks if any exis so you can be aware if the text field has begun being interacted with.
 */
-(void)textFieldDidBeginEditingWithCompletion:(void (^)(void))completion;

/**
 @abstract When the textFieldShouldEndEditing: methos is called on the uitextfield we return the completion blocks value, if none is provided it will default to YES. This is called to ask if the text field should resign first responder or not.
 */
-(void)textFieldShouldEndEditingWithCompletion:(BOOL (^)(void))completion;

/**
 @abstract When the textFieldDidEndEditing: methos is called on the uitextifled we call the completion blocks if any exist so you can be aware if the text field has stopped being interacted with.
 */
-(void)textFieldDidEndEditingWithCompletion:(void (^)(void))completion;



/**
 @abstract When the textField:shouldChangeCharactersInRange:replacementString is called, we call the block in order to know if the user wants the string to be replaced. If no block is provided it will default to yes. This method is called whenever a new character is added to the string.
 */
-(void)textFieldShouldChangeCharactersInRangeWithCompletion:(BOOL (^)(NSRange, NSString *))completion;

/**
 @abstract When the textFieldShouldClear: is called, we call the block in order to know if the user wants the string to be replaced. This is called every single time the user inputs a new character in the text field. Defaults to NO if no block is passed.
 */
-(void)textFieldShouldClearWithCompletion:(BOOL (^)(void))completion;

/**
 @abstract When the textFieldShouldReturn: methos is called we call the block to know if the keyboard should return. If no block is provided it will default to YES.
 */
-(void)textFieldShouldReturnWithCompletion:(BOOL (^)(void))completion;

@end
