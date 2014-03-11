//
//  BLSpriteLayer.h
//  Ninja
//
//  Created by Bennett Lee on 2/15/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"

@class BLEnemySprite;

//#import "GLES-Render.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
//#define PTM_RATIO 32

// HelloWorldLayer
@interface BLSpriteLayer : CCLayer

// Remove BLEnemySprite from enemies mutable array
- (void)removeEnemyFromSpriteLayer:(BLEnemySprite *)es;

- (void)removeMouseJoint:(BLEnemySprite*)es;

- (void)decNumEnemiesTouched;

@end
