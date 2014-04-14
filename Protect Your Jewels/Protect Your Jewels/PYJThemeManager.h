//
//  PYJThemeManager.h
//  Protect Your Jewels
//
//  Created by Ryan Stack on 3/8/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYJBGLayer.h"
#import "PYJEnemySprite.h"

// List of themes
typedef enum Theme{
    MOUNTAIN_LOCKED,
    MOUNTAIN,
    JUNGLE_LOCKED,
    JUNGLE,
    GLADIATOR_LOCKED,
    GLADIATOR
} Theme;

// PYJThemeManager track of what theme game is in

@interface PYJThemeManager : NSObject

@property (nonatomic) Theme theme;
@property (nonatomic) BOOL isGladiatorThemeUnlocked;
@property (nonatomic) BOOL isJungleThemeUnlocked;


// Singleton
+ (instancetype)sharedManager;
- (PYJBGLayer *)background;
- (PYJEnemySprite *)enemySprite;
- (void)unlockGladiatorTheme;
- (void)unlockJungleTheme;

@end
