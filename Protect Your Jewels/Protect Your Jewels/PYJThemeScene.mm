//
//  PYJThemeScene.mm
//  Operation: Protect Your Jewels
//
//  Created by Ryan Stack on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJThemeScene.h"
#import "PYJMainMenuLayer.h"
#import "PYJThemeManager.h"
#import "cocos2d.h"
#import "PYJThemeManager.h"
#import "PYJBGLayer.h"


@interface PYJThemeScene()

@property (strong, nonatomic) CCMenuItem *itemJungle;
@property (strong, nonatomic) CCMenuItem *itemMountain;
@property (strong, nonatomic) CCMenuItem *itemGladiator;

@end

@implementation PYJThemeScene

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
        
        // Create theme menus
        self.itemJungle = [CCMenuItemFont itemWithString:@"Jungle" target:self selector:@selector(setThemeJungle:)];
        self.itemMountain = [CCMenuItemFont itemWithString:@"Mountain" target:self selector:@selector(setThemeMountain:)];
        self.itemGladiator = [CCMenuItemFont itemWithString:@"Gladiator" target:self selector:@selector(setThemeGladiator:)];
        
        // If a theme has already been set, show that menu item as selected
        //  Otherwise, use mountain as default selection
        if ([PYJThemeManager sharedManager].theme == MOUNTAIN) {
            self.itemMountain.color = ccBLACK;
        }
        else if ([PYJThemeManager sharedManager].theme == JUNGLE) {
            self.itemJungle.color = ccBLACK;
        }
        else {
            self.itemGladiator.color = ccBLACK;
        }
         
        
        CCMenu *themeMenu = [CCMenu menuWithItems:self.itemGladiator, self.itemJungle, self.itemMountain, nil];
        [themeMenu alignItemsVerticallyWithPadding:10];
        [themeMenu setPosition:ccp(size.width/2,size.height/2)];
		
		// Add menus to the layer
		[self addChild:backMenu];
        [self addChild:themeMenu];
    }
	return self;
}

// Modify PYJThemeManager and menu item colors based on the theme set
- (void)setThemeJungle: (id) sender {
    [PYJThemeManager sharedManager].theme = JUNGLE;
    self.itemJungle.color       = ccBLACK;
    self.itemGladiator.color    = ccWHITE;
    self.itemMountain.color     = ccWHITE;
}

- (void)setThemeMountain: (id) sender {
    [PYJThemeManager sharedManager].theme = MOUNTAIN;
    self.itemJungle.color       = ccWHITE;
    self.itemGladiator.color    = ccWHITE;
    self.itemMountain.color     = ccBLACK;
}

- (void)setThemeGladiator: (id) sender {
    [PYJThemeManager sharedManager].theme = GLADIATOR;
    self.itemJungle.color       = ccWHITE;
    self.itemGladiator.color    = ccBLACK;
    self.itemMountain.color     = ccWHITE;
}
- (void) dealloc
{
	[super dealloc];
}

@end
