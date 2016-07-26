//
//  LMMatch.m
//  LeagueManager
//
//  Created by Mathieu Skulason on 18/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "LMMatch.h"
#import <Parse/PFObject+Subclass.h>


@implementation LMMatch

@dynamic categoryId;
@dynamic roundId;
@dynamic teamOneId;
@dynamic teamTwoId;

@dynamic teamOneGoals;
@dynamic teamTwoGoals;
@dynamic matchNumber;

+(void)load {
    [self registerSubclass];
}

+(NSString*)parseClassName {
    return @"Match";
}

@end
