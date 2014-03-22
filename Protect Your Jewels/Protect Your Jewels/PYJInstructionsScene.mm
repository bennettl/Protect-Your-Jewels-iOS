//
//  PYJInstructionsScene.mm
//  Protect Your Jewels
//
//  Created by Brian Quock on 3/10/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJInstructionsScene.h"
#import "PYJMainMenuLayer.h"
#import "PYJThemeManager.h"
#import "cocos2d.h"
#import "PYJBGLayer.h"

@implementation PYJInstructionsScene

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
        
        CCLabelTTF *scores = [CCLabelTTF labelWithString:@"Instructions: \n\n You have discovered the most potent jewel in the universe.\n Ninjas, monkeys, and gladiators want it. \n Do not let them touch your jewel! \n Swipe or throw them away to boost your score. \n You may use multi-touch for up to 2 touches. \n Good luck and Protect Your Jewels!" fontName:FONT_NAME fontSize:17];
        scores.color = ccBLACK;
        [scores setPosition:ccp(size.width / 2, size.height/2)];
        [self addChild:scores];
    }
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end