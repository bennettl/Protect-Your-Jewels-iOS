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
        
        // Menu items
		[CCMenuItemFont setFontSize:23];
        [CCMenuItemFont setFontName:FONT_NAME];
		
        CCMenuItem *itemMainMenu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender){
                                        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[PYJMainMenuLayer node]]];}];
        
        CCMenuItem *itemNext = [CCMenuItemFont itemWithString:@"Next" target:nil selector:@selector(nextScreen)];
        
        CCMenuItem *itemPrevious = [CCMenuItemFont itemWithString:@"Previous" target:nil selector:@selector(previousScreen)];
        
        
        CCMenu *mainMenu = [CCMenu menuWithItems:itemMainMenu, nil];
        CCMenu *previousMenu = [CCMenu menuWithItems:itemPrevious, nil];
        CCMenu *nextMenu = [CCMenu menuWithItems:itemNext, nil];
        mainMenu.color = ccBLACK;
        previousMenu.color = ccBLACK;
        nextMenu.color = ccBLACK;
        
        [mainMenu alignItemsVerticallyWithPadding:10];
        [previousMenu alignItemsVerticallyWithPadding:10];
        [nextMenu alignItemsVerticallyWithPadding:10];
        [mainMenu setPosition:ccp(60, size.height-30)];
        [previousMenu setPosition:ccp(50, 30)];
        [nextMenu setPosition:ccp(size.width-30, 30)];
        
        // Add main menu to the layer
        [self addChild:mainMenu];
        [self addChild:previousMenu];
        [self addChild:nextMenu];
        
    }
    return self;
}

-(void) nextScreen{
    // check enum
    // change enum
    // change screen settings
}

-(void) previousScreen{
    // check enum
    // change enum
    // change screen settings
}

- (void) dealloc
{
    [super dealloc];
}

@end