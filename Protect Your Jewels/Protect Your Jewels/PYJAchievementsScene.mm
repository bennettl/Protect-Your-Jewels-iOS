//
//  PYJAchievementsScene.mm
//  Protect Your Jewels
//
//  Created by Brian Quock on 3/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJAchievementsScene.h"
#import "PYJMainMenuLayer.h"
#import "PYJThemeManager.h"
#import "cocos2d.h"
#import "PYJBGLayer.h"

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
        [self addChild:achievements];
    }
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end
