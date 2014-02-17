//
//  BLNinja.h
//  Ninja
//
//  Created by Bennett Lee on 2/15/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLObject.h"

@interface BLEnemy : BLObject

@property (nonatomic, assign) b2MouseJoint *mouseJoint;

- (id)initWithWorld:(b2World *)world andLocation:(CGPoint)location;
- (BOOL)intersectsWithPoint:(CGPoint)ccLocation;

@end
