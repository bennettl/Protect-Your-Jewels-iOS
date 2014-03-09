//
//  RSTrojanSprite.h
//  Protect Your Jewels
//
//  Created by Ryan Stack on 3/8/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLEnemySprite.h"

@interface RSTrojanSprite : BLEnemySprite

+ (RSTrojanSprite *)enemySprite;
- (id)initWithSpriteLayer:(BLSpriteLayer *)sl;

@end
