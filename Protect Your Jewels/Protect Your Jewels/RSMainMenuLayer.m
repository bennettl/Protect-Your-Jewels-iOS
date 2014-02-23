//
//  RSMainMenuLayer.m
//  Operation: Protect Your Jewels
//
//  Created by Ryan Stack on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "RSMainMenuLayer.h"
#import "RSTempGamePlayScene.h"
#import "RSLeaderboardScene.h"
#import "RSSettingsScene.h"
#import "cocos2d.h"

@implementation RSMainMenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	RSMainMenuLayer *layer = [RSMainMenuLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init]) )
	{
		CGSize size = [[CCDirector sharedDirector] winSize];
		
//		CCSprite *background;
//		background = [CCSprite spriteWithFile:@"Default.png"];
//		background.rotation = 90;
//		if(size.height > size.width) {
//            background.position = ccp(size.height/2, size.width/2);
//        } else {
//            background.position = ccp(size.width/2, size.height/2);
//        }
//		[self addChild: background];
		
		[CCMenuItemFont setFontSize:28];
        [CCMenuItemFont setFontName:@"Helvetica"];
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemNewGame = [CCMenuItemFont itemWithString:@"New Game" block:^(id sender) {
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[RSTempGamePlayScene node]]];
			
		}];
        CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[RSLeaderboardScene node]]];
			
		}];
        CCMenuItem *itemSettings = [CCMenuItemFont itemWithString:@"Settings" block:^(id sender) {
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[RSSettingsScene node]]];
			
		}];
		
		CCMenu *menu = [CCMenu menuWithItems:itemNewGame, itemLeaderboard, itemSettings, nil];
		
		[menu alignItemsVerticallyWithPadding:10];
        [menu setPosition:ccp(size.width/2, 100)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
	}
	return self;
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end