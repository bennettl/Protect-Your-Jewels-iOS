//
//  BQTouchSprite.h
//  GamePlay
//
//  Created by Brian Quock on 2/22/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "GB2Sprite.h"

@class BLSpriteLayer;

@interface BQTouchCircle : GB2Sprite {
    BLSpriteLayer *spriteLayer;
}

-(id)initWithSpriteLayer:(BLSpriteLayer *)sl;
-(BOOL)intersectsWithPoint:(CGPoint)ccLocation;

@end
