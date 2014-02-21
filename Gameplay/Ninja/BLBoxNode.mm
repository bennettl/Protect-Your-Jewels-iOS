//
//  BLBoxNode.m
//  GamePlay
//
//  Created by Bennett Lee on 2/21/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLBoxNode.h"
#import "GB2Engine.h"
#import "GB2Contact.h"

@implementation BLBoxNode

- (id)init{
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    if (self = [super initWithStaticBody:nil node:nil]){
        // Bottom
        [self addEdgeFrom:b2Vec2FromCC(0, 0) to:b2Vec2FromCC(s.width, 0)];
        // Left
        [self addEdgeFrom:b2Vec2FromCC(0, 0) to:b2Vec2FromCC(0, s.height)];
        // Top
        [self addEdgeFrom:b2Vec2FromCC(s.width, s.height) to:b2Vec2FromCC(0, s.height)];
        // Right
        [self addEdgeFrom:b2Vec2FromCC(s.width, s.height) to:b2Vec2FromCC(s.width, 0)];
       
        for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()) {
            f->SetSensor(true);
        }
      
    }
    return self;
}


- (void)beginContactWithBLEnemySprite:(GB2Contact *)contact{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}
@end
