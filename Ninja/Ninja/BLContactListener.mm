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
    // We need to copy out the data because the b2Contact passed in
    // is reused.
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    _contacts.push_back(myContact);
}

void BLContactListener::EndContact(b2Contact* contact) {
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    std::vector<MyContact>::iterator pos;
    pos = std::find(_contacts.begin(), _contacts.end(), myContact);
    if (pos != _contacts.end()) {
        _contacts.erase(pos);
    }
}

void BLContactListener::PreSolve(b2Contact* contact,
                                 const b2Manifold* oldManifold) {
}

void BLContactListener::PostSolve(b2Contact* contact,
                                  const b2ContactImpulse* impulse) {
}