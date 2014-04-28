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

#import "GB2Sprite.h"
#import "GB2Engine.h"
#import "GB2ShapeCache.h"

@implementation GB2Sprite

@synthesize mouseJoint;

- (void)createMouseJointWithGroundBody:(b2Body*)groundBody
                                target:(b2Vec2)target
                              maxForce:(float32)maxForce {
    
    b2MouseJointDef mouseJointDef;
    
    mouseJointDef.bodyA = groundBody;  // The groundBody passed from the call of this method.
    mouseJointDef.bodyB = self.body;  // The body you're moving, ie this one.
    mouseJointDef.target = target; // The destination you're moving bodyB to
    mouseJointDef.collideConnected = true; // ensures whatever you hit, collides normally.
    mouseJointDef.maxForce = maxForce * self.body->GetMass();  // about 1000.0 is good
    
    world = [[GB2Engine sharedInstance] world];

    self.mouseJoint = (b2MouseJoint*)world->CreateJoint(&mouseJointDef);
    
    self.body->SetAwake(true);
}

-(id) initWithDynamicBody:(NSString *)shape spriteFrameName:(NSString*)spriteName
{
    return [super initWithDynamicBody:shape node:[CCSprite spriteWithSpriteFrameName:spriteName]];
}

-(id) initWithStaticBody:(NSString *)shape spriteFrameName:(NSString*)spriteName
{
    return [super initWithStaticBody:shape node:[CCSprite spriteWithSpriteFrameName:spriteName]];
}

-(id) initWithKinematicBody:(NSString *)shape spriteFrameName:(NSString*)spriteName
{
    return [super initWithKinematicBody:shape node:[CCSprite spriteWithSpriteFrameName:spriteName]];
}

+(id) spriteWithDynamicBody:(NSString *)shape spriteFrameName:(NSString*)spriteName
{
    return [[[GB2Sprite alloc] initWithDynamicBody:shape spriteFrameName:spriteName] autorelease];    
}

+(id) spriteWithStaticBody:(NSString *)shape spriteFrameName:(NSString*)spriteName
{
    return [[[GB2Sprite alloc] initWithStaticBody:shape spriteFrameName:spriteName] autorelease];        
}

+(id) spriteWithKinematicBody:(NSString *)shape spriteFrameName:(NSString*)spriteName
{
    return [[[GB2Sprite alloc] initWithKinematicBody:shape spriteFrameName:spriteName] autorelease];        
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

-(void)setDisplayFrame:(CCSpriteFrame *)newFrame
{
    [(CCSprite*)self.ccNode setDisplayFrame:newFrame];
}

-(void) setDisplayFrameNamed:(NSString*)name
{
    [(CCSprite*)self.ccNode setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
}



- (id)initWithWorldPRPolygon:(b2World *)world andFixtureData:(NSDictionary *)fixtureData{
    int verticiesCount  = 6;
    CGSize winSize      = [[CCDirector sharedDirector] winSize];
    b2Vec2 center       = b2Vec2(winSize.width/2, winSize.height/2);
    
    b2FixtureDef basicData;
    
    basicData.filter.categoryBits = [[fixtureData objectForKey:@"filter_categoryBits"] intValue];
    basicData.filter.maskBits = [[fixtureData objectForKey:@"filter_maskBits"] intValue];
    basicData.filter.groupIndex = [[fixtureData objectForKey:@"filter_groupIndex"] intValue];
    basicData.friction = [[fixtureData objectForKey:@"friction"] floatValue];
    basicData.density = [[fixtureData objectForKey:@"density"] floatValue];
    basicData.restitution = [[fixtureData objectForKey:@"restitution"] floatValue];
    basicData.isSensor = [[fixtureData objectForKey:@"isSensor"] boolValue];
    
    self =  [[[GB2Sprite alloc] initWithStaticBody:@"test" spriteFrameName:@"test"] autorelease];
    
    return self;
}


@end
