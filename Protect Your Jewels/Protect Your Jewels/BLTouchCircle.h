//
//  BQTouchSprite.h
//  GamePlay
//
//  Created by Bennett Lee on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "GB2Sprite.h"

@class BLSpriteLayer;

@interface BLTouchCircle : GB2Sprite {
    BLSpriteLayer *spriteLayer;
}

- (id)initWithTouch:(UITouch *)touch andGroundBody:(b2Body *)body;

- (BOOL)intersectsWithPoint:(CGPoint)ccLocation;

// Does BQTouchCircle belong to touch object. Use for multi-touch tracking
- (BOOL)connectedToTouch:(UITouch *)touch;

// Reference to the touch that create the object
@property NSUInteger touchHash;

@end
