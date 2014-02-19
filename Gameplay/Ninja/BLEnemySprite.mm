//
//  BLEnemyPolygon.m
//  GamePlay
//
//  Created by Bennett Lee on 2/18/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLEnemySprite.h"

@implementation BLEnemySprite


- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)ccLocation{
    NSString *filename  = @"ninja_attack.png";
    int verticiesCount  = 7;
    float _forceMultiplier = 100;
    b2Vec2 verticies[]  = {
        b2Vec2(17.0/PTM_RATIO, 6.0/PTM_RATIO),
        b2Vec2(39.0/PTM_RATIO, 10.0/PTM_RATIO),
        b2Vec2(53.0/PTM_RATIO, 37.0/PTM_RATIO),
        b2Vec2(41.0/PTM_RATIO, 58.0/PTM_RATIO),
        b2Vec2(26.0/PTM_RATIO, 58.0/PTM_RATIO),
        b2Vec2(16.0/PTM_RATIO, 48.0/PTM_RATIO),
        b2Vec2(12.0/PTM_RATIO, 26.0/PTM_RATIO)
    };
    
    CGSize winSize      = [[CCDirector sharedDirector] winSize];
    b2Vec2 location     = b2Vec2(ccLocation.x/PTM_RATIO, ccLocation.y/PTM_RATIO);
    
    b2Body *body = [self createBodyForWorld:world
                                   position:location
                                   rotation:0
                                   vertices:verticies
                                vertexCount:verticiesCount
                                    density:5.0f
                                   friction:0.2f
                                restitution:0.2f];
    
    if (self = [super initWithFile:filename body:body]){
        
        // Get center vector
        CGPoint pointA  = ccLocation;
        CGPoint pointB  = ccp(winSize.width/2, winSize.height/2);
        CGPoint pointC  = ccpSub(pointB, pointA);
        pointC          = ccpNormalize(pointC);
        
        b2Vec2 force = b2Vec2((pointC.x/PTM_RATIO * _forceMultiplier),
                              (pointC.y/PTM_RATIO) * _forceMultiplier);
        
        self.body->ApplyLinearImpulse(force, self.body->GetPosition());
    }
    
    return self;
}

// Determine if object intersects with a CGPoint
- (BOOL)intersectsWithPoint:(CGPoint)ccLocation{
    b2Vec2 b2Location   = b2Vec2(ccLocation.x/PTM_RATIO, ccLocation.y/PTM_RATIO);
    b2Fixture *fixture = self.body->GetFixtureList();
    return (fixture->TestPoint(b2Location)) ? YES : NO;
}

@end
