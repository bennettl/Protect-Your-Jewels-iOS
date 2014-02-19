//
//  PolygonSprite.h
//  FruitNinja
//
//  Created by Bennett Lee on 2/17/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PRFilledPolygon.h"
#import "Box2D.h"

#define PTM_RATIO 32.0f
#define BOX_TAG 1
#define ENEMY_TAG 2
#define JEWEL_TAG 3


@interface BLPolygonSprite : PRFilledPolygon {
    
}


@property(nonatomic,assign) b2Body *body;
@property(nonatomic,readwrite)b2Vec2 centroid;
@property(nonatomic,assign)b2MouseJoint *mouseJoint;

+(id)spriteWithFile:(NSString*)filename
               body:(b2Body*)body;

+(id)spriteWithTexture:(CCTexture2D*)texture
                  body:(b2Body*)body;

//+(id)spriteWithWorld:(b2World*)world;

-(id)initWithFile:(NSString*)filename
             body:(b2Body*)body;

-(id)initWithTexture:(CCTexture2D*)texture
                body:(b2Body*)body;

-(id)initWithWorld:(b2World*)world;

-(b2Body*)createBodyForWorld:(b2World*)world
                    position:(b2Vec2)position
                    rotation:(float)rotation
                    vertices:(b2Vec2*)vertices
                 vertexCount:(int32)count
                     density:(float)density
                    friction:(float)friction
                 restitution:(float)restitution;

-(void)activateCollisions;
-(void)deactivateCollisions;

@end























