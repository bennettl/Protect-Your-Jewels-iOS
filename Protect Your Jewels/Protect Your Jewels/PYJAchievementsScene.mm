//
//  PYJAchievementsScene.mm
//  Protect Your Jewels
//
//  Created by Brian Quock on 3/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJAchievementsScene.h"
#import "PYJAchievementSprite.h"
#import "PYJMainMenuLayer.h"
#import "PYJThemeManager.h"
#import "cocos2d.h"
#import "PYJBGLayer.h"
#import "PYJHighScoreManager.h"


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

@implementation PYJAchievementsScene

-(id) init
{
	if( (self=[super init]) )
	{
        CGSize size = [[CCDirector sharedDirector] winSize];
		
        // Create menu logo and background
		PYJBGLayer *background = [PYJThemeManager sharedManager].background;
        
		[self addChild: background z:-1];
		
        // Create back menu
		[CCMenuItemFont setFontSize:17];
        [CCMenuItemFont setFontName:FONT_NAME];
		
		CCMenuItem *itemBack = [CCMenuItemFont itemWithString:@"Back" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[PYJMainMenuLayer node]]];
		}];
        itemBack.color = ccBLACK;
        CCMenu *backMenu = [CCMenu menuWithItems:itemBack, nil];
        [backMenu alignItemsVerticallyWithPadding:10];
        [backMenu setPosition:ccp(30, size.height-30)];
        
		// Add menus to the layer
		[self addChild:backMenu];
        
        CCLabelTTF *achievements = [CCLabelTTF labelWithString:@"Achievements information coming soon!" fontName:FONT_NAME fontSize:17];
        achievements.color = ccBLACK;
        [achievements setPosition:ccp(size.width / 2, size.height/2)];
        
        //[self addChild:achievements];
        [self presentInfo];
    }
	return self;
}

-(void)presentInfo{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    
    PYJAchievementSprite *spriteM1 = [[PYJHighScoreManager sharedManager] accessAchievement:MONKEY_100] ? [[PYJAchievementSprite alloc] initWithString:MONKEY_100] : [[PYJAchievementSprite alloc] initWithString:MONKEY_100_D];
    
    PYJAchievementSprite *spriteM2 = [[PYJHighScoreManager sharedManager] accessAchievement:MONKEY_200] ? [[PYJAchievementSprite alloc] initWithString:MONKEY_200] : [[PYJAchievementSprite alloc] initWithString:MONKEY_200_D];
    
    PYJAchievementSprite *spriteM5 = [[PYJHighScoreManager sharedManager] accessAchievement:MONKEY_500] ? [[PYJAchievementSprite alloc] initWithString:MONKEY_500] : [[PYJAchievementSprite alloc] initWithString:MONKEY_500_D];
    
    PYJAchievementSprite *spriteN1 = [[PYJHighScoreManager sharedManager] accessAchievement:NINJA_100] ? [[PYJAchievementSprite alloc] initWithString:NINJA_100] : [[PYJAchievementSprite alloc] initWithString:NINJA_100_D];
    
    PYJAchievementSprite *spriteN2 = [[PYJHighScoreManager sharedManager] accessAchievement:NINJA_200] ? [[PYJAchievementSprite alloc] initWithString:NINJA_200] : [[PYJAchievementSprite alloc] initWithString:NINJA_200_D];
    
    PYJAchievementSprite *spriteN5 = [[PYJHighScoreManager sharedManager] accessAchievement:NINJA_500] ? [[PYJAchievementSprite alloc] initWithString:NINJA_500] : [[PYJAchievementSprite alloc] initWithString:NINJA_500_D];
    
    PYJAchievementSprite *spriteG1 = [[PYJHighScoreManager sharedManager] accessAchievement:GLADIATOR_100] ? [[PYJAchievementSprite alloc] initWithString:GLADIATOR_100] : [[PYJAchievementSprite alloc] initWithString:GLADIATOR_100_D];
    
    PYJAchievementSprite *spriteG2 = [[PYJHighScoreManager sharedManager] accessAchievement:GLADIATOR_200] ? [[PYJAchievementSprite alloc] initWithString:GLADIATOR_200] : [[PYJAchievementSprite alloc] initWithString:GLADIATOR_200_D];
    
    PYJAchievementSprite *spriteG5 = [[PYJHighScoreManager sharedManager] accessAchievement:GLADIATOR_500] ? [[PYJAchievementSprite alloc] initWithString:GLADIATOR_500] : [[PYJAchievementSprite alloc] initWithString:GLADIATOR_500_D];
    
    
    NSMutableArray *achievements = [[NSMutableArray alloc] initWithObjects:spriteM1,spriteM2,spriteM5,spriteN1,spriteN2,spriteN5,spriteG1,spriteG2,spriteG5,nil];
    
    for(int i = 0; i < achievements.count; i++){
        [[achievements objectAtIndex:i] setPosition:ccp(size.width/3 + i*60 - 140,size.height/2)];
        [self addChild:[achievements objectAtIndex:i]];
    }
}

- (void) dealloc
{
	[super dealloc];
}

@end
