//
//  AddTeamControl.m
//  LeagueManager
//
//  Created by Mathieu Skulason on 11/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "AddTeamControl.h"
#import "UIColor+Chameleon.h"
#import "UIFont+ArialAndHelveticaNeue.h"
#import "MBProgressHUD.h"
#import "LMTeam.h"

@interface AddTeamControl () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImagePickerController *imagePicker;
}

@end

@implementation AddTeamControl

-(id)init {
    
    if (self = [super init]) {
        
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.allowsEditing = YES;
        
        self.layer.borderColor = [UIColor flatTealColor].CGColor;
        self.layer.borderWidth = 2.0f;
        self.layer.cornerRadius = 20.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor flatWhiteColor];
        
        self.frame = CGRectMake(0, 0, 300, 370);
        
        UITapGestureRecognizer *dismissKeyboardTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
        [self addGestureRecognizer:dismissKeyboardTapGesture];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
        topView.backgroundColor = [UIColor flatTealColor];
        [self addSubview:topView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.frame), 40)];
        _titleLabel.font = [UIFont maxwellBoldWithSize:21];
        _titleLabel.textColor = [UIColor flatWhiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"Add Team";
        [topView addSubview:_titleLabel];
        
        /*
        UIView *topSeparatorColor = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(self.frame), 2)];
        topSeparatorColor.backgroundColor = [UIColor flatTealColor];
        [self addSubview:topSeparatorColor];
        */
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - 70, CGRectGetMaxY(topView.frame) + 12, 140, 140)];
        _imageView.layer.borderWidth = 3.0;
        _imageView.layer.borderColor = [UIColor flatPurpleColorDark].CGColor;
        _imageView.layer.backgroundColor = [UIColor flatWhiteColor].CGColor;
        _imageView.layer.cornerRadius = _imageView.frame.size.width / 2.0;
        _imageView.layer.masksToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *imageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)];
        [_imageView addGestureRecognizer:imageTapGestureRecognizer];
        
        _teamNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_imageView.frame) + 10, CGRectGetWidth(self.frame) - 20, 36)];
        _teamNameLabel.font = [UIFont openSansBoldWithSize:17.0];
        _teamNameLabel.text = @"Team Name";
        _teamNameLabel.textColor = [UIColor flatSkyBlueColorDark];
        _teamNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_teamNameLabel];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_teamNameLabel.frame) + 8, CGRectGetWidth(self.frame) - 20, 40)];
        _textField.placeholder = @"Enter team name";
        _textField.font = [UIFont openSansBoldWithSize:15.0];
        _textField.textColor = [UIColor flatBlackColor];
        _textField.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textField];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 50, CGRectGetWidth(self.frame), 50)];
        bottomView.backgroundColor = [UIColor flatTealColor];
        [self addSubview:bottomView];
    
        _dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bottomView.frame) / 2.0, CGRectGetHeight(bottomView.frame))];
        _dismissButton.titleLabel.font = [UIFont maxwellBoldWithSize:21];
        [_dismissButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_dismissButton setTitleColor:[UIColor flatRedColor] forState:UIControlStateNormal];
        [_dismissButton setTitleColor:[UIColor flatRedColorDark] forState:UIControlStateHighlighted];
        [bottomView addSubview:_dismissButton];
        
        _acceptButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(bottomView.frame), 0, CGRectGetWidth(bottomView.frame) / 2.0, CGRectGetHeight(bottomView.frame))];
        _acceptButton.titleLabel.font = [UIFont maxwellBoldWithSize:21];
        [_acceptButton setTitle:@"Create" forState:UIControlStateNormal];
        [_acceptButton setTitleColor:[UIColor flatGreenColor] forState:UIControlStateNormal];
        [_acceptButton setTitleColor:[UIColor flatGreenColorDark] forState:UIControlStateHighlighted];
        [bottomView addSubview:_acceptButton];
        
    }
    
    return self;
}

-(void)viewTapped {
    [self endEditing:YES];
}

-(void)chooseImage {
    if (_delegate) {
        [_delegate showImagePicker:imagePicker];
    }
}

-(void)saveTeamWithCompletion:(void (^)(BOOL, PFObject*, NSError *))block {
    
    LMTeam *newTeam = [LMTeam object];
    newTeam.teamName = _textField.text;
    newTeam.goalsScored = [NSNumber numberWithInt:0];
    newTeam.goalsTaken = [NSNumber numberWithInt:0];
    
    if (_selectedCategory) {
        newTeam.categoryId = _selectedCategory.objectId;
    }
    
    if (_selectedChampionship) {
        newTeam.championshipId = _selectedChampionship.objectId;
    }
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    progressHud.mode = MBProgressHUDModeIndeterminate;
    
    if (_imageView.image != nil) {
        
        
        PFFile *image = [PFFile fileWithName:@"teamImage" data:UIImageJPEGRepresentation(_imageView.image, 0.6)];
        
        [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    newTeam.teamDisplayPicture = image;
                    [newTeam saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [progressHud hide:YES];
                            
                            if (succeeded) {
                                block(YES, newTeam, nil);
                            }
                            else {
                                block(NO, nil, nil);
                            }
                        });
                        
                    }];
                    
                });
            }
            else {
                block(NO, nil, nil);
            }
            
        }];
        
        return ;
    }
    
    [newTeam saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [progressHud hide:YES];
            
            if (succeeded) {
                block(YES, newTeam, nil);
            }
            else {
                block(NO, nil, nil);
            }
        });
        
    }];
}

#pragma mark - Image picker delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    _imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (_delegate) {
        [_delegate dismissImagePicker:imagePicker];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (_delegate) {
        [_delegate dismissImagePicker:imagePicker];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
