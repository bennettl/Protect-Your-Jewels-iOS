//
//  PYJBombSprite.m
//  Protect Your Jewels
//
//  Created by Bennett Lee on 4/8/14.
//  Copyright 2014 ITP382RBBM. All rights reserved.
//

#import "PYJBombSprite.h"
#import "GB2Contact.h"
#import "PYJGameplayScene.h"

@implementation PYJBombSprite

- (id)initWithSpriteLayer:(PYJSpriteLayer *)sl{
    if (self = [super initWithDynamicBody:@"bomb" spriteFrameName:@"bomb.png"]){
        
        spriteLayer = sl;  // Store the sprite layer
        
        for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()){
            b2Filter ef = f->GetFilterData();
            ef.categoryBits  = 0x0008;
            ef.maskBits      = 0x0004;
            ef.groupIndex    = 2;
            f->SetFilterData(ef);
        }
    }
    return self;
}

@end
