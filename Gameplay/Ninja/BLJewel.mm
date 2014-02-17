//
//  BLJewel.m
//  Ninja
//
//  Created by Bennett Lee on 2/16/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLJewel.h"

@implementation BLJewel

// Constructure
- (id)initWithWorld:(b2World *)world{
    
    if (self = [super init]){
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.world = world;
        
        // Create a CC Sprite
        self.sprite = [CCSprite spriteWithFile:@"jewel.png"];
        self.sprite.position = ccp(winSize.width/2, winSize.height/2);
        self.sprite.tag      = JEWEL_TAG;
        
        // Create a body def and body
        self.bodyDef            = new b2BodyDef();
        self.bodyDef->position.Set(self.sprite.position.x/PTM_RATIO, self.sprite.position.y/PTM_RATIO);
        self.bodyDef->userData  = self.sprite;
        self.body = self.world->CreateBody(self.bodyDef);
        
        // Create shape
        b2CircleShape circle;
        circle.m_radius = 26.0/PTM_RATIO;
        
        // Create fixture def and fixture
        self.fixtureDef                 = new b2FixtureDef();
        self.fixtureDef->shape          = &circle;
        self.fixtureDef->density        = 10.0f;
        self.fixtureDef->friction       = 0.1f;
        self.fixtureDef->restitution    = 0.5f;
        self.fixture                    = self.body->CreateFixture(self.fixtureDef);
        
        //        NSLog(@"%f %f",pointC.x, pointC.y);
    }
    return self;
    
}

@end
