//
//  LMTeam.m
//  LeagueManager
//
//  Created by Mathieu Skulason on 18/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "LMTeam.h"
#import <Parse/PFObject+Subclass.h>


@implementation LMTeam

@dynamic teamName;
@dynamic categoryId;
@dynamic championshipId;

@dynamic goalsScored;
@dynamic goalsTaken;
@dynamic goalDifference;
@dynamic points;

@dynamic teamDisplayPicture;

+(void)load {
    [self registerSubclass];
}

+(NSString*)parseClassName {
    return @"Team";
}

@end
