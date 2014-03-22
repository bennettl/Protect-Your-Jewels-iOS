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

- (id)initWithTheme:(NSString *)theme {
    m_Theme = theme;
    // True if successful inits
    BOOL oneTrue = NO;
    
    // Init based on theme
    if([theme isEqualToString:@"Mountain"]){
        if (self = [super initWithDynamicBody:@"ninja"
                              spriteFrameName:@"ninja/attack.png"]){
            oneTrue = YES;
        }
    }
    else if([theme isEqualToString:@"Temple"]){
        if (self = [super initWithDynamicBody:@"ninja"
                              spriteFrameName:@"gladiator/attack.png"]){
            oneTrue = YES;
        }
    }
    else if([theme isEqualToString:@"Jungle"]){
        if (self = [super initWithDynamicBody:@"ninja"
                              spriteFrameName:@"monkey/attack.png"]){
            oneTrue = YES;
        }
    }
    
    // True if successful inits
    if(oneTrue){
        // Do not let the enemy rotate
        [self setFixedRotation:true];
        self.state = kAttack;
        
        // Set enemy to collide with everything
        for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()){
            b2Filter ef = f->GetFilterData();
            ef.groupIndex = 2;
            f->SetFilterData(ef);
        }
        self.body->SetGravityScale(0.9); // Toggle gravity
        
        self.touchHash = -1; // -1 means its not associated with any touches
    }
    return self;
}

#pragma mark Audio

+ (void)playAttackAudio{
    [[SimpleAudioEngine sharedEngine] playEffect:@"ninja-hiya.caf"];
}

- (void)playLaunchAudio{
    [[SimpleAudioEngine sharedEngine] playEffect:@"ninja_launch.caf"];
}

#pragma mark Sprite

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

// Use for multi-touch tracking
- (BOOL)hasTouch:(UITouch *)touch{
    return (self.touchHash == touch.hash) ? YES : NO;
}

// Update touch hash (the identifier for touch)
- (void)updateTouch:(UITouch *)touch{
    self.touchHash = (touch == nil) ? -1 : touch.hash;
}

// Called by the GB2Engine on every frame for a GB2Node object to update the physics.
- (void)updateCCFromPhysics{
    [super updateCCFromPhysics];
    
    // Update image filename
    NSString *frameName;
    
    // Change frame name base on enemy state
    if (self.state == kAttack){
        if([m_Theme isEqualToString: @"Mountain"]){
            frameName = @"ninja/attack.png";
        }
        else if([m_Theme isEqualToString: @"Jungle"]){
            frameName = @"monkey/attack.png";
        }
        else if([m_Theme isEqualToString: @"Temple"]){
            frameName = @"gladiator/attack.png";
        }
    } else {
        if([m_Theme isEqualToString: @"Mountain"]){
            frameName =@"ninja/fall.png";
        }
        else if([m_Theme isEqualToString: @"Jungle"]){
            frameName =@"monkey/fall.png";
        }
        else if([m_Theme isEqualToString: @"Temple"]){
            frameName =@"gladiator/fall.png";
        }
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
    if (self.touchHash != -1 && (self.state == kAttack || ((BLEnemySprite *)contact.otherObject).state == kAttack)){
        self.state = kFall;
        [[SimpleAudioEngine sharedEngine] playEffect:@"punch.caf"];
    }
    ((BLEnemySprite *)contact.otherObject).state = kFall; // set enemy's state to fall
}

// Enemy collides with jewel
- (void)beginContactWithBLJewelSprite:(GB2Contact*)contact{
    // If enemy is in attack state
    if (self.state == kAttack){
        // Send a message to the sprite layer to remove enemy from its array
        [((BLSpriteLayer *)self.ccNode.parent) removeEnemyFromSpriteLayer:self];
    }
}

@end
