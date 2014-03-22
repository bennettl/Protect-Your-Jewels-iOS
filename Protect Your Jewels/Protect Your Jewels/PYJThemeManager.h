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
    MOUNTAIN,
    JUNGLE,
    GLADIATOR
} Theme;

// PYJThemeManager track of what theme game is in

@interface PYJThemeManager : NSObject

@property (nonatomic) Theme theme;

// Singleton
+ (instancetype)sharedManager;
- (PYJBGLayer *)background;
- (PYJEnemySprite *)enemySprite;

@end
