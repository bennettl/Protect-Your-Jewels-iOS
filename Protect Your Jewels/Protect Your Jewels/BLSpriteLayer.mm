//
//  HelloWorldLayer.mm
//  Ninja
//
//  Created by Bennett Lee on 2/15/14.
//  Copyright Bennett Lee 2014. All rights reserved.
//


#import "BLSpriteLayer.h"
#import "GBox2D/GB2Sprite.h"
#import "GBox2D/GB2ShapeCache.h"
#import "GBox2D/GB2DebugDrawLayer.h"
#import "BLJewelSprite.h"
#import "BLEnemySprite.h"
#import "BQTouchCircle.h"
#import "BLBoxNode.h"
#import "BLBackgroundLayer.h"


#pragma mark - BLSpriteLayer

@interface BLSpriteLayer(){
    b2World *world;
//    BLJewelSprite *_jewel;
    float enemyLaunchForce;
    CCLabelTTF *_label;
    CCSpriteBatchNode *objectLayer;
    GB2Node *boxNode;
    int waveNum;
    BQTouchCircle *touchCircle;
}

@property NSMutableArray *enemies;

@end

@implementation BLSpriteLayer

#pragma mark initlization

-(id) init{
	if ((self=[super init])) {

        // Load sprite atlases
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Sprites.plist"];
        
        // Load physic shapes into shape cache
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"Shapes.plist"];
        
        // Add object layer
        objectLayer = [CCSpriteBatchNode batchNodeWithFile:@"Sprites.pvr.ccz" capacity:150];
        [self addChild:objectLayer z:10];
        
        // Initializations
        enemyLaunchForce    = 700.0f;
        self.enemies        = [[NSMutableArray alloc] init];
        [self initJewel];
        [self initDebug];

        // Create bounding box
        boxNode = [[BLBoxNode alloc] init];
        
        // Touching
        self.touchEnabled = YES;
        
        // Start Waves
        waveNum = 0;
        int timeBetweenWaves = 10;
        [self schedule:@selector(startWave) interval:timeBetweenWaves];
    }
	return self;
}

// Creates jewel
 -(void)initJewel{
     CGSize s = [[CCDirector sharedDirector] winSize];
     BLJewelSprite *j = [BLJewelSprite jewelSprite];
     [j setPhysicsPosition:b2Vec2FromCC(s.width/2, s.height/2)];
     [objectLayer addChild:j.ccNode z:10];
}

// Create touch sprite at location
-(void)initTouchAtLocation:(CGPoint)location{
    if (touchCircle == nil){
        touchCircle = [[BQTouchCircle alloc] initWithSpriteLayer:self];
        [touchCircle setPhysicsPosition:b2Vec2FromCC(location.x, location.y)];
    }
}

// Add debug layer
- (void)initDebug{
    GB2DebugDrawLayer *debugLayer = [[GB2DebugDrawLayer alloc] init];
    [self addChild:debugLayer z:30];
}

// Initializes enemy at location
- (void)spawnEnemyAtLocation:(CGPoint)location{
    CGSize s = [[CCDirector sharedDirector] winSize];
    location = [self randomDirection];
    BLEnemySprite *es = [[BLEnemySprite alloc] initWithSpriteLayer:self];
    [es setPhysicsPosition:b2Vec2FromCC(location.x, location.y)];
    [self addChild:es.ccNode z:10];
    [self.enemies addObject:es];

    // Launch enemy towards center
    // Get center vector
    CGPoint pointA                  = location;
    CGPoint pointB                  = ccp(s.width/2, s.height/2);
    CGPoint pointC                  = ccpSub(pointB, pointA);
    pointC                          = ccpNormalize(pointC);
    
    b2Vec2 force = b2Vec2((pointC.x/PTM_RATIO) * enemyLaunchForce,
                          (pointC.y/PTM_RATIO) * enemyLaunchForce);
    
    [es applyLinearImpulse:force point:[es worldCenter]];

}

// Scheduled and called regularly to start a wave of enemies
- (void)startWave{
    waveNum++;
    enemyLaunchForce = enemyLaunchForce + (waveNum*10);
    [self unschedule:@selector(spawnEnemyAtLocation:)];
    [self schedule:@selector(spawnEnemyAtLocation:) interval:(1) repeat:waveNum delay:0];
}

// Returns a random CGPoint on the perimeter of the screen
-(CGPoint)randomDirection{
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    CGPoint direction;
    switch(arc4random()%4){
        case 0:
            direction = CGPointMake(arc4random() % (int)s.width,(int)s.height); // top
            break;
        case 1:
            direction = CGPointMake(arc4random() % (int)s.width,0); // bottom
            break;
        case 2:
            direction = CGPointMake(0,arc4random() % (int)s.height); // left
            break;
        default:
            direction = CGPointMake((int)s.width,arc4random() % (int)s.height); // right
    }
    return direction;
}

#pragma mark Touch

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // Convert touch -> ccLocation -> b2Location
    UITouch *touch      = (UITouch *)[touches anyObject];
    CGPoint ccLocation  = [[CCDirector sharedDirector] convertTouchToGL:touch];
   
    [self initTouchAtLocation:ccLocation];
    // If a mouse joint is created, that means user touched an enemy, do not create new enemy!
    if ([self createMouseJointWithTouch:touch]){
        return;
    }
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
    //for (BLEnemySprite *be in self.enemies) {
        // If intersects with point, create mouse joint
        //if ([be intersectsWithPoint:ccLocation]){
            //[be createMouseJointWithGroundBody:boxNode.body target:b2Location maxForce:1000];
            //return YES;
        //}
   //}
    
    // If touch circle and its mouse joint exists, create a mouse joint
    if (touchCircle != nil && [touchCircle intersectsWithPoint:ccLocation]){
        [touchCircle createMouseJointWithGroundBody:boxNode.body target:b2Location maxForce:5000];
        return YES;
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
    
    // If touch circle and its mouse joint exists, move its mouse joint
    if(touchCircle != nil && touchCircle.mouseJoint){
        touchCircle.mouseJoint->SetTarget(b2Location);
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
    
    // If touch circle and its mouse joint exists, remove its mouse joint
    if (touchCircle!= nil && touchCircle.mouseJoint){
        [GB2Engine sharedInstance].world->DestroyJoint(touchCircle.mouseJoint);
        touchCircle.mouseJoint = NULL;
        touchCircle.deleteLater = true;
        touchCircle = nil;
    }
}

#pragma Listner

// Remove BLEnemySprite from enemies mutable array
- (void)removeEnemyFromSpriteLayer:(BLEnemySprite *)es{
    [self.enemies removeObject:es];
}

-(void) dealloc{
	[super dealloc];
}	

@end


















