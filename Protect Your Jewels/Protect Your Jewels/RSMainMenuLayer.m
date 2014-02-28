//
//  RSMainMenuLayer.m
//  Operation: Protect Your Jewels
//
//  Created by Ryan Stack on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "RSMainMenuLayer.h"
#import "BLGameplayScene.h"
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
    if( (self = [super init])) {

		CGSize size = [[CCDirector sharedDirector] winSize];
		
        // Create menu logo and background
        CCSprite *logo          = [CCSprite spriteWithFile:@"menu_logo.png"];
		CCSprite *background    = [CCSprite spriteWithFile:@"game_background.png"];
        
        // Center the background
		if (size.height > size.width) {
            logo.position = ccp(size.height - logo.contentSize.height + 15, size.width/2);
            background.position = ccp(size.height/2, size.width/2);
        } else {
            logo.position = ccp(size.width/2, size.height - logo.contentSize.height + 15);
            background.position = ccp(size.width/2, size.height/2);
        }
        
        [self addChild:logo z:1];
		[self addChild: background z:-1];
		
        // Create menu items
		[CCMenuItemFont setFontSize:23];
        [CCMenuItemFont setFontName:FONT_NAME];
		
		CCMenuItem *itemNewGame = [CCMenuItemFont itemWithString:@"New Game" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[BLGameplayScene node]]];
		}];
        CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[RSLeaderboardScene node]]];
		}];
//        CCMenuItem *itemSettings = [CCMenuItemFont itemWithString:@"Settings" block:^(id sender) {
//            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[RSSettingsScene node]]];
//		}];
		
		CCMenu *menu = [CCMenu menuWithItems:itemNewGame, itemLeaderboard, nil];
		
		[menu alignItemsVerticallyWithPadding:10];
        [menu setPosition:ccp(size.width/2, 95)];
        
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
