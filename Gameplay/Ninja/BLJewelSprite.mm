//
//  BLJewelPolygon.m
//  GamePlay
//
//  Created by Bennett Lee on 2/18/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLJewelSprite.h"


@implementation BLJewelSprite

- (id)initWithWorld:(b2World *)world{
    NSString *filename  = @"jewel.png";
    int verticiesCount  = 5;
    b2Vec2 verticies[]  = {
                            b2Vec2(32.0/PTM_RATIO, 9.0/PTM_RATIO),
                            b2Vec2(64.0/PTM_RATIO, 39.0/PTM_RATIO),
                            b2Vec2(51.0/PTM_RATIO, 55.0/PTM_RATIO),
                            b2Vec2(13.0/PTM_RATIO, 55.0/PTM_RATIO),
                            b2Vec2(0.0/PTM_RATIO, 39.0/PTM_RATIO)
                          };
    CGSize winSize      = [[CCDirector sharedDirector] winSize];
    b2Vec2 center       = b2Vec2(winSize.width/2/PTM_RATIO,
                                 winSize.height/2/PTM_RATIO);
    
    b2Body *body        = [self createBodyForWorld:world
                                   position:center
                                   rotation:0
                                   vertices:verticies
                                vertexCount:verticiesCount
                                    density:5.0f
                                   friction:0.2f
                                restitution:0.2f];
    body->SetType(b2_staticBody);
    
    
    if (self = [super initWithFile:filename body:body]){
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
