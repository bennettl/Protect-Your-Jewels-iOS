//
//  PYJJewelSprite.h
//  GamePlay
//
//  Created by Bennett Lee on 2/20/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "GB2Sprite.h"

@class PYJSpriteLayer;

@interface PYJJewelSprite : GB2Sprite {
    PYJSpriteLayer *spriteLayer;
}

+(PYJJewelSprite *)jewelSprite;

-(id)initWithSpriteLayer:(PYJSpriteLayer *)sl;
-(void)removeJewel;

@end
