//
//  PYJThemeManager.mm
//  Protect Your Jewels
//
//  Created by Ryan Stack on 3/8/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJThemeManager.h"
#import "PYJHighScoreManager.h"

#define JUNGLE_UNLOCKED_KEY @"jungleUnlockedKey"
#define GLADIATOR_UNLOCKED_KEY @"jungleUnlockedKey"

@implementation PYJThemeManager

+ (instancetype)sharedManager {
    static PYJThemeManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    // Default theme is MOUNTAIN
    if (self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _theme = MOUNTAIN;
        if(![defaults objectForKey:JUNGLE_UNLOCKED_KEY]) {
            _isJungleThemeUnlocked = NO;
        } else {
            _isJungleThemeUnlocked = [defaults boolForKey:JUNGLE_UNLOCKED_KEY];
        }
        if(![defaults objectForKey:GLADIATOR_UNLOCKED_KEY]) {
            _isGladiatorThemeUnlocked = NO;
        } else {
            _isGladiatorThemeUnlocked = [defaults boolForKey:GLADIATOR_UNLOCKED_KEY];
        }
    }
    return self;
}
#pragma message "remove the price and set as data member"
- (void)unlockGladiatorTheme {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isGladiatorThemeUnlocked = YES;
    [[PYJHighScoreManager sharedManager] updateInGameCurrency:-10];
    [defaults setBool:self.isGladiatorThemeUnlocked forKey:GLADIATOR_UNLOCKED_KEY];
    
}

- (void)unlockJungleTheme {
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.isJungleThemeUnlocked = YES;
    [[PYJHighScoreManager sharedManager] updateInGameCurrency:-10];
    [defaults setBool:self.isJungleThemeUnlocked forKey:JUNGLE_UNLOCKED_KEY];
}

// Sets the theme (enum)
- (void)setTheme:(Theme)theme{
    _theme = theme;
}

// Return an background layer base on theme
- (PYJBGLayer *)background{
    PYJBGLayer *bg = nil;
    
    switch (_theme) {
        case MOUNTAIN:
            bg = [[[PYJBGLayer alloc] initWithTheme:@"Mountain"] autorelease];
            break;
        case JUNGLE:
            bg = [[[PYJBGLayer alloc] initWithTheme:@"Jungle"] autorelease];
            break;
        case GLADIATOR:
            bg = [[[PYJBGLayer alloc] initWithTheme:@"Temple"] autorelease];
            break;
        default:
            break;
    }
    return bg;
}

// Return an enemy sprite base on theme
- (PYJEnemySprite *)enemySprite{
    
    PYJEnemySprite *es = nil;
    
    switch (_theme) {
        case MOUNTAIN:
            es = [[PYJEnemySprite alloc] initWithTheme:@"Mountain"];
            break;
        case JUNGLE:
            es = [[PYJEnemySprite alloc] initWithTheme:@"Jungle"];
            break;
        case GLADIATOR:
            es = [[PYJEnemySprite alloc] initWithTheme:@"Temple"];
            break;
        default:
            break;
    }
    return es;
}

@end
