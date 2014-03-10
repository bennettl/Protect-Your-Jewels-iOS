//
//  RSPauseLayer.m
//  Protect Your Jewels
//
//  Created by Ryan Stack on 3/9/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "RSPauseLayer.h"
#import "RSMainMenuLayer.h"
#import "RSThemeManager.h"
#import "MSBGLayer.h"
#import "cocos2d.h"

@implementation RSPauseLayer

-(id) init
{
	if( (self=[super init]) )
	{
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        MSBGLayer *background = [RSThemeManager sharedManager].background;
      
		[self addChild: background z:-1];
		
        // Create menu items
		[CCMenuItemFont setFontSize:17];
        [CCMenuItemFont setFontName:FONT_NAME];
		
		CCMenuItem *itemResume = [CCMenuItemFont itemWithString:@"Resume" block:^(id sender) {
            if([self.parent respondsToSelector:@selector(resumeGame)]) {
                [self.parent performSelector:@selector(resumeGame)];
            }
		}];
        CCMenuItem *itemExit = [CCMenuItemFont itemWithString:@"Exit to Main Menu" block:^(id sender) {
            if([self.parent respondsToSelector:@selector(startExit)]) {
                [self.parent performSelector:@selector(startExit)];
            }
		}];
        itemResume.color = ccWHITE;
        itemExit.color = ccWHITE;
        CCMenu *menu = [CCMenu menuWithItems:itemResume, itemExit, nil];
        [menu alignItemsVerticallyWithPadding:10];
        [menu setPosition:ccp(size.width/2, size.height/2)];
		
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
