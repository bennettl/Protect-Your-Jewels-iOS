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
//    BLJewelSprite *_jewel;
//    BLContactListener *_contactListener;
    float _forceMultiplier;
    CCLabelTTF *_label;
    CCSpriteBatchNode *objectLayer;
    GB2Node *boxNode;
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

        // Load sprite atlases
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Sprites.plist"];
        
        // Load physic shapes into shape cache
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"Shapes.plist"];
        
        objectLayer = [CCSpriteBatchNode batchNodeWithFile:@"Sprites.pvr.ccz" capacity:150];
        [self addChild:objectLayer z:-10];
        
        // add walls to the left
      
//        // Initializations
//        _forceMultiplier    = 40.0f;
//        self.currentScore     = 0;
        self.enemies        = [[NSMutableArray alloc] init];
//
//        [self initScoreLabel];
//        [self initWorld];
          [self initJewel];
          [self initBoundingBox];
        [self initDebug];
//
//        // ContactListener is used for collision Detection
//        _contactListener = new BLContactListener(self);
//        _world->SetContactListener(_contactListener);
//        
        // Touching
        self.touchEnabled = YES;
        
    }
	return self;
}

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
     CGSize s = [[CCDirector sharedDirector] winSize];
     GB2Jewel *j = [GB2Jewel jewelSprite];
     [j setPhysicsPosition:b2Vec2(s.width/2/PTM_RATIO, s.height/2/PTM_RATIO)];
     [objectLayer addChild:j.ccNode];
}

// Creates the bonding box
- (void)initBoundingBox{
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    boxNode = [[GB2Node alloc] initWithStaticBody:nil node:nil];
    // Bottom
    [boxNode addEdgeFrom:b2Vec2FromCC(0, 0) to:b2Vec2FromCC(s.width, 0)];
    // Left
    [boxNode addEdgeFrom:b2Vec2FromCC(0, 0) to:b2Vec2FromCC(0, s.height)];
    // Top
    [boxNode addEdgeFrom:b2Vec2FromCC(s.width, s.height) to:b2Vec2FromCC(0, s.height)];
    // Right
    [boxNode addEdgeFrom:b2Vec2FromCC(s.width, s.height) to:b2Vec2FromCC(s.width, 0)];
}

// Add debug layer
- (void)initDebug{
    GB2DebugDrawLayer *debugLayer = [[GB2DebugDrawLayer alloc] init];
    [self addChild:debugLayer z:-3];
}

// Initializes enemy at location
- (void)spawnEnemyAtLocation:(CGPoint)location{
    BLEnemySprite *es = [BLEnemySprite enemySprite];
    [es setPhysicsPosition:b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO)];
    [self addChild:es.ccNode];
    [self.enemies addObject:es];
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
    
    // Loop through all enemies
    for (BLEnemySprite *be in self.enemies) {
        // If intersects with point, create mouse joint
        if ([be intersectsWithPoint:ccLocation]){
            [be createMouseJointWithGroundBody:boxNode.body target:b2Location maxForce:1000];
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


















