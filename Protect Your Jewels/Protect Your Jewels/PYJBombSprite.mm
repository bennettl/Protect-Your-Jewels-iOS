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
        removed = NO;
    }
    return self;
}

// Bomb collides with box
- (void)beginContactWithPYJBoxNode:(GB2Contact *)contact{
    // Mark it for deletion
    self.deleteLater    = true;
}

// When the PYJTouchCircle collides with enemy, play the punch audio
-(void)beginContactWithPYJTouchCircle:(GB2Contact *)contact{
    if(removed == NO){
        removed = YES;
        PYJGameplayScene *gpScene = ((PYJGameplayScene *)self.ccNode.parent.parent);
        
        // Tell scene to decrement the lives counter
        [gpScene decrementLives];
        
        // Mark it for deletion
        self.deleteLater    = true;
    }
    
}

-(void)removeBomb{
    self.deleteLater = true;
}

- (void)dealloc{
    [super dealloc];
}

@end
