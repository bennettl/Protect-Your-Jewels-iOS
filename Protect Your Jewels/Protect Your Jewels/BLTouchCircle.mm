//
//  BQTouchSprite.mm
//  GamePlay
//
//  Created by Brian Quock on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "BLTouchCircle.h"

@implementation BLTouchCircle

- (id)initWithTouch:(UITouch *)touch andGroundBody:(b2Body *)body{
    if (self = [super initWithDynamicBody:nil node:nil]){
        
        // Create a circle
        b2CircleShape circle;
        circle.m_radius         = 1.0f;
        // Setup fixturedef
        b2FixtureDef fd;
        fd.shape                = &circle;
        fd.density              = 5.0f;
        fd.friction             = 0.0f;
        fd.restitution          = 0.0f;
        fd.filter.categoryBits  = 0x0008;
        fd.filter.maskBits      = 0x0004;
        fd.filter.groupIndex    = 2;
        
        [self addFixture:&fd];
        
        // Set touch
        
        CGPoint ccLocation  = [[CCDirector sharedDirector] convertTouchToGL:touch];
        b2Vec2 b2Location = b2Vec2FromCC(ccLocation.x, ccLocation.y);
        
        [self setPhysicsPosition:b2Location];
        [self createMouseJointWithGroundBody:body target:b2Location maxForce:5000];

        self.touchHash = touch.hash; // touch identifier
        
        // Anti - gravity
        self.body->ApplyForce(self.body->GetMass() * -world->GetGravity(), self.body->GetWorldCenter());

    }
    return self;
}

// Returns 'YES' if touch circle is connected to touch. Use for multi-touch tracking
- (BOOL)connectedToTouch:(UITouch *)touch{
    return (self.touchHash == touch.hash) ? YES : NO;
}

// Does ccLocation intersect with any of the body's fixtures?
-(BOOL)intersectsWithPoint:(CGPoint)ccLocation{
    b2Vec2 b2Location(ccLocation.x/PTM_RATIO, ccLocation.y/PTM_RATIO);
    
    // Loop through and test all fixtures
    for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()){
        if (f->TestPoint(b2Location)){
            return YES;
        }
    }
    return NO;
}

@end
