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
#import "PYJHighScoreManager.h"
#import "PYJBGLayer.h"

#define JUNGLE_UNLOCKED_KEY @"jungleUnlockedKey"
#define GLADIATOR_UNLOCKED_KEY @"jungleUnlockedKey"

@interface PYJThemeScene()

@property (strong, nonatomic) CCMenuItem *itemJungle;
@property (strong, nonatomic) CCMenuItem *itemMountain;
@property (strong, nonatomic) CCMenuItem *itemGladiator;
@property (strong, nonatomic) UIAlertView *jungleUnlockAlertView;
@property (strong, nonatomic) UIAlertView *gladiatorUnlockAlertView;

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
        NSString *jungleString = ([[NSUserDefaults standardUserDefaults] boolForKey:JUNGLE_UNLOCKED_KEY] == YES) ? @"Jungle" : @"Jungle (locked)";
        NSString *gladiatorString = ([[NSUserDefaults standardUserDefaults] boolForKey:GLADIATOR_UNLOCKED_KEY] == YES) ? @"Gladiator" : @"Gladiator (locked)";
        
        self.itemMountain = [CCMenuItemFont itemWithString:@"Mountain" target:self selector:@selector(setThemeMountain:)];
        self.itemJungle = [CCMenuItemFont itemWithString:jungleString target:self selector:@selector(setThemeJungle:)];
        self.itemGladiator = [CCMenuItemFont itemWithString:gladiatorString target:self selector:@selector(setThemeGladiator:)];
        
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
         
        
        CCMenu *themeMenu = [CCMenu menuWithItems:self.itemMountain, self.itemGladiator, self.itemJungle,  nil];
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
    if([PYJThemeManager sharedManager].isJungleThemeUnlocked) {
        [PYJThemeManager sharedManager].theme = JUNGLE;
        self.itemJungle.color       = ccBLACK;
        self.itemGladiator.color    = ccWHITE;
        self.itemMountain.color     = ccWHITE;
        
        [self.itemJungle setString:@"Jungle"];
    } else {
        NSString *alertViewMessage = [NSString stringWithFormat:@"You have %li gems left. This theme costs 10 gems", [[PYJHighScoreManager sharedManager] userCurrency]];
        if([[PYJHighScoreManager sharedManager] userCurrency] >= 10) {
            self.jungleUnlockAlertView = [[UIAlertView alloc] initWithTitle:@"Do you want to unlock the Jungle Theme?" message:alertViewMessage delegate:self cancelButtonTitle:@"No thank you" otherButtonTitles:@"Buy it!", nil];
            [self.jungleUnlockAlertView show];
        } else {
            self.jungleUnlockAlertView = [[UIAlertView alloc] initWithTitle:@"Insufficient Funds" message:alertViewMessage delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [self.jungleUnlockAlertView show];
        }
    }
}

- (void)setThemeMountain: (id) sender {
    [PYJThemeManager sharedManager].theme = MOUNTAIN;
    self.itemJungle.color       = ccWHITE;
    self.itemGladiator.color    = ccWHITE;
    self.itemMountain.color     = ccBLACK;
}

#pragma message "make a theme data that has whether it is unlocked and how much it costs, also data persistence"
- (void)setThemeGladiator: (id) sender {
    if([PYJThemeManager sharedManager].isGladiatorThemeUnlocked) {
        [PYJThemeManager sharedManager].theme = GLADIATOR;
        self.itemJungle.color       = ccWHITE;
        self.itemGladiator.color    = ccBLACK;
        self.itemMountain.color     = ccWHITE;
        
        [self.itemGladiator setString:@"Gladiator"];
    } else {
        NSString *alertViewMessage = [NSString stringWithFormat:@"You have %li gems left. This theme costs 10 gems", [[PYJHighScoreManager sharedManager] userCurrency]];
        if([[PYJHighScoreManager sharedManager] userCurrency] >= 10) {
            self.gladiatorUnlockAlertView = [[UIAlertView alloc] initWithTitle:@"Do you want to unlock the Gladiator Theme?" message:alertViewMessage delegate:self cancelButtonTitle:@"No thank you" otherButtonTitles:@"Buy it!", nil];
            [self.gladiatorUnlockAlertView show];
        } else {
            self.gladiatorUnlockAlertView = [[UIAlertView alloc] initWithTitle:@"Insufficient Funds" message:alertViewMessage delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [self.gladiatorUnlockAlertView show];
        }
    }
}
- (void) dealloc
{
	[super dealloc];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.jungleUnlockAlertView && buttonIndex == 1) {
        [[PYJThemeManager sharedManager] unlockJungleTheme];
        [self setThemeJungle:nil];
        
    } else if(alertView == self.gladiatorUnlockAlertView && buttonIndex == 1) {
        [[PYJThemeManager sharedManager] unlockGladiatorTheme];
        [self setThemeGladiator:nil];
    }
    
}

@end
