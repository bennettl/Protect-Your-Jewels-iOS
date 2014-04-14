//
//  PYJPauseLayer.mm
//  Protect Your Jewels
//
//  Created by Ryan Stack on 3/9/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJPauseLayer.h"
#import "PYJMainMenuLayer.h"
#import "PYJThemeManager.h"
#import "PYJBGLayer.h"
#import "cocos2d.h"
#import "PYJGameplayScene.h"

@implementation PYJPauseLayer

-(id) init
{
	if( (self=[super init]) )
	{
        
		CGSize size = [[CCDirector sharedDirector] winSize];
        PYJBGLayer *background = [PYJThemeManager sharedManager].background;
      
		[self addChild: background z:-1];
		
        // Create menu items
		[CCMenuItemFont setFontSize:17];
        [CCMenuItemFont setFontName:FONT_NAME];
		
		CCMenuItem *itemResume = [CCMenuItemFont itemWithString:@"Resume" block:^(id sender) {
            if([self.parent respondsToSelector:@selector(resumeGame)]) {
                [self.parent performSelector:@selector(resumeGame)];
            }
		}];
        CCMenuItem *itemRestart = [CCMenuItemFont itemWithString:@"Restart Game" block:^(id sender) {
            if([self.parent respondsToSelector:@selector(restartGame)]) {
                [self.parent performSelector:@selector(restartGame)];
            }
		}];
        CCMenuItem *itemExit = [CCMenuItemFont itemWithString:@"Exit to Main Menu" block:^(id sender) {
            if([self.parent respondsToSelector:@selector(startExit)]) {
                [self.parent performSelector:@selector(startExit)];
            }
		}];
        
        itemResume.color = ccWHITE;
        itemExit.color = ccWHITE;
        CCMenu *menu = [CCMenu menuWithItems:itemResume, itemRestart, itemExit, nil];
        [menu alignItemsVerticallyWithPadding:10];
        [menu setPosition:ccp(size.width/2, size.height/2)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
    }
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end
