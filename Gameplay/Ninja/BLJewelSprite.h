//
//  GB2Jewel.h
//  GamePlay
//
//  Created by Bennett Lee on 2/20/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "GB2Sprite.h"

@class BLSpriteLayer;

@interface BLJewelSprite : GB2Sprite {
    BLSpriteLayer *spriteLayer;
}

+(BLJewelSprite *)jewelSprite;

-(id)initWithSpriteLayer:(BLSpriteLayer *)sl;

@end
