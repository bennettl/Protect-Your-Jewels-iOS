//
//  RSGameOver.m
//  Operation: Protect Your Jewels
//
//  Created by Ryan Stack on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "RSGameOver.h"
#import "BLGameplayScene.h"
#import "RSMainMenuLayer.h"

@implementation RSGameOver

+ (CCScene *)scene {
    CCScene *scene = [CCScene node];
	RSGameOver *layer = [RSGameOver node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init]) )
	{
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		[CCMenuItemFont setFontSize:28];
        [CCMenuItemFont setFontName:@"Helvetica"];
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemNewGame = [CCMenuItemFont itemWithString:@"Try Again" block:^(id sender) {
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[BLGameplayScene node]]];
			
		}];
        CCMenuItem *itemMainMenu = [CCMenuItemFont itemWithString:@"Quit" block:^(id sender) {
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[RSMainMenuLayer node]]];
			
		}];
		
		CCMenu *menu = [CCMenu menuWithItems:itemNewGame, itemMainMenu, nil];
		
		[menu alignItemsVerticallyWithPadding:10];
        [menu setPosition:ccp(size.width/2, 100)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
	}
	return self;
}


@end
