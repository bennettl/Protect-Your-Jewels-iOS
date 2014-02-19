//
//  BLObject.h
//  Ninja
//
//  Created by Bennett Lee on 2/16/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Box2D/Box2D.h>
#import "cocos2d.h"

#define PTM_RATIO 32.0f
#define BOX_TAG 1
#define ENEMY_TAG 2
#define JEWEL_TAG 3

// Any body in game will inherit from BLObject

@interface BLObject : NSObject

@property (nonatomic, strong) CCSprite *sprite;
@property (nonatomic, assign) b2World *world;
@property (nonatomic, assign) b2Body *body;
@property (nonatomic, assign) b2BodyDef *bodyDef;
@property (nonatomic, assign) b2CircleShape *shapeDef;
@property (nonatomic, assign) b2FixtureDef *fixtureDef;
@property (nonatomic, assign) b2Fixture *fixture;
<<<<<<< HEAD:Gameplay/Ninja/BLObject.h
=======
@property (nonatomic, assign) b2MouseJoint *mouseJoint;

- (id)initWithWorld:(b2World *)world andLocation:(CGPoint)location; // called when touched
- (BOOL)intersectsWithPoint:(CGPoint)ccLocation;
>>>>>>> 2fbeaac94468c2db38de06f86de86071098cff68:Ninja/Ninja/BLEnemy.h

@end
