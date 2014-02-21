//
//  HelloWorldLayer.mm
//  Ninja
//
//  Created by Bennett Lee on 2/15/14.
//  Copyright Bennett Lee 2014. All rights reserved.
//


#import "BLGamePlayLayer.h"

#import "GBox2D/GB2Sprite.h"
#import "GBox2D/GB2ShapeCache.h"
#import "GBox2D/GB2DebugDrawLayer.h"
#import "GB2Jewel.h"
#import "BLEnemySprite.h"
//#import "BLJewelSprite.h"
//#import "BLContactListener.h"

#define BOX_TAG 1

#pragma mark - BLGamePlayLayer

@interface BLGamePlayLayer(){
    b2World *world;
    b2Body *_boxBody;
//    BLJewelSprite *_jewel;
//    BLContactListener *_contactListener;
    float _forceMultiplier;
    CCLabelTTF *_label;
    CCSpriteBatchNode *objectLayer;
    GB2Node *leftWall;
}

@property NSMutableArray *enemies;

@end

@implementation BLGamePlayLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BLGamePlayLayer *layer = [BLGamePlayLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


#pragma mark initlization

-(id) init{
	if ((self=[super init])) {
        CGSize winSize      = [[CCDirector sharedDirector] winSize];
//        _world = [GB2Engine sharedInstance].world;
        // Load sprite atlases
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Sprites.plist"];
        
        // Load physic shapes into shape cache
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"Shapes.plist"];
        
        objectLayer = [CCSpriteBatchNode batchNodeWithFile:@"Sprites.pvr.ccz" capacity:150];
        [self addChild:objectLayer z:-10];
        
        GB2DebugDrawLayer *debugLayer = [[GB2DebugDrawLayer alloc] init];
       [self addChild:debugLayer z:-3];
        
        GB2Jewel *j = [GB2Jewel jewelSprite];
        [j setPhysicsPosition:b2Vec2(winSize.width/2/PTM_RATIO, winSize.height/2/PTM_RATIO)];

        
        [objectLayer addChild:j.ccNode];
        
        // add walls to the left
        leftWall = [[GB2Node alloc] initWithStaticBody:nil node:nil];
        [leftWall addEdgeFrom:b2Vec2FromCC(0, 0) to:b2Vec2FromCC(winSize.width, 0)];
        
//        // Initializations
//        _forceMultiplier    = 40.0f;
//        self.currentScore     = 0;
        self.enemies        = [[NSMutableArray alloc] init];
//
//        [self initScoreLabel];
//        [self initWorld];
//        [self initJewel];
      //  [self initBoundingBox];
//
//        // ContactListener is used for collision Detection
//        _contactListener = new BLContactListener(self);
//        _world->SetContactListener(_contactListener);
//        
        // Touching
        self.touchEnabled = YES;
//
//        // Debug Drawing
//        m_debugDraw = new GLESDebugDraw( PTM_RATIO );
//       _world->SetDebugDraw(m_debugDraw);
//        uint32 flags = 0;
//        flags += b2Draw::e_shapeBit;
//        //		flags += b2Draw::e_jointBit;
//        //		flags += b2Draw::e_aabbBit;
//        //		flags += b2Draw::e_pairBit;
//        //		flags += b2Draw::e_centerOfMassBit;
//        m_debugDraw->SetFlags(flags);
//        
//        // Schedule
//        [self scheduleUpdate];
        
        
    }
	return self;
}

// Use for debug drawing
//-(void) draw{
//	[super draw];
//	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
//	kmGLPushMatrix();
//	_world->DrawDebugData();
//	kmGLPopMatrix();
//}

// Creates label score in lower right corner
- (void)initScoreLabel{
    CGSize winSize      = [[CCDirector sharedDirector] winSize];
    _label              = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i", self.currentScore] fontName:@"Marker Felt" fontSize:20];
    _label.position = ccp(winSize.width - _label.contentSize.width/2 - 40,
                         25);
    [self addChild:_label];
    
}

         
// Creates jewel
 -(void)initJewel{
//    _jewel = [[BLJewelSprite alloc] initWithWorld:_world];
//     [self addChild:_jewel z:1];
//     [_jewel activateCollisions];
}

