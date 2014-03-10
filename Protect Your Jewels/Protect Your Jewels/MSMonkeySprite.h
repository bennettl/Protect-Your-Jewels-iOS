//
//  MSMonkeySprite.h
//  Protect Your Jewels
//
//  Created by Megan Sullivan on 3/9/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLEnemySprite.h"

@interface MSMonkeySprite : BLEnemySprite

+ (MSMonkeySprite *)enemySprite;
- (id)initWithSpriteLayer:(BLSpriteLayer *)sl;

@end
