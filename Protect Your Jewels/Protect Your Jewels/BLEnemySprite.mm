//
//  BLEnemySprite.mm
//  GamePlay
//
//  Created by Bennett Lee on 2/20/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "BLEnemySprite.h"
#import "GB2Contact.h"
#import "BLSpriteLayer.h"
#import "BLGameplayScene.h"
#import "SimpleAudioEngine.h"

@interface BLEnemySprite()

@end

@implementation BLEnemySprite

#pragma mark audio
// Implemented by subclass
+ (void)playAttackAudio{
    return;
}
// Implemented by subclass
- (void)playLaunchAudio{
    return;
}

// Does ccLocation intersect with any of the body's fixtures?
-(BOOL)intersectsWithPoint:(CGPoint)ccLocation{
    b2Vec2 b2Location(ccLocation.x/PTM_RATIO, ccLocation.y/PTM_RATIO);

    // Loop through and test all fixtures
    for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()){
        if (f->TestPoint(b2Location)){
            self.state = kFall; // set state to kfall if a point touches enemy
            return YES;
        }
    }
    return NO;
}

#pragma mark Sprite

// Use for multi-touch tracking
- (BOOL)hasTouch:(UITouch *)touch{
    return (self.touchHash == touch.hash) ? YES : NO;
}

// Update touch
- (void)updateTouch:(UITouch *)touch{
    if(touch != nil){
        self.touchHash = touch.hash;
    }
    else{
        self.touchHash = -1;
    }
}

#pragma mark Collision Detection

// Write collision functions in the form of [objectA endContactWithMonkey:collisionA];

// Enemy collides with box
- (void)beginContactWithBLBoxNode:(GB2Contact *)contact{
    // Mark it for deletion
    self.deleteLater    = true;
    
    // Send a message to the gameplay scene to increment score ONLY if ninja is in fall state
    if (self.state == kFall){
        [((BLGameplayScene *)self.ccNode.parent.parent) incrementScore];
    }

    // Send a message to the sprite layer to remove enemy from its array
    [((BLSpriteLayer *)self.ccNode.parent) removeEnemyFromSpriteLayer:self];

}

// When the BQTouchCircle collides with enemy, play the punch audio
-(void)beginContactWithBQTouchCircle:(GB2Contact *)contact{
    // Change ninja state when he's hit with BQTouchCircle
    if (self.state == kAttack){
        self.state = kFall;
        // Only play punch audio once
        [[SimpleAudioEngine sharedEngine] playEffect:@"punch.caf"];
       // [[SimpleAudioEngine sharedEngine] playEffect:@"ninja_ahh.caf"];
    }
}

// Enemy collides with each other
- (void)beginContactWithBLEnemySprite:(GB2Contact *)contact{
    if(self.touchHash != -1 && (self.state == kAttack || ((BLEnemySprite *)contact.otherObject).state == kAttack)){
        self.state = kFall;
        [[SimpleAudioEngine sharedEngine] playEffect:@"punch.caf"];
    }
    ((BLEnemySprite *)contact.otherObject).state = kFall; // set enemy's state to fall
}

// Enemy collides with jewel
- (void)beginContactWithBLJewelSprite:(GB2Contact*)contact{
    
    // Send a message to the sprite layer to remove enemy from its array
    [((BLSpriteLayer *)self.ccNode.parent) removeEnemyFromSpriteLayer:self];
}

@end
