//
//  LMCategory.m
//  LeagueManager
//
//  Created by Mathieu Skulason on 18/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "LMCategory.h"
#import <Parse/PFObject+Subclass.h>


@implementation LMCategory

@dynamic name;
@dynamic championshipId;
@dynamic pointsForTie;
@dynamic pointsForWin;

+(void)load {
    [self registerSubclass];
}

+(NSString*)parseClassName {
    return @"Category";
}

@end
