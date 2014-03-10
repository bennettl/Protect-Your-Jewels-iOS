//
//  MSThemeScene.m
//  Operation: Protect Your Jewels
//
//  Created by Ryan Stack on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "RSThemeScene.h"
#import "RSMainMenuLayer.h"
#import "RSThemeManager.h"
#import "cocos2d.h"
#import "RSThemeManager.h"
#import "MSBGLayer.h"


@interface RSThemeScene()

@property (strong, nonatomic) CCMenuItem *itemJungle;
@property (strong, nonatomic) CCMenuItem *itemMountain;
@property (strong, nonatomic) CCMenuItem *itemGladiator;

@end

@implementation RSThemeScene

-(id) init
{
	if( (self=[super init]) )
	{
        
		CGSize size = [[CCDirector sharedDirector] winSize];
		
        // Create menu logo and background
		MSBGLayer *background = [RSThemeManager sharedManager].background;
        
		[self addChild: background z:-1];
		
        // Create back menu
		[CCMenuItemFont setFontSize:17];
        [CCMenuItemFont setFontName:FONT_NAME];
		
		CCMenuItem *itemBack = [CCMenuItemFont itemWithString:@"Back" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[RSMainMenuLayer node]]];
		}];
        itemBack.color = ccBLACK;
        CCMenu *backMenu = [CCMenu menuWithItems:itemBack, nil];
        [backMenu alignItemsVerticallyWithPadding:10];
        [backMenu setPosition:ccp(30, size.height-30)];
        
        // Create theme menus
        self.itemJungle = [CCMenuItemFont itemWithString:@"Jungle" target:self selector:@selector(setThemeJungle:)];
        self.itemMountain = [CCMenuItemFont itemWithString:@"Mountain" target:self selector:@selector(setThemeMountain:)];
        self.itemGladiator = [CCMenuItemFont itemWithString:@"Gladiator" target:self selector:@selector(setThemeGladiator:)];
        
        self.itemMountain.color = ccBLACK;
        
        CCMenu *themeMenu = [CCMenu menuWithItems:self.itemGladiator, self.itemJungle, self.itemMountain, nil];
        [themeMenu alignItemsVerticallyWithPadding:10];
        [themeMenu setPosition:ccp(size.width/2,size.height/2)];
		
		// Add menus to the layer
		[self addChild:backMenu];
        [self addChild:themeMenu];
    }
	return self;
}

// Modify RSThemeManager and menu item colors base on the theme set
- (void)setThemeJungle: (id) sender {
    [RSThemeManager sharedManager].theme = JUNGLE;
    self.itemJungle.color       = ccBLACK;
    self.itemGladiator.color    = ccWHITE;
    self.itemMountain.color     = ccWHITE;
}

- (void)setThemeMountain: (id) sender {
    [RSThemeManager sharedManager].theme = MOUNTAIN;
    self.itemJungle.color       = ccWHITE;
    self.itemGladiator.color    = ccWHITE;
    self.itemMountain.color     = ccBLACK;
}

- (void)setThemeGladiator: (id) sender {
    [RSThemeManager sharedManager].theme = GLADIATOR;
    self.itemJungle.color       = ccWHITE;
    self.itemGladiator.color    = ccBLACK;
    self.itemMountain.color     = ccWHITE;
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
