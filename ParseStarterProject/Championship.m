//
//  Championship.m
//  LeagueManager
//
//  Created by Mathieu Skulason on 18/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "Championship.h"
#import <Parse/PFObject+Subclass.h>

@implementation Championship

@dynamic name;
@dynamic startDate;
@dynamic endDate;

+(void)load {
    [self registerSubclass];
}

+(NSString*)parseClassName {
    return @"Championship";
}

@end
