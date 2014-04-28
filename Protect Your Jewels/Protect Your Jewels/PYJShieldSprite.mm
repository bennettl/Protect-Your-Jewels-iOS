//
//  PYJShieldSprite.m
//  Protect Your Jewels
//
//  Created by Ryan Stack on 4/25/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJShieldSprite.h"
#import "GB2Contact.h"
#import "PYJGameplayScene.h"
#import "PYJEnemySprite.h"


@implementation PYJShieldSprite

+(PYJShieldSprite *)shieldSprite{
    return [[[self alloc] initWithStaticBody:@"shield" spriteFrameName:@"jewel.png"] autorelease];
}

- (id)initWithSpriteLayer:(PYJSpriteLayer *)sl{
    if (self = [super initWithStaticBody:@"shield"
                         spriteFrameName:@"jewel.png"]){
        
        spriteLayer = sl;  // Store the sprite layer
        
        // Set shield to collide with everything but the player control
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

-(void)removeShield {
    self.deleteLater = true;
}

@end
