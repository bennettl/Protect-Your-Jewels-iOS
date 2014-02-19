//
//  BLNinja.h
//  Ninja
//
//  Created by Bennett Lee on 2/15/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Box2D/Box2D.h>
#import "cocos2d.h"


@interface BLEnemy : NSObject

@property (nonatomic, strong) CCSprite *sprite;
@property (nonatomic, assign) b2World *world;
@property (nonatomic, assign) b2Body *body;
@property (nonatomic, assign) b2BodyDef *bodyDef;
@property (nonatomic, assign) b2CircleShape *shapeDef;
@property (nonatomic, assign) b2FixtureDef *fixtureDef;
@property (nonatomic, assign) b2Fixture *fixture;
@property (nonatomic, assign) b2MouseJoint *mouseJoint;

- (id)initWithWorld:(b2World *)world andLocation:(CGPoint)location;
- (BOOL)intersectsWithPoint:(CGPoint)ccLocation;

@end
