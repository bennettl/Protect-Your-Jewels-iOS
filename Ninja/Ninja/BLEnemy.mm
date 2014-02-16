//
//  BLNinja.m
//  Ninja
//
//  Created by Bennett Lee on 2/15/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLEnemy.h"

#define PTM_RATIO 32.0f
#define BOX_TAG 1
#define ENEMY_TAG 2

@implementation BLEnemy

- (id)initWithWorld:(b2World *)world andLocation:(CGPoint)location{

    if (self = [super init]){
    
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        float _forceMultiplier = 3000.0;
        self.world = world;
        
        // Create a CC Sprite
        self.sprite = [CCSprite spriteWithFile:@"ball.png"];
        self.sprite.position = ccp(location.x, location.y);
        self.sprite.tag      = ENEMY_TAG;
        
        // Create a body def and body
        self.bodyDef            = new b2BodyDef();
        self.bodyDef->type = b2_dynamicBody;
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
        
        // Get center vector
        CGPoint pointA                  = self.sprite.position;
        CGPoint pointB                  = ccp(winSize.width/2, winSize.height/2);
        CGPoint pointC                  = ccpSub(pointB, pointA);
        pointC                          = ccpNormalize(pointC);
        
        b2Vec2 force = b2Vec2((pointC.x/PTM_RATIO) * _forceMultiplier,
                              (pointC.y/PTM_RATIO) * _forceMultiplier);
        
        self.body->ApplyLinearImpulse(force, self.body->GetPosition());
        
//        NSLog(@"%f %f",pointC.x, pointC.y);
    }
    return self;
    
}

- (BOOL)intersectsWithPoint:(CGPoint)ccLocation{
    b2Vec2 b2Location   = b2Vec2(ccLocation.x/PTM_RATIO, ccLocation.y/PTM_RATIO);    
    return (self.fixture->TestPoint(b2Location)) ? YES : NO;
}


-(void)update:(ccTime)dt{

}

-(void)dealloc {
    delete self.bodyDef;
    delete self.shapeDef;
    delete self.fixtureDef;
    [self setBody:nil];
    [self setBodyDef:nil];
    [self setShapeDef:nil];
    [self setFixtureDef:nil];
    [super dealloc];
}


@end