// Creates the bonding box
- (void)initBoundingBox{
    CGSize s = [[CCDirector sharedDirector] winSize];
    b2BodyDef boxBodyDef;
    _boxBody = world->CreateBody(&boxBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape boxShape;
    
	// bottom
	
	boxShape.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	_boxBody->CreateFixture(&boxShape,0);
	
	// top
	boxShape.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	_boxBody->CreateFixture(&boxShape,0);
	
	// left
	boxShape.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	_boxBody->CreateFixture(&boxShape,0);
	
	// right
	boxShape.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	_boxBody->CreateFixture(&boxShape,0);

//    CGSize winSize = [[CCDirector sharedDirector] winSize];
//    b2Vec2 b2WinSize = b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO);
//    b2Vec2 b2Padding = b2Vec2(52/PTM_RATIO, 52/PTM_RATIO); // padding should be size of enemy
//    
//    // Create bounding box
//    b2BodyDef boxBodyDef;
//    boxBodyDef.position.Set(-b2Padding.x, -b2Padding.y);
//    _boxBody = _world->CreateBody(&boxBodyDef);
//    
//    b2EdgeShape boxShape;
//    b2FixtureDef boxShapeDef;
//    boxShapeDef.shape = &boxShape;
//
//    // Four points
//    b2Vec2 bottomleft(-b2Padding.x, -b2Padding.y);
//    b2Vec2 bottomRight(b2WinSize.x + b2Padding.x, - b2Padding.y);
//    b2Vec2 topLeft(-b2Padding.x, b2WinSize.y +  b2Padding.y);
//    b2Vec2 topRight(b2WinSize.x + b2Padding.x, b2WinSize.y + b2Padding.y);
//    
//    // Bottom Edge
//    boxShape.Set(bottomleft, bottomRight);
//    _boxBody->CreateFixture(&boxShapeDef);
//    
//    // Left Edge
//    boxShape.Set(bottomleft, topLeft);
//    _boxBody->CreateFixture(&boxShapeDef);
//    
//    // Top Edge
//    boxShape.Set(topLeft, topRight);
//    _boxBody->CreateFixture(&boxShapeDef);
//    
//    // Right Edge
//    boxShape.Set(topRight, bottomRight);
//    _boxBody->CreateFixture(&boxShapeDef);
}

// Initializes enemy at location
- (void)spawnEnemyAtLocation:(CGPoint)location{
    BLEnemySprite *es = [BLEnemySprite enemySprite];
    [es setPhysicsPosition:b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO)];
    [self addChild:es.ccNode];
    
    [self.enemies addObject:es];
//    [es activateCollisions];
}


#pragma mark Touch


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // Convert touch -> ccLocation -> b2Location
    UITouch *touch      = (UITouch *)[touches anyObject];
    CGPoint ccLocation  = [[CCDirector sharedDirector] convertTouchToGL:touch];
   
    // If a mouse joint is created, that means user touched an enemy, do not create new enemy!
    if ([self createMouseJointWithTouch:touch]){
        return;
    }
    NSLog(@"nope");
    [self spawnEnemyAtLocation:ccLocation];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch      = (UITouch *)[touches anyObject];
 [self updateMouseJointWithTouch:touch];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
 [self removeMouseJoint];
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
 [self removeMouseJoint];
}

#pragma mark Mouse Joints

- (BOOL)createMouseJointWithTouch:(UITouch *)touch{
    CGPoint ccLocation  = [[CCDirector sharedDirector] convertTouchToGL:touch];
    b2Vec2 b2Location   = b2Vec2(ccLocation.x/PTM_RATIO, ccLocation.y/PTM_RATIO);
    NSLog(@"enemy count %i", self.enemies.count);

    
    // Loop through all enemies
    for (BLEnemySprite *be in self.enemies) {
        // If intersects with point, create mouse joint
        if ([be intersectsWithPoint:ccLocation]){
            [be createMouseJointWithGroundBody:leftWall.body target:b2Location maxForce:1000];
//            b2MouseJointDef md;
//            md.bodyA            = leftWall.body;
//            md.bodyB            = be.body; //bodyB is body you want to move
//            md.target           = b2Location; // point you want to move to
//            md.collideConnected = true;
//            md.maxForce = 3000.0f * be.body->GetMass(); // force you have when moving body
//            be.mouseJoint = (b2MouseJoint *)()[GB2Engine sharedInstance].world)->CreateJoint(&md);
//            be.body->SetAwake(true);
            return YES;
        }
    }
    return NO;
}

- (void)updateMouseJointWithTouch:(UITouch *)touch{
    // Convert touch -> ccLocation -> b2Location
    CGPoint ccLocation  = [[CCDirector sharedDirector] convertTouchToGL:touch];
    b2Vec2 b2Location   = b2Vec2(ccLocation.x/PTM_RATIO, ccLocation.y/PTM_RATIO);
    
    // Loop through all enemies
    for (BLEnemySprite *be in self.enemies) {
        // If mousejoint exists, update it
        if (be.mouseJoint){
            be.mouseJoint->SetTarget(b2Location);
        }
    }
}

- (void)removeMouseJoint{
    // Loop through all enemies
    for (BLEnemySprite *be in self.enemies) {
        // If mousejoint exists, delete it
        if (be.mouseJoint){
            [GB2Engine sharedInstance].world->DestroyJoint(be.mouseJoint);
            be.mouseJoint = NULL;
        }
    }
}


#pragma mark ContactListener CallBack

- (void)beginContact:(b2Contact *)contact{
    b2Fixture *fixtureA = contact->GetFixtureA();
    b2Fixture *fixtureB = contact->GetFixtureB();
    b2Body *bodyA       = fixtureA->GetBody();
    b2Body *bodyB       = fixtureB->GetBody();
    CCSprite *spriteA   = (CCSprite *)bodyA->GetUserData();
    CCSprite *spriteB   = (CCSprite *)bodyB->GetUserData();
    
//    if (spriteA == NULL && spriteB != NULL){
//        if (spriteB.tag == ENEMY_TAG){
//            self.currentScore++;
//            // remove ball
//        }
//    } else if (spriteA != NULL && spriteB == NULL){
//        if (spriteA.tag == ENEMY_TAG){
//            self.currentScore++;
//            // remove ball
//        }
//    }
//    [_label setString:[NSString stringWithFormat:@"Score: %i", self.currentScore]];
}

- (void)endContact:(b2Contact*)contact{
    
}

-(void) dealloc{
//	delete _world;
//	_world = NULL;
	
    
//	delete m_debugDraw;
//	m_debugDraw = NULL;
	
	[super dealloc];
}	

@end


















