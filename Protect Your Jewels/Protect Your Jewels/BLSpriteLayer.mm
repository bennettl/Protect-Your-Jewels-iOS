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
    float enemyLaunchForce;
    CCLabelTTF *_label;
    CCSpriteBatchNode *objectLayer;
    GB2Node *boxNode;
    int waveNum;
}

@property NSMutableArray *enemies;
@property NSMutableArray *touchCircles;

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
        enemyLaunchForce    = 500.0f;
        self.enemies        = [[NSMutableArray alloc] init];
        self.touchCircles   = [[NSMutableArray alloc] init];
        [self initJewel];
        //[self initDebug];

        // Create bounding box
        boxNode = [[BLBoxNode alloc] init];
        
        // Touching
        self.touchEnabled = YES;
        
        // Start Waves
        waveNum = 0;
        int timeBetweenWaves = 5;
        [self schedule:@selector(startWave) interval:timeBetweenWaves repeat:kCCRepeatForever delay:0];
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

    [es playLaunchAudio]; // play enemy launch sound
    
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
    // Play hiya audio every 5 waves
    if (waveNum % 5 == 0){
        [BLEnemySprite playHiyaAudio];
    }
    
    waveNum++;
    enemyLaunchForce = enemyLaunchForce + (waveNum * 10);
    [self unschedule:@selector(spawnEnemyAtLocation:)];
    [self schedule:@selector(spawnEnemyAtLocation:) interval:1.0f repeat:waveNum delay:0];
}

// Returns a random CGPoint on the perimeter of the screen
-(CGPoint)randomDirection{
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    CGPoint direction;
    switch(arc4random()%4){
        case 0:
            //direction = CGPointMake(arc4random() % (int)s.width,(int)s.height); // top
            direction = CGPointMake(0,arc4random() % (int)s.height); // left
            break;
        case 1:
            direction = CGPointMake((int)s.width,arc4random() % (int)s.height); // right
            //direction = CGPointMake(arc4random() % (int)s.width,0); // bottom
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
//    UITouch *touch      = (UITouch *)[touches anyObject];
    
    // Init BQTouchCircles
    int counter = 0;
    for (UITouch *touch in touches) {
        if (counter > 1){  break;   } // allow only two touches
        [self initTouchCircleWithTouch:touch];
        counter++;
    }
   
//    [self initTouchCircleAtLocation:ccLocation];
    // If a mouse joint is created, that means user touched an enemy, do not create new enemy!
//    if ([self createMouseJointWithTouch:touch]){
//        return;
//    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //UITouch *touch      = (UITouch *)[touches anyObject];
    
    // Move BQTouchCircles
    for (UITouch *touch in touches) {
        [self moveTouchCircleWithTouch:touch];
    }
    
//    [self updateMouseJointWithTouch:touch];
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch      = (UITouch *)[touches anyObject];
    CGPoint ccLocation  = [[CCDirector sharedDirector] convertTouchToGL:touch];
    b2Vec2 b2Location   = b2Vec2(ccLocation.x/PTM_RATIO, ccLocation.y/PTM_RATIO);
    
    // Remove BQTouchCircles
    for (UITouch *touch in touches) {
        [self removeTouchCircleWithTouch:touch];
    }

//    [self removeMouseJoint];
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch      = (UITouch *)[touches anyObject];
    
    // Remove BQTouchCircles
    for (UITouch *touch in touches) {
        [self removeTouchCircleWithTouch:touch];
    }

    //    [self removeMouseJoint];
}

#pragma mark Touch Circles

// Create touch circle, mouse joint, and add it to touch circles
-(void)initTouchCircleWithTouch:(UITouch *)touch{
    BQTouchCircle *touchCircle = [[BQTouchCircle alloc] initWithTouch:touch andGroundBody:boxNode.body];
    [self.touchCircles addObject:touchCircle];
}

- (void)moveTouchCircleWithTouch:(UITouch *)touch{
    // Loop through every touch circle
    for (BQTouchCircle *tc in self.touchCircles) {
        // If touch circle belongs to this touch, then move it
        if ([tc belongsToTouch:touch]){
            CGPoint ccLocation  = [[CCDirector sharedDirector] convertTouchToGL:touch];
            b2Vec2 b2Location   = b2Vec2FromCC(ccLocation.x, ccLocation.y);
            tc.mouseJoint->SetTarget(b2Location);
        }
    }
}

- (void)removeTouchCircleWithTouch:(UITouch *)touch{
    // Loop through every touch circle
    for (int i = 0; i < self.touchCircles.count; i++){
        BQTouchCircle *touchCircle = [self.touchCircles objectAtIndex:i];
        // If touch circle belongs to this touch, then remove it
        if ([touchCircle belongsToTouch:touch]){
            [GB2Engine sharedInstance].world->DestroyJoint(touchCircle.mouseJoint);
            touchCircle.deleteLater = true;
            [self.touchCircles removeObject:touchCircle];
        }
    }
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

- (void)updateTouchCircleWithTouch:(UITouch *)touch{

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
    
    
//    // If touch circle and its mouse joint exists, remove its mouse joint
//    if (touchCircle!= nil && touchCircle.mouseJoint){
//        
//    }
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


















