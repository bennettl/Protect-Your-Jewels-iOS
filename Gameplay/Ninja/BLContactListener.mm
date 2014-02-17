//
//  BLContactListener.m
//  Box2DBreakOut2
//
//  Created by Bennett Lee on 2/15/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "BLContactListener.h"

BLContactListener::BLContactListener() : _contacts() {
}

BLContactListener::~BLContactListener() {
}

void BLContactListener::BeginContact(b2Contact* contact) {
    [_layer beginContact:contact];
}

void BLContactListener::EndContact(b2Contact* contact) {
    [_layer endContact:contact];

}

void BLContactListener::PreSolve(b2Contact* contact,
                                 const b2Manifold* oldManifold) {
}

void BLContactListener::PostSolve(b2Contact* contact,
                                  const b2ContactImpulse* impulse) {
}