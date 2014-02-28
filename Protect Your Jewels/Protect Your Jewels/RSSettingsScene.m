//
//  RSSettingsScene.m
//  Operation: Protect Your Jewels
//
//  Created by Ryan Stack on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "RSSettingsScene.h"
#import "RSMainMenuLayer.h"
#import "cocos2d.h"

@implementation RSSettingsScene

-(id) init
{
	if( (self=[super init]) )
	{
        
		CGSize size = [[CCDirector sharedDirector] winSize];
		
        // Create menu logo and background
		CCSprite *background    = [CCSprite spriteWithFile:@"game_background.png"];
        
        // Center the background
		if (size.height > size.width) {
            background.position = ccp(size.height/2, size.width/2);
        } else {
            background.position = ccp(size.width/2, size.height/2);
        }
        
		[self addChild: background z:-1];
		
        // Create menu items
		[CCMenuItemFont setFontSize:17];
        [CCMenuItemFont setFontName:FONT_NAME];
		
		CCMenuItem *itemNewGame = [CCMenuItemFont itemWithString:@"Back" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[RSMainMenuLayer node]]];
		}];
        itemNewGame.color = ccBLACK;
        CCMenu *menu = [CCMenu menuWithItems:itemNewGame, nil];
        [menu alignItemsVerticallyWithPadding:10];
        [menu setPosition:ccp(30, size.height-30)];
		
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
