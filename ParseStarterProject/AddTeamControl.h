//
//  AddTeamControl.h
//  LeagueManager
//
//  Created by Mathieu Skulason on 11/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol AddTeamDelegate;

@interface AddTeamControl : UIControl

@property (nonatomic, strong) PFObject *selectedChampionship;
@property (nonatomic, strong) PFObject *selectedCategory;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *teamNameLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, weak) id <AddTeamDelegate> delegate;

-(id)init;
-(void)saveTeamWithCompletion:(void (^)(BOOL succeeded, PFObject *team, NSError *error))block;

@end

@protocol AddTeamDelegate

-(void)showImagePicker:(UIImagePickerController*)imagePicker;
-(void)dismissImagePicker:(UIImagePickerController*)imagePicker;

@end
