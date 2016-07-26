//
//  LMTeam.h
//  LeagueManager
//
//  Created by Mathieu Skulason on 18/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <Parse/Parse.h>

@interface LMTeam : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *championshipId;

@property (nonatomic, strong) NSNumber *goalsScored;
@property (nonatomic, strong) NSNumber *goalsTaken;
@property (nonatomic, strong) NSNumber *goalDifference;
@property (nonatomic, strong) NSNumber *points;

@property (nonatomic, strong) PFFile *teamDisplayPicture;

+(NSString*)parseClassName;

@end
