//
//  PYJEnemySprite.mm
//  GamePlay
//
//  Created by Bennett Lee on 2/20/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJEnemySprite.h"
#import "GB2Contact.h"
#import "PYJSpriteLayer.h"
#import "PYJGameplayScene.h"
#import "SimpleAudioEngine.h"

@interface PYJEnemySprite()
{
    int enemyPointValue;
}
@end

@implementation PYJEnemySprite

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
        
        enemyPointValue = 1;    // Points added to score when enemy is defeated
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
    //NSString *frameName = nil;
    NSMutableArray *files = nil;
    
    // Change frame name base on enemy state
    if (self.state == kAttack){
        if([m_Theme isEqualToString: @"Mountain"]){
            //frameName = @"ninja/attack.png";
            files = [NSMutableArray arrayWithObjects:@"ninja/attack.png", nil];
        }
        else if([m_Theme isEqualToString: @"Jungle"]){
            //frameName = @"monkey/attack.png";
            files = [NSMutableArray arrayWithObjects:@"monkey/attack.png", nil];
        }
        else if([m_Theme isEqualToString: @"Temple"]){
            //frameName = @"gladiator/attack.png";
            files = [NSMutableArray arrayWithObjects:@"gladiator/attack.png", nil];
        }
    } else {
        
        if([m_Theme isEqualToString: @"Mountain"]){
            //frameName =@"ninja/fall.png";
            files = [NSMutableArray arrayWithObjects:@"ninja/fall.png", nil];
        }
        else if([m_Theme isEqualToString: @"Jungle"]){
            //frameName =@"monkey/fall.png";
            files = [NSMutableArray arrayWithObjects:@"monkey/fall.png", nil];

        }
        else if([m_Theme isEqualToString: @"Temple"]){
            //frameName =@"gladiator/fall.png";
            //files = [NSMutableArray arrayWithObjects:@"gladiator/fall-00.png", @"gladiator/fall-01.png", @"gladiator/fall-02.png", nil];
            files = [NSMutableArray arrayWithObjects:@"gladiator/fall.png", nil];
        }
    }
    
    //[self setDisplayFrameNamed:frameName];
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:10];
    
    // Load each frame into the frames array
    for (int i = 0; i < files.count; i++)
    {
        NSString *file = [files objectAtIndex:i];
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
        [frames addObject:frame];
    }
    
    // Clear any previous actions
    [self stopAllActions];
    
    // Start new animation
    CCAnimation *anim = [CCAnimation animationWithSpriteFrames:frames delay:0.15f];
    CCAnimate *animate = [CCAnimate actionWithAnimation:anim];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
    [self runAction:repeat];
    
    
    // Update image orientation
    
    // Flip sprite horizontal if its position is on the left/right side of screen
    if (self.physicsPosition.x >  ([CCDirector sharedDirector].winSize.width/2/PTM_RATIO)){
        ((CCSprite *)self.ccNode).flipX = YES;
    } else{
        ((CCSprite *)self.ccNode).flipX = NO;
    }
}

#pragma mark Collision Detection

// Set collisions with the jewel
- (void)canCollideWithJewel:(BOOL)jewelCollision{
    if(jewelCollision){
        
        for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()){
            b2Filter ef = f->GetFilterData();
            ef.categoryBits = 0x0001;
            ef.maskBits = 0xFFFF;
            ef.groupIndex = 2;
            f->SetFilterData(ef);
        }
    }
    else{
        
        for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()){
            b2Filter ef = f->GetFilterData();
            ef.categoryBits  = 0x0008;
            ef.maskBits      = 0x0004;
            ef.groupIndex    = 2;
            f->SetFilterData(ef);
        }
    }
}

// Write collision functions in the form of [objectA endContactWithEnemy:collisionA];

// Enemy collides with box
- (void)beginContactWithPYJBoxNode:(GB2Contact *)contact{
    // Mark it for deletion
    self.deleteLater    = true;
    
    // Send a message to the gameplay scene to increment score ONLY if ninja is in fall state
    if (self.state == kFall){
        [((PYJGameplayScene *)self.ccNode.parent.parent) incrementScoreByValue:enemyPointValue];
    }

    // Send a message to the sprite layer to remove enemy from its array
    [((PYJSpriteLayer *)self.ccNode.parent) removeEnemyFromSpriteLayer:self];

}

// When the PYJTouchCircle collides with enemy, play the punch audio
-(void)beginContactWithPYJTouchCircle:(GB2Contact *)contact{
    // Change ninja state when he's hit with PYJTouchCircle
    if (self.state == kAttack){
        self.state = kFall;
        [self canCollideWithJewel:NO];
        // Only play punch audio once
        [[SimpleAudioEngine sharedEngine] playEffect:@"punch.caf"];
       // [[SimpleAudioEngine sharedEngine] playEffect:@"ninja_ahh.caf"];
    }
}

-(void)beginContactWithPYJShieldSprite:(GB2Contact *)contact {
    //change ninja state when he hits the sheild
    if (self.state == kAttack) {
        self.state = kFall;
        [self canCollideWithJewel:NO];
    }
}

// Enemy collides with each other
- (void)beginContactWithPYJEnemySprite:(GB2Contact *)contact{
    // Change state and play punch on first contact
    if (self.touchHash != -1 && (self.state == kAttack || ((PYJEnemySprite *)contact.otherObject).state == kAttack)){
        self.state = kFall;
        [self canCollideWithJewel:NO];
        [[SimpleAudioEngine sharedEngine] playEffect:@"punch.caf"];
    }
    // Criteria for combo
    else if(self.touchHash == -1 && self.state == kFall && ((PYJEnemySprite *)contact.otherObject).state == kAttack){
        enemyPointValue+=2;
        [[SimpleAudioEngine sharedEngine] playEffect:@"ninja_ahh.caf"];
    }
    ((PYJEnemySprite *)contact.otherObject).state = kFall; // set enemy's state to fall
    [((PYJEnemySprite *)contact.otherObject) canCollideWithJewel:NO];
}

// Enemy collides with jewel
- (void)beginContactWithPYJJewelSprite:(GB2Contact*)contact{
    // If enemy is in attack state
    if (self.state == kAttack){
        // Send a message to the sprite layer to remove enemy from its array
        [((PYJSpriteLayer *)self.ccNode.parent) removeEnemyFromSpriteLayer:self];
    }
}

- (void)dealloc{
    [super dealloc];
}

@end
