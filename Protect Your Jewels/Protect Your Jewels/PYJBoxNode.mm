//
//  PYJBoxNode.mm
//  GamePlay
//
//  Created by Bennett Lee on 2/21/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJBoxNode.h"
#import "GB2Engine.h"
#import "GB2Contact.h"
#import "PYJEnemySprite.h"

@interface PYJBoxNode(){
    int padding;
}
@end

@implementation PYJBoxNode

- (id)init{
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    if (self = [super initWithStaticBody:nil node:nil]){
        // Get height of enemy
        
        padding = 50;
        
        // Points
        CGPoint topLeft         = ccp(-padding, s.height + padding);
        CGPoint topRight        = ccp(s.width + padding, s.height + padding);
        CGPoint bottomLeft      = ccp(-padding, -padding);
        CGPoint bottomRight     = ccp(s.width + padding, -padding);
        
        // Edges
        
        // Bottom
        [self addEdgeFrom:b2Vec2FromCC(bottomLeft.x, bottomLeft.y)
                       to:b2Vec2FromCC(bottomRight.x, bottomRight.y)];
        // Left
        [self addEdgeFrom:b2Vec2FromCC(bottomLeft.x, bottomLeft.y)
                       to:b2Vec2FromCC(topLeft.x, topLeft.y)];
        // Top
        [self addEdgeFrom:b2Vec2FromCC(topLeft.x, topLeft.y)
                       to:b2Vec2FromCC(topRight.x, topRight.y)];
        // Right
        [self addEdgeFrom:b2Vec2FromCC(topRight.x, topRight.y)
                       to:b2Vec2FromCC(bottomRight.x, bottomRight.y)];
        
        // Set collision filter for box node
        for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()){
            b2Filter ef = f->GetFilterData();
            ef.categoryBits  = 0x0008;
            ef.maskBits      = 0x0004;
            ef.groupIndex    = 2;
            f->SetFilterData(ef);
        }
    }
    return self;
}

@end
