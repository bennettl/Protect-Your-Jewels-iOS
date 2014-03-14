//
//  BLJewelSprite.mm
//  GamePlay
//
//  Created by Bennett Lee on 2/20/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "BLJewelSprite.h"
#import "GB2Contact.h"
#import "BLGameplayScene.h"
#import "BLEnemySprite.h"

@implementation BLJewelSprite

+ (BLJewelSprite *)jewelSprite{
    return [[[self alloc] initWithStaticBody:@"jewel" spriteFrameName:@"jewel.png"] autorelease];
}

- (id)initWithSpriteLayer:(BLSpriteLayer *)sl{
    if (self = [super initWithStaticBody:@"jewel"
                          spriteFrameName:@"jewel.png"]){
        
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

#pragma mark Collision Detection

// When jewel touches enemy sprite
- (void)beginContactWithBLEnemySprite:(GB2Contact*)contact{
    BLGameplayScene *gpScene = ((BLGameplayScene *)self.ccNode.parent.parent.parent);
    
    // If enemy is in attack mode
    if (((BLEnemySprite *)contact.otherObject).state == kAttack){
        // Tell scene to decrement the lives counter
        [gpScene decrementLives];
        
        // Mark BLEnemySprite for deletion
        if (gpScene.lives > 0) {
            contact.otherObject.deleteLater = true;
        }
    }
}

@end

