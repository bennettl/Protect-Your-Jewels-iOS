//
//  RSThemeManager.h
//  Protect Your Jewels
//
//  Created by Ryan Stack on 3/8/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSBGLayer.h"
#import "BLEnemySprite.h"

// List of themes
typedef enum Theme{
    MOUNTAIN,
    JUNGLE,
    GLADIATOR
} Theme;

// RSThemeManager track of what theme game is in

@interface RSThemeManager : NSObject

@property (nonatomic) Theme theme;

// Singleton
+ (instancetype)sharedManager;
- (MSBGLayer *)background;
- (BLEnemySprite *)enemySprite;

@end
