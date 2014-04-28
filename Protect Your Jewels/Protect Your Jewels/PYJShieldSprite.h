//
//  PYJShieldSprite.h
//  Protect Your Jewels
//
//  Created by Ryan Stack on 4/25/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "GB2Sprite.h"


@class PYJSpriteLayer;

@interface PYJShieldSprite : GB2Sprite {
     PYJSpriteLayer *spriteLayer;
}

+(PYJShieldSprite *)shieldSprite;

-(id)initWithSpriteLayer:(PYJSpriteLayer *)sl;
-(void)removeShield;

@end


