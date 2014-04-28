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

@implementation PYJAchievementSprite
-(id)init{
    
    self = [super initWithSpriteFrameName:@"Monkey_achievement_100.png"];
    if(self == nil){
        NSLog(@"------Failed");
    }
    return self;
}

-(id)initWithString:(NSString *)achievement
{
    NSString *filename = [NSString stringWithFormat:@"%@.png", achievement];
    if (self = [super initWithFile:filename])
    {
        NSLog((@"Success"));
    }
    return self;
}

@end