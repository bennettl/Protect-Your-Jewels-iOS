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
        
        // Set jewel to collide with everything but the player control
        for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()){
            b2Filter jf         = f->GetFilterData();
            jf.categoryBits     = 0x0004;
            jf.maskBits         = 0xFFFF ^ 0x0008;
            jf.groupIndex       = -1;
            f->SetFilterData(jf);
        }
    }
    return self;
}

@end
