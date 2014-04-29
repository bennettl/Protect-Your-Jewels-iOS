//
//  PYJAchievementSprite.m
//  Protect Your Jewels
//
//  Created by Brian Quock on 4/28/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJAchievementSprite.h"

#define MONKEY_100 @"Monkey_achievement_100"
#define MONKEY_200 @"Monkey_achievement_200"
#define MONKEY_500 @"Monkey_achievement_500"
#define NINJA_100 @"Ninja_achievement_100"
#define NINJA_200 @"Ninja_achievement_200"
#define NINJA_500 @"Ninja_achievement_500"
#define GLADIATOR_100 @"Gladiator_achievement_100"
#define GLADIATOR_200 @"Gladiator_achievement_200"
#define GLADIATOR_500 @"Gladiator_achievement_500"

#define MONKEY_100_D @"Monkey_achievement_100_deactivated"
#define MONKEY_200_D @"Monkey_achievement_200_deactivated"
#define MONKEY_500_D @"Monkey_achievement_500_deactivated"
#define NINJA_100_D @"Ninja_achievement_100_deactivated"
#define NINJA_200_D @"Ninja_achievement_200_deactivated"
#define NINJA_500_D @"Ninja_achievement_500_deactivated"
#define GLADIATOR_100_D @"Gladiator_achievement_100_deactivated"
#define GLADIATOR_200_D @"Gladiator_achievement_200_deactivated"
#define GLADIATOR_500_D @"Gladiator_achievement_500_deactivated"

@implementation PYJAchievementSprite
-(id)init{
    if(self = [super init]){
        
    }
    return self;
}

-(id)initWithString:(NSString *)achievement
{
    NSString *filename = [NSString stringWithFormat:@"%@.png", achievement];
    

    if (self = [super initWithFile:filename]){
    }
    
    return self;
}

@end