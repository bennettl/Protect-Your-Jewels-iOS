/*
 MIT License
 
 Copyright (c) 2010 Andreas Loew / www.code-and-web.de
 
 For more information about htis module visit
 http://www.PhysicsEditor.de
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "GB2Node.h"
#import "GB2Engine.h"
#import "GB2ShapeCache.h"

@implementation GB2Node

@synthesize ccNode;
@synthesize deleteLater;

-(id) initWithShape:(NSString *)shape bodyType:(b2BodyType)bodyType node:(CCNode*)node;
{
    self = [super init];
    
	if( self ) 
    {
        world = [[GB2Engine sharedInstance] world];
        
        b2BodyDef bodyDef;
        bodyDef.type = bodyType;
        bodyDef.position.Set(0,0);
        bodyDef.angle = 0;
        self.body = world->CreateBody(&bodyDef);
        
        // set user data and retain self
        self.body->SetUserData([self retain]);
        
        // set the node
        self.ccNode = node;
        
        // set shape
        if(shape)
        {
            [self setBodyShape:shape];            
        }
    }
    
    return self;    
}

-(void) addEdgeFrom:(b2Vec2)start to:(b2Vec2)end
{
    b2EdgeShape edgeShape;
    edgeShape.Set(start, end);
    _body->CreateFixture(&edgeShape,0);
}

-(id) init
{
    NSAssert(0, @"GB2Node must not be called with init");
    return nil;
}

-(id) initWithNode:(CCNode*)node;
{
    return [self initWithShape:0 bodyType:b2_dynamicBody node:node];
}

-(id) initWithDynamicBody:(NSString *)shape node:(CCNode*)node;
{
    return [self initWithShape:shape bodyType:b2_dynamicBody node:node];
}

-(id) initWithStaticBody:(NSString *)shape node:(CCNode*)node;
{
    return [self initWithShape:shape bodyType:b2_staticBody node:node];
}

-(id) initWithKinematicBody:(NSString *)shape node:(CCNode*)node;
{
    return [self initWithShape:shape bodyType:b2_kinematicBody node:node];
}

- (NSString*) description
{
    b2Vec2 pos = [self physicsPosition];
    b2Vec2 vel = [self linearVelocity];
	return [NSString stringWithFormat:@"<%@ = %8@ | pos:(%f,%f) active=%d awake=%d vel=(%f,%f)>", 
            [self class], 
            self, 
            pos.x, pos.y, 
            [self active], 
            [self awake],
            vel.x, vel.y
            ];
}

-(void*) shapeCacheFixtureUserdataForValue:(int)value
{
    return 0;
}

-(void) destroyBody
{
    if(_body)
    {
        // destroy the body and release the instance count
        // which was part of the body userdata
        world->DestroyBody(_body);
        _body=0;
        
        // release self - 
        [self release];
    }
}

-(void) deleteNow
{    
    // remove object from cocos2d parent node
    [ccNode removeFromParentAndCleanup:YES];
    self.ccNode = nil;

    // delete the body
    [self destroyBody];
}

-(CCAction*) runAction: (CCAction*) action
{
    return [ccNode runAction:action];
}

-(void) stopAllActions
{
    [ccNode stopAllActions];    
}

-(void) stopAction: (CCAction*) action
{
    [ccNode stopAction:action];
}


-(void) setParent:(CCNode*)parent
{
    [parent addChild:ccNode];
}

-(void) setParent:(CCNode*)parent z:(float)z
{
    [parent addChild:ccNode z:z];    
}

-(float) widthInM
{
    return [ccNode contentSize].width / PTM_RATIO;
}

-(void) setLinearDamping:(float)linearDamping
{
    _body->SetLinearDamping(linearDamping);
}

-(void) setAngularDamping:(float)angularDamping
{
    _body->SetAngularDamping(angularDamping);
}

-(void) setBodyShape:(NSString*)shapeName
{
    b2Fixture *f;
    while((f = _body->GetFixtureList()))
    {
        _body->DestroyFixture(f);
    }
    
    if(shapeName)
    {
        GB2ShapeCache *shapeCache = [GB2ShapeCache sharedShapeCache];
        [shapeCache addFixturesToBody:_body forShapeName:shapeName];
        ccNode.anchorPoint = [shapeCache anchorPointForShape:shapeName];        
    }
}

-(void) setScale:(float)scale
{
    // currently only graphics
    ccNode.scale = scale;
}


-(b2Fixture*) addFixture:(b2FixtureDef*)fixtureDef
{
    return _body->CreateFixture(fixtureDef);
}

-(void) setBody:(NSString*)shapeName type:(b2BodyType)bodyType position:(b2Vec2)pos
{
    assert(_body);
    [self setBodyShape:shapeName];
    [self setBodyType:bodyType];
    [self setPhysicsPosition:pos];
}

-(void) clrCollisionMaskBits:(uint16)bits forId:(NSString*)fixtureId
{
    b2Fixture *f = _body->GetFixtureList();
    while(f)
    {
        if(!fixtureId  || ([fixtureId isEqualToString:(NSString*)f->GetUserData()]))
        {
            b2Filter filter = f->GetFilterData();
            filter.maskBits &= ~bits;        
            f->SetFilterData(filter);
        }
        f = f->GetNext();            
    }  
}

-(void) addCollisionMaskBits:(uint16)bits forId:(NSString*)fixtureId
{
    b2Fixture *f = _body->GetFixtureList();
    while(f)
    {
        if(!fixtureId || ([fixtureId isEqualToString:(NSString*)f->GetUserData()]))
        {
            b2Filter filter = f->GetFilterData();
            filter.maskBits |= bits;        
            f->SetFilterData(filter);
        }
        f = f->GetNext();            
    } 
}

-(void) setCollisionMaskBits:(uint16)bits forId:(NSString*)fixtureId
{
    b2Fixture *f = _body->GetFixtureList();
    while(f)
    {
        if(!fixtureId || ([fixtureId isEqualToString:(NSString*)f->GetUserData()]))
        {
            b2Filter filter = f->GetFilterData();
            filter.maskBits = bits;        
            f->SetFilterData(filter);
        }
        f = f->GetNext();            
    } 
}

-(void) setCollisionMaskBits:(uint16)bits
{
    [self setCollisionMaskBits:bits forId:nil];
}

-(void) clrCollisionMaskBits:(uint16)bits
{
    [self clrCollisionMaskBits:bits forId:nil];
}

-(void) addCollisionMaskBits:(uint16)bits
{
    [self addCollisionMaskBits:bits forId:nil];
}

-(void) addCollisionCategoryBits:(uint16)bits
{
    [self addCollisionCategoryBits:bits forId:nil];
}

-(void) clrCollisionCategoryBits:(uint16)bits
{
    [self clrCollisionCategoryBits:bits forId:nil];
}

-(void) setCollisionCategoryBits:(uint16)bits
{
    [self setCollisionCategoryBits:bits forId:nil];
}

-(void) addCollisionCategoryBits:(uint16)bits forId:(NSString*)fixtureId
{
    b2Fixture *f = _body->GetFixtureList();
    while(f)
    {
        if(!fixtureId || ([fixtureId isEqualToString:(NSString*)f->GetUserData()]))
        {
            b2Filter filter = f->GetFilterData();
            filter.categoryBits |= bits;        
            f->SetFilterData(filter);
        }
        f = f->GetNext();
    }        
}

-(void) clrCollisionCategoryBits:(uint16)bits forId:(NSString*)fixtureId
{
    b2Fixture *f = _body->GetFixtureList();
    while(f)
    {
        if(!fixtureId || ([fixtureId isEqualToString:(NSString*)f->GetUserData()]))
        {
            b2Filter filter = f->GetFilterData();
            filter.categoryBits &= ~bits;        
            f->SetFilterData(filter);
        }
        f = f->GetNext();
    }        
}

-(void) setCollisionCategoryBits:(uint16)bits forId:(NSString*)fixtureId
{
    b2Fixture *f = _body->GetFixtureList();
    while(f)
    {
        if(!fixtureId || ([fixtureId isEqualToString:(NSString*)f->GetUserData()]))
        {
            b2Filter filter = f->GetFilterData();
            filter.categoryBits = bits;        
            f->SetFilterData(filter);
        }
        f = f->GetNext();
    }        
}


-(void) setKinematicBody:(NSString*)shapeName position:(b2Vec2)pos
{
    [self setBody:shapeName type:b2_kinematicBody position:pos];
}

-(void) setDynamicBody:(NSString*)shapeName position:(b2Vec2)pos
{
    [self setBody:shapeName type:b2_dynamicBody position:pos];
}

-(void) setStaticBody:(NSString*)shapeName position:(b2Vec2)pos
{
    [self setBody:shapeName type:b2_staticBody position:pos];    
}


-(void)updateCCFromPhysics
{
    b2Vec2 position = _body->GetPosition();
    ccNode.position = CGPointMake(PTM_RATIO*position.x, PTM_RATIO*position.y);
    ccNode.rotation = -1 * CC_RADIANS_TO_DEGREES(_body->GetAngle());
}

-(void) setFixedRotation:(bool)fixedRotation
{
    assert(_body);
    _body->SetFixedRotation(fixedRotation);
}

-(void) setLinearVelocity:(b2Vec2)velocity
{
    assert(_body);
    _body->SetLinearVelocity(velocity);
}

-(void) applyLinearImpulse:(b2Vec2)impulse point:(b2Vec2)point 
{
    assert(_body);
    _body->ApplyLinearImpulse(impulse, point);
}

-(b2Vec2) physicsPosition
{
    assert(_body);
    return _body->GetPosition();
}

-(b2Vec2) worldCenter
{
    assert(_body);
    return _body->GetWorldCenter();
}
-(float) mass
{
    assert(_body);
    return _body->GetMass();
}

-(void) setBodyType:(b2BodyType)bodyType;
{
    assert(_body);
    _body->SetType(bodyType);
}

-(BOOL) isAwake
{
    return _body->IsAwake();
}

-(void) applyForce:(b2Vec2)force point:(b2Vec2)point
{
    assert(_body);
    _body->ApplyForce(force, point);
}

-(float) angle
{
    assert(_body);
    return _body->GetAngle();
}

-(void) setTransform:(b2Vec2)pos angle:(float)angle
{
    assert(_body);
    _body->SetTransform(pos, angle);
}

-(void) setAngle:(float)angle
{
    _body->SetTransform(_body->GetWorldCenter(), angle);
}

-(void) setPhysicsPosition:(b2Vec2)pos
{
    assert(_body);
    ccNode.position = CGPointFromb2Vec2(pos);
    _body->SetTransform(pos, _body->GetAngle());
}

-(void)setCcPosition:(CGPoint)pos
{
    assert(_body);
    ccNode.position = pos;
    _body->SetTransform(b2Vec2FromCGPoint(pos), _body->GetAngle());
}

-(CGPoint)ccPosition
{
    return ccNode.position;
}

-(bool) active
{
    return _body->IsActive();
}

-(void) setActive:(bool)isActive
{
    _body->SetActive(isActive);    
}

-(bool) awake
{
    return _body->IsAwake();
}

-(b2Vec2) linearVelocity
{
    return _body->GetLinearVelocity();
}

-(void*)shapeCacheFixtureUserdataForValue
{
    return 0;
}

-(void) setBullet:(bool)bulletFlag
{
    _body->SetBullet(bulletFlag);
}

-(b2Fixture*) createFixture:(const b2FixtureDef*)fixtureDef
{
    return _body->CreateFixture(fixtureDef);
}

-(int) objectTag
{
    return objectTag;
}

-(void) setObjectTag:(int)aTag
{
    objectTag = aTag;
}

-(void) setAngularVelocity:(float32)v
{
    _body->SetAngularVelocity(v);
}

-(void)setVisible:(BOOL)isVisible
{
    ccNode.visible = isVisible;
}

@end
