//
//  LMRound.m
//  LeagueManager
//
//  Created by Mathieu Skulason on 18/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "LMRound.h"
#import <Parse/PFObject+Subclass.h>


@implementation LMRound

@dynamic categoryId;
@dynamic championshipId;

@dynamic roundNumber;

+(void)load {
    [self registerSubclass];
}

+(NSString*)parseClassName {
    return @"Round";
}

@end
