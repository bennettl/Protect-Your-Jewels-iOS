//
//  BLNinjaSprite.h
//  Protect Your Jewels
//
//  Created by Bennett Lee on 3/7/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLEnemySprite.h"

@interface BLNinjaSprite : BLEnemySprite

+ (BLNinjaSprite *)enemySprite;
- (id)initWithSpriteLayer:(BLSpriteLayer *)sl;

@end
