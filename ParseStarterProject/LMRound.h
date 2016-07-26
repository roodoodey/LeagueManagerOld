//
//  LMRound.h
//  LeagueManager
//
//  Created by Mathieu Skulason on 18/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import <Parse/Parse.h>

@interface LMRound : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *championshipId;

@property (nonatomic, strong) NSNumber *roundNumber;

+(NSString*)parseClassName;

@end
