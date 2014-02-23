//
//  BQTouchSprite.m
//  GamePlay
//
//  Created by Brian Quock on 2/22/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BQTouchCircle.h"

@implementation BQTouchCircle

- (id)initWithSpriteLayer:(BLSpriteLayer *)sl{
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
        
        // Anti - gravity
        self.body->ApplyForce(self.body->GetMass() * -world->GetGravity(), self.body->GetWorldCenter());

        
        spriteLayer = sl;  // Store the sprite layer
        
        // Set touch to collide with everything but the jewel
//        for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()){
//            b2Filter tf         = f->GetFilterData();
//            tf.categoryBits     =0x0008;
//            tf.maskBits         = 0x0004;
//            tf.groupIndex       = 2;
//            f->SetFilterData(tf);
//        }
    }
    return self;
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
