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
    CCScene *scene      = [CCScene node];
	RSGameOver *layer   = [RSGameOver node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init])){
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		CCSprite *background = [CCSprite spriteWithFile:@"game_background.png"];
        
        // Make sure background is center
		if(size.height > size.width) {
            background.position = ccp(size.height/2, size.width/2);
        } else {
            background.position = ccp(size.width/2, size.height/2);
        }
        
		[self addChild: background z:-1];
		
        // Create logo
        CCLabelTTF *gameoverlabel = [CCLabelTTF labelWithString:@"Game Over" fontName:@"angrybirds-regular" fontSize:80];

        gameoverlabel.position = ccp(size.width/2, size.height - gameoverlabel.contentSize.height);
        [self addChild:gameoverlabel z:1];
        
        
        // Create menu items
		[CCMenuItemFont setFontSize:23];
        [CCMenuItemFont setFontName:@"angrybirds-regular"];
		
		CCMenuItem *itemNewGame = [CCMenuItemFont itemWithString:@"Play Again" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[BLGameplayScene node]]];
		}];
        CCMenuItem *itemMainMenu = [CCMenuItemFont itemWithString:@"Back to Main Menu" block:^(id sender) {
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
