//
//  BLJewelSprite.h
//  GamePlay
//
//  Created by Bennett Lee on 2/20/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "GB2Sprite.h"

@class BLSpriteLayer;

@interface BLJewelSprite : GB2Sprite {
    BLSpriteLayer *spriteLayer;
}

+(BLJewelSprite *)jewelSprite;

-(id)initWithSpriteLayer:(BLSpriteLayer *)sl;

@end
