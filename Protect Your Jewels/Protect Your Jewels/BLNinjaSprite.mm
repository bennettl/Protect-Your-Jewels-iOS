//
//  BLNinjaSprite.m
//  Protect Your Jewels
//
//  Created by Bennett Lee on 3/7/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLNinjaSprite.h"
#import "SimpleAudioEngine.h"

@implementation BLNinjaSprite

#pragma mark initalization
+ (BLNinjaSprite *)enemySprite{
    return [[[self alloc] initWithDynamicBody:@"ninja"
                              spriteFrameName:@"ninja/attack.png"] autorelease];
}

- (id)init{
    if (self = [super initWithDynamicBody:@"ninja"
                          spriteFrameName:@"ninja/attack.png"]){
        
        // Do not let the enemy rotate
        [self setFixedRotation:true];
        self.state = kAttack;
        
        // Set enemy to collide with everything
        for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()){
            b2Filter ef = f->GetFilterData();
            //ef.categoryBits = 0x0002;
            //ef.maskBits = 0xFFFF;
            ef.groupIndex = 2;
            f->SetFilterData(ef);
        }
        self.body->SetGravityScale(0.9);        // Toggle gravity
    }
    return self;
}


#pragma mark audio
// Play when wave starts
+ (void)playAttackAudio{
    [[SimpleAudioEngine sharedEngine] playEffect:@"ninja-hiya.caf"];
}
// Play when each enemy launches
- (void)playLaunchAudio{
    [[SimpleAudioEngine sharedEngine] playEffect:@"ninja_launch.caf"];
}

// Called by the GB2Engine on every frame for a GB2Node object to update the physics.
- (void)updateCCFromPhysics{
    [super updateCCFromPhysics];
    
    // Update image filename
    NSString *frameName;

    // Change frame name base on enemy state
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

@end
