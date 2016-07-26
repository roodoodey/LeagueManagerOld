//
//  LMCategory.h
//  LeagueManager
//
//  Created by Mathieu Skulason on 18/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <Parse/Parse.h>

@interface LMCategory : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *championshipId;
@property (nonatomic, strong) NSNumber *pointsForTie;
@property (nonatomic, strong) NSNumber *pointsForWin;

+(NSString*)parseClassName;

@end
