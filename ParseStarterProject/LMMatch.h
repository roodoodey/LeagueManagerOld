//
//  LMMatch.h
//  LeagueManager
//
//  Created by Mathieu Skulason on 18/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <Parse/Parse.h>

@interface LMMatch : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *roundId;
@property (nonatomic, strong) NSString *teamOneId;
@property (nonatomic, strong) NSString *teamTwoId;

@property (nonatomic, strong) NSNumber *teamOneGoals;
@property (nonatomic, strong) NSNumber *teamTwoGoals;
@property (nonatomic, strong) NSNumber *matchNumber;

+(NSString*)parseClassName;

@end
