//
//  BLEnemySprite.h
//  GamePlay
//
//  Created by Bennett Lee on 2/20/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "GB2Sprite.h"

@class BLSpriteLayer;

typedef enum {
    kAttack,
    kFall,
} EnemyState;


@interface BLEnemySprite : GB2Sprite {
    BLSpriteLayer *spriteLayer; // weak reference
}

@property EnemyState state;

+(BLEnemySprite *)enemySprite;

- (id)initWithSpriteLayer:(BLSpriteLayer *)sl;
+ (void)playHiyaAudio;
- (void)playLaunchAudio;

- (BOOL)intersectsWithPoint:(CGPoint)ccLocation;

-(void)updateTouch:(UITouch *)touch;

// Use for multi-touch tracking
- (BOOL)hasTouch:(UITouch *)touch;

@end
