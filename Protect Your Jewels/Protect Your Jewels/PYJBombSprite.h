//
//  PYJBombSprite.h
//  Protect Your Jewels
//
//  Created by Bennett Lee on 4/8/14.
//  Copyright 2014 ITP382RBBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GB2Sprite.h"
#import "PYJSpriteLayer.h"

@interface PYJBombSprite : GB2Sprite {
    PYJSpriteLayer *spriteLayer;
    BOOL removed;
}

-(id)initWithSpriteLayer:(PYJSpriteLayer *)sl;


@end
