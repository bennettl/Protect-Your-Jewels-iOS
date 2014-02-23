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
#import "BLEnemySprite.h"

@interface BLBoxNode(){
    int padding;
}
@end

@implementation BLBoxNode

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
       
    }
    return self;
}

@end
