//
//  PYJMainMenuLayer.mm
//  Operation: Protect Your Jewels
//
//  Created by Ryan Stack on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJMainMenuLayer.h"
#import "PYJGameplayScene.h"
#import "PYJLeaderboardScene.h"
#import "PYJThemeScene.h"
#import "PYJInstructionsScene.h"
#import "SimpleAudioEngine.h"
#import "PYJBGLayer.h"
#import "PYJThemeManager.h"
#import "cocos2d.h"

@implementation PYJMainMenuLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	PYJMainMenuLayer *layer = [PYJMainMenuLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
    if( (self = [super init])) {

		CGSize size = [[CCDirector sharedDirector] winSize];
		
        // Create menu logo and background
        CCSprite *logo          = [CCSprite spriteWithFile:@"menu_logo.png"];
		PYJBGLayer *background = [[PYJThemeManager sharedManager] background];
                
        // Center the background
		if (size.height > size.width) {
            logo.position = ccp(size.height - logo.contentSize.height + 15, size.width/2);
        } else {
            logo.position = ccp(size.width/2, size.height - logo.contentSize.height + 15);
        }
        
        [self addChild:logo z:1];
		[self addChild: background z:-1];
		
        // Menu items
		[CCMenuItemFont setFontSize:23];
        [CCMenuItemFont setFontName:FONT_NAME];
		
		CCMenuItem *itemNewGame = [CCMenuItemFont itemWithString:@"New Game" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[PYJGameplayScene node]]];
		}];
        CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[PYJLeaderboardScene node]]];
		}];
        CCMenuItem *itemThemes = [CCMenuItemFont itemWithString:@"Themes" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[PYJThemeScene node]]];
		}];
        CCMenuItem *itemInstructions = [CCMenuItemFont itemWithString:@"Instructions" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[PYJInstructionsScene node]]];
		}];
		
		CCMenu *mainMenu = [CCMenu menuWithItems:itemNewGame, itemLeaderboard, itemThemes, itemInstructions, nil];
		
		[mainMenu alignItemsVerticallyWithPadding:10];
        [mainMenu setPosition:ccp(size.width/2, 95)];
        
        // Stop music
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
		// Add main menu to the layer
		[self addChild:mainMenu];
        
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end
