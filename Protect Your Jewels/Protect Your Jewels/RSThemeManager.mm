//
//  RSThemeManager.mm
//  Protect Your Jewels
//
//  Created by Ryan Stack on 3/8/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "RSThemeManager.h"
#import "RSTrojanSprite.h"
#import "RSMonkeySprite.h"
#import "BLNinjaSprite.h"

@implementation RSThemeManager

+ (instancetype)sharedManager {
    static RSThemeManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    // Default theme is MOUNTAIN
    if (self = [super init]) {
        self.theme = MOUNTAIN;
    }
    return self;
}

// Sets the theme (enum)
- (void)setTheme:(Theme)theme{
    _theme = theme;
}

// Return an background layer base on theme
- (MSBGLayer *)background{
    MSBGLayer *bg = nil;
    
    switch (_theme) {
        case MOUNTAIN:
            //bg =  [MSMountainBGLayer node];
            bg = [[[MSBGLayer alloc] initWithTheme:@"Mountain"] autorelease];
            break;
        case JUNGLE:
            //bg = [MSJungleBGLayer node];
            bg = [[[MSBGLayer alloc] initWithTheme:@"Jungle"] autorelease];
            break;
        case GLADIATOR:
            //bg = [MSTempleBGLayer node];
            bg = [[[MSBGLayer alloc] initWithTheme:@"Temple"] autorelease];
            break;
        default:
            break;
    }
    return bg;
}

// Return an enemy sprite base on theme
- (BLEnemySprite *)enemySprite{
    
    BLEnemySprite *es = nil;
    
    switch (_theme) {
        case MOUNTAIN:
            es = [[BLEnemySprite alloc] initWithTheme:@"Mountain"];
            break;
        case JUNGLE:
            es = [[BLEnemySprite alloc] initWithTheme:@"Jungle"];
            break;
        case GLADIATOR:
            es = [[BLEnemySprite alloc] initWithTheme:@"Temple"];
            break;
        default:
            break;
    }
    return es;
}

@end
