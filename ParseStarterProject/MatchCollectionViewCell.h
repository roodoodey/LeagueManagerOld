//
//  MatchCollectionViewCell.h
//  LeagueManager
//
//  Created by Mathieu Skulason on 10/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MatchCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UITextField *scoreTextField;
@property (nonatomic, strong) UIImageView *teamDisplayImageView;
@property (nonatomic, strong) UILabel *teamNameLabel;
@property (nonatomic, weak) PFObject *matchObject;
@property (nonatomic, readwrite) BOOL isTeamOne;

-(void)saveScoreCompletion:(void (^)(BOOL succeeded, NSError *error))block;
-(void)invertInterfaceComponents:(BOOL)inverted withAnimation:(BOOL)anim;

@end
