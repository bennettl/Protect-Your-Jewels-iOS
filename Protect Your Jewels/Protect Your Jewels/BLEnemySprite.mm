//
//  BLEnemySprite.m
//  GamePlay
//
//  Created by Bennett Lee on 2/20/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLEnemySprite.h"
#import "GB2Contact.h"
#import "BLSpriteLayer.h"
#import "BLGameplayScene.h"
#import "SimpleAudioEngine.h"

@interface BLEnemySprite()
// Reference to touch on the enemy
@property NSUInteger touchHash;
@end

@implementation BLEnemySprite

+(BLEnemySprite *)enemySprite{
    return [[[self alloc] initWithDynamicBody:@"ninja"
                              spriteFrameName:@"ninja/attack.png"] autorelease];
}

- (id)initWithSpriteLayer:(BLSpriteLayer *)sl{
    if (self = [super initWithDynamicBody:@"ninja"
                          spriteFrameName:@"ninja/attack.png"]){
    
        // Do not let the enemy rotate
        [self setFixedRotation:true];
        self.state = kAttack;
        spriteLayer = sl;  // Store the sprite layer
        
        // Set enemy to collide with everything
        for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()){
            b2Filter ef = f->GetFilterData();
            //ef.categoryBits = 0x0002;
            //ef.maskBits = 0xFFFF;
            ef.groupIndex = 2;
            f->SetFilterData(ef);
        }
        //self.body->SetGravityScale(0);        // Toggle gravity
    }
    return self;
}

#pragma mark audio
// Play when wave starts
+ (void)playHiyaAudio{
    [[SimpleAudioEngine sharedEngine] playEffect:@"ninja-hiya.caf"];
}
// Play when each enemy launches
- (void)playLaunchAudio{
    [[SimpleAudioEngine sharedEngine] playEffect:@"ninja_launch.caf"];
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

// Called by the GB2Engine on every frame for a GB2Node object to update the physics.
- (void)updateCCFromPhysics{
    [super updateCCFromPhysics];
    
    // Update image filename
    NSString *frameName;
    
    if (self.state == kAttack){
        frameName = @"ninja/attack.png";
    } else {
        frameName =@"ninja/fall.png";
    }
    
    [self setDisplayFrameNamed:frameName];
    
    // Update image orientation
    
    // Flip sprite horizontal if its position is on the left/right side of screen
    if (self.physicsPosition.x >  ([CCDirector sharedDirector].winSize.width/2/PTM_RATIO)){
        ((CCSprite *)self.ccNode).flipX = YES;
    } else{
        ((CCSprite *)self.ccNode).flipX = NO;
    }
    
}

// Does BQTouchCircle belong to touch object. Use for multi-touch tracking
- (BOOL)hasTouch:(UITouch *)touch{
    return (self.touchHash == touch.hash) ? YES : NO;
}

// Update touch
- (void)updateTouch:(UITouch *)touch{
    if(touch != nil){
        self.touchHash = touch.hash;
    }
    else{
        self.touchHash = nil;
    }
}

#pragma mark Collision Detection

// Write collision functions in the form of [objectA endContactWithMonkey:collisionA];

// Enemy collides with box
- (void)beginContactWithBLBoxNode:(GB2Contact *)contact{
    // Mark it for deletion
    self.deleteLater    = true;
    
    // Send a message to the gameplay scene to increment score and sprite layer to remove enemy from its array
    [((BLGameplayScene *)self.ccNode.parent.parent) incrementScore];
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
    self.state = kFall;
    ((BLEnemySprite *)contact.otherObject).state = kFall; // set enemy's state to fall
}

// Enemy collides with jewel
- (void)beginContactWithBLJewelSprite:(GB2Contact*)contact{
    
    // Send a message to the sprite layer to remove enemy from its array
    [((BLSpriteLayer *)self.ccNode.parent) removeEnemyFromSpriteLayer:self];
}

@end
