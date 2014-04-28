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


#define MONKEY_100 @"Monkey_achievement_100"
#define MONKEY_200 @"Monkey_achievement_200"
#define MONKEY_500 @"Monkey_achievement_500"
#define NINJA_100 @"Ninja_achievement_100"
#define NINJA_200 @"Ninja_achievement_200"
#define NINJA_500 @"Ninja_achievement_500"
#define GLADIATOR_100 @"Gladiator_achievement_100"
#define GLADIATOR_200 @"Gladiator_achievement_200"
#define GLADIATOR_500 @"Gladiator_achievement_500"

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
    
    // Jungle theme labels
    CCLabelTTF *monkey100 = [CCLabelTTF labelWithString:@"Scored 100 with Jungle Theme!" fontName:FONT_NAME fontSize:17];
    monkey100.color = ccBLACK;
    
    CCLabelTTF *monkey200 = [CCLabelTTF labelWithString:@"Scored 200 with Jungle Theme!" fontName:FONT_NAME fontSize:17];
    monkey200.color = ccBLACK;

    CCLabelTTF *monkey500 = [CCLabelTTF labelWithString:@"Scored 500 with Jungle Theme!" fontName:FONT_NAME fontSize:17];
    monkey500.color = ccBLACK;
    
    // Mountain theme labels
    CCLabelTTF *ninja100 = [CCLabelTTF labelWithString:@"Scored 100 with Mountain Theme!" fontName:FONT_NAME fontSize:17];
    ninja100.color = ccBLACK;
    
    CCLabelTTF *ninja200 = [CCLabelTTF labelWithString:@"Scored 200 with Mountain Theme!" fontName:FONT_NAME fontSize:17];
    ninja200.color = ccBLACK;
    
    CCLabelTTF *ninja500 = [CCLabelTTF labelWithString:@"Scored 500 with Mountain Theme!" fontName:FONT_NAME fontSize:17];
    ninja500.color = ccBLACK;
    
    // Gladiator theme labels
    CCLabelTTF *gladiator100 = [CCLabelTTF labelWithString:@"Scored 100 with Gladiator Theme!" fontName:FONT_NAME fontSize:17];
    gladiator100.color = ccBLACK;
    
    CCLabelTTF *gladiator200 = [CCLabelTTF labelWithString:@"Scored 200 with Gladiator Theme!" fontName:FONT_NAME fontSize:17];
    gladiator200.color = ccBLACK;
    
    CCLabelTTF *gladiator500 = [CCLabelTTF labelWithString:@"Scored 500 with Gladiator Theme!" fontName:FONT_NAME fontSize:17];
    gladiator500.color = ccBLACK;
    
    
    NSMutableArray *achievements = [[NSMutableArray alloc] initWithObjects:monkey100,monkey200,monkey500,gladiator100,gladiator200,gladiator500,ninja100,ninja200,ninja500,nil];
    
    for(int i = 0; i < achievements.count; i++){
        [[achievements objectAtIndex:i] setPosition:ccp((size.width/3),(size.height-40)-(i*30))];
    }
    //[monkey100 setPosition:ccp(size.width / 2, size.height/2)];
    
    [self addChild:monkey100];
    [self addChild:monkey200];
    [self addChild:monkey500];
    [self addChild:ninja100];
    [self addChild:ninja200];
    [self addChild:ninja500];
    [self addChild:gladiator100];
    [self addChild:gladiator200];
    [self addChild:gladiator500];
}

- (void) dealloc
{
	[super dealloc];
}

@end
