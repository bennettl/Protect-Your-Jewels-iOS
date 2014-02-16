//
//  MyContactListener.h
//  Box2DBreakOut2
//
//  Created by Bennett Lee on 2/15/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "Box2D.h"
#import <vector>
#import <algorithm>

struct MyContact {
    b2Fixture *fixtureA;
    b2Fixture *fixtureB;
    bool operator==(const MyContact& other) const
    {
        return (fixtureA == other.fixtureA) && (fixtureB == other.fixtureB);
    }
};

class BLContactListener : public b2ContactListener {
    
public:
    std::vector<MyContact>_contacts;
    
    BLContactListener();
    ~BLContactListener();
    
    virtual void BeginContact(b2Contact* contact);
    virtual void EndContact(b2Contact* contact);
    virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
    
};