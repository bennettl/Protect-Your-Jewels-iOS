//
//  PYJSpriteLayer.mm
//  Ninja
//
//  Created by Bennett Lee on 2/15/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//


#import "PYJSpriteLayer.h"
#import "GBox2D/GB2Sprite.h"
#import "GBox2D/GB2ShapeCache.h"
#import "GBox2D/GB2DebugDrawLayer.h"
#import "PYJJewelSprite.h"
#import "PYJThemeManager.h"
#import "PYJTouchCircle.h"
#import "PYJBoxNode.h"
#import "PYJBombSprite.h"
#import "PYJShieldSprite.h"

//#define MAX_TOUCHES 1

#pragma mark - PYJSpriteLayer

@interface PYJSpriteLayer(){
    b2World *world;
    float enemyLaunchForce;             // adjust this to toggle difficulty (higher = more difficult)
    CCLabelTTF *_label;
    CCSpriteBatchNode *objectLayer;
    GB2Node *boxNode;
    int waveNum;
    int currentTouches;
}

@property NSMutableArray *enemies;
@property NSMutableArray *touchCircles;
@property (nonatomic, strong) CCParticleSystemQuad *shieldParticle;
@property (nonatomic, strong) PYJShieldSprite *shieldSprite;
@property (nonatomic, strong) PYJJewelSprite *jewelSprite;


@end

@implementation PYJSpriteLayer
static BOOL classicMode;

#pragma mark initlization

-(id) init{
	if ((self=[super init])) {
        [self schedule:@selector(resetGame)];
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
        self.touchCircles   = [[NSMutableArray alloc] init];
    }
	return self;
}

+(id)nodeWithIsClassic:(BOOL)classic{
    classicMode = classic;
    return [[[self alloc] init] autorelease];
}

-(void)startGame{
    // Create jewel
    [self initJewel];
    [self initShield];
    
    // Creates bounding box
    boxNode = [[PYJBoxNode alloc] init];
    
    // Touching
    self.touchEnabled = YES;
    currentTouches = 0;
    
    // Start Waves
    waveNum = 0;
    int timeBetweenWaves;
    if(classicMode){
        timeBetweenWaves = 5;
    }
    else{
        timeBetweenWaves = 2;
    }
    [self unschedule:@selector(startWave)];
    if(classicMode){
        [self schedule:@selector(startWave) interval:timeBetweenWaves repeat:kCCRepeatForever delay:0];
    }
    else{
        [self schedule:@selector(startWave) interval:timeBetweenWaves repeat:kCCRepeatForever delay:0];
    }
    //[self initDebug];
}


- (void)initShield {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    self.shieldSprite = [PYJShieldSprite shieldSprite];
    self.shieldSprite.body->SetActive(NO);
    [self.shieldSprite setPhysicsPosition:b2Vec2FromCC(winSize.width/2, winSize.height/2)];
    [objectLayer addChild:self.shieldSprite.ccNode z:11];
}


// Creates jewel
 -(void)initJewel{
     CGSize s = [[CCDirector sharedDirector] winSize];
     self.jewelSprite = [PYJJewelSprite jewelSprite];
     [self.jewelSprite setPhysicsPosition:b2Vec2FromCC(s.width/2, s.height/2)];
     [objectLayer addChild:self.jewelSprite.ccNode z:10];
     
     CCParticleSystemQuad *system = [CCParticleSystemQuad particleWithFile:@"JewelParticles.plist"];
     system.sourcePosition = ccp(s.width/2, s.height/2);
     [self addChild:system z:8];

}

// Add debug layer
- (void)initDebug{
    GB2DebugDrawLayer *debugLayer = [[GB2DebugDrawLayer alloc] init];
    [self addChild:debugLayer z:30];
}

- (void)deployShield {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    self.shieldSprite.body->SetActive(YES);
    self.shieldParticle = [[CCParticleSystemQuad alloc] initWithFile:@"fireShield.plist"];
    self.shieldParticle.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:self.shieldParticle z:8];

    [self scheduleOnce:@selector(removeShield) delay:7];
}


- (void)removeShield {
    NSLog(@"removing shield");
    self.shieldSprite.body->SetActive(NO);
    self.shieldParticle.visible = NO;
    [self removeChild:self.shieldSprite.ccNode cleanup:YES];
}

// Initializes enemy at location
- (void)spawnObjectAtRandomLocation{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint location = [self randomDirection];
    
    GB2Sprite *randomObject = nil;
    
    // Adds randomness to spawning items
    int randomNumber = arc4random_uniform(10);
    
    int odds;
    if(classicMode){
        odds = 7;
    }
    else{
        odds = 8;
    }
    
    if (randomNumber < odds){
        randomObject = [[PYJThemeManager sharedManager] enemySprite];
        [self.enemies addObject:randomObject];
        [(PYJEnemySprite *)randomObject playLaunchAudio]; // play enemy launch sound
    } else{
        randomObject = [[PYJBombSprite alloc] initWithSpriteLayer:self];
    }
    
    [randomObject setPhysicsPosition:b2Vec2FromCC(location.x, location.y)];
    [self addChild:randomObject.ccNode z:10];

    
    // Launch enemy towards center
    // Get center vector
    CGPoint pointA                  = location;
    CGPoint pointB                  = ccp(winSize.width/2, winSize.height*9/(10+enemyLaunchForce/700));
    CGPoint pointC                  = ccpSub(pointB, pointA);
    pointC                          = ccpNormalize(pointC);
    
    b2Vec2 force = b2Vec2((pointC.x/PTM_RATIO) * enemyLaunchForce,
                          (pointC.y/PTM_RATIO) * enemyLaunchForce);
    
    [randomObject applyLinearImpulse:force point:[randomObject worldCenter]];
}

// Scheduled and called regularly to start a wave of enemies
- (void)startWave{
    // Play hiya audio every 5 waves
    if (waveNum % 5 == 0){
        [PYJEnemySprite playAttackAudio];
    }
    
    waveNum++;
    if(classicMode){
        enemyLaunchForce = enemyLaunchForce + (waveNum * 5);
    }
    else{
        enemyLaunchForce = enemyLaunchForce + (waveNum * 10);
    }
    [self unschedule:@selector(spawnObjectAtRandomLocation)];
    // arcade mode
    if(!classicMode){
        [self schedule:@selector(spawnObjectAtRandomLocation) interval:(float)(1.0f-waveNum/1000) repeat:(int)(waveNum*1.5) delay:0];
    }
    // classic mode
    else{
        [self schedule:@selector(spawnObjectAtRandomLocation) interval:(float)(1.0f-waveNum/1000) repeat:(int)(waveNum*1.5) delay:0];
    }
}

// Returns a random CGPoint on the perimeter of the screen
-(CGPoint)randomDirection{
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    CGPoint direction;
    switch(arc4random()%4){
        case 0:
            direction = CGPointMake(0,arc4random() % (int)s.height); // left
            break;
        case 1:
            direction = CGPointMake((int)s.width,arc4random() % (int)s.height); // right
            break;
        case 2:
            direction = CGPointMake(0,arc4random() % (int)s.height); // left
            break;
        default:
            direction = CGPointMake((int)s.width,arc4random() % (int)s.height); // right
    }
    return direction;
}

#pragma mark Multi-Touch

// Called at start of touch
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // Don't process touch if current touches reaches max
    
    
        
    if (currentTouches > MAX_TOUCHES){
        return;
    }
    
    // Process each touch once
    for (UITouch *touch in touches) {
        // If touch is not connected to any enemy, create a touch circle
        if (![self createEnemyJointsWithTouch:touch]){
            [self initTouchCircleWithTouch:touch];
        }
        // Don't create any more mouse joints/touch cirlces if current touches reaches maximum
        if (currentTouches > MAX_TOUCHES){
            return;
        }
    }
}

// Called when a touch moves
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // Process each touch once
    for (UITouch *touch in touches) {
        // If no enemies joints are updated, update touch circle joints
        if (![self updateEnemyJointsWithTouch:touch]){
            [self updateTouchCircleJointsWithTouch:touch];
        }
    }
}

// Called when a touch no longer exists
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // Process each touch once
    for (UITouch *touch in touches){
        // If no enemy joints were removed, then remove touch circle joints
        if (![self removeEnemyJointsWithTouch:touch]){
            [self removeTouchCircleWithTouch:touch];
        }
    }
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    // Process each touch once
    for (UITouch *touch in touches){
        // If no enemy joints were removed, then remove touch circle joints
        if (![self removeEnemyJointsWithTouch:touch]){
            [self removeTouchCircleWithTouch:touch];
        }
    }
}

#pragma mark Enemy Joints

// Called to create a mouse joint (grabbing an enemy). Returns YES if touch is created with enemy
- (BOOL)createEnemyJointsWithTouch:(UITouch *)touch{
    CGPoint ccLocation  = [[CCDirector sharedDirector] convertTouchToGL:touch];
    b2Vec2 b2Location   = b2Vec2FromCC(ccLocation.x, ccLocation.y);
    
    // Loop through all enemies
    for (PYJEnemySprite *es in self.enemies) {
        // If enemy intersects with point, create mouse joint and store reference to touch in enemy
        if ([es intersectsWithPoint:ccLocation]){
            [es createMouseJointWithGroundBody:boxNode.body target:b2Location maxForce:1000];
            [es canCollideWithJewel:NO];
            [es updateTouch:touch];
            currentTouches++; // keep track of current touches
            return YES; // one touch = intersect with one enemy, no point in looping through the rest
        }
    }
    return NO; // no enemies intersected with touch
}

// Loop through every enemy. Return 'YES' if an enemy is connected with touch and mousejoint update is sucessful
- (BOOL)updateEnemyJointsWithTouch:(UITouch *)touch{
    // Convert touch -> ccLocation -> b2Location
    CGPoint ccLocation  = [[CCDirector sharedDirector] convertTouchToGL:touch];
    b2Vec2 b2Location   = b2Vec2FromCC(ccLocation.x, ccLocation.y);
    
    // Loop through all enemies
    for (PYJEnemySprite *es in self.enemies) {
        // If enemy is connected with this touch, update its touch and mousejoint
        if ([es hasTouch:touch] && es.mouseJoint){
            es.mouseJoint->SetTarget(b2Location);
            return YES; // one touch = one enemy, return YES
        }
    }
    return NO; // no enemies connected with touch
}

// Loop through every enemy. Return 'YES' if an enemy is connected with touch and mousejoint removal is sucessful
- (BOOL)removeEnemyJointsWithTouch:(UITouch *)touch{
    // Loop through all enemies and see if there's any touches to be removed
    for (PYJEnemySprite *es in self.enemies){
        // If enemy is connected with a touch, remove its touch and mouse joint
        if([es hasTouch:touch]){
            [es updateTouch:nil];
            [GB2Engine sharedInstance].world->DestroyJoint(es.mouseJoint);
            es.mouseJoint = NULL;
            currentTouches--; // keep track of current touches
            return YES;  // one touch = one enemy, return YES
        }
    }
    return NO; // no enemies connected with touch
}

#pragma mark Touch Circle Joints

// Create touch circle
-(void)initTouchCircleWithTouch:(UITouch *)touch{
    PYJTouchCircle *touchCircle = [[PYJTouchCircle alloc] initWithTouch:touch andGroundBody:boxNode.body];
    [self.touchCircles addObject:touchCircle];
    currentTouches++; // keep track of current touches
}

// Called when a touch circle is moved
- (void)updateTouchCircleJointsWithTouch:(UITouch *)touch{
    // Loop through every touch circle
    for (PYJTouchCircle *tc in self.touchCircles) {
        // If touch circle belongs to this touch, then move it
        if ([tc connectedToTouch:touch]){
            CGPoint ccLocation  = [[CCDirector sharedDirector] convertTouchToGL:touch];
            b2Vec2 b2Location   = b2Vec2FromCC(ccLocation.x, ccLocation.y);
            tc.mouseJoint->SetTarget(b2Location);
        }
    }
}

// Called to remove a touch circle and delete the corresponding joint
- (void)removeTouchCircleWithTouch:(UITouch *)touch{
    // Loop through every touch circle
    for (int i = 0; i < self.touchCircles.count; i++){
        PYJTouchCircle *touchCircle = [self.touchCircles objectAtIndex:i];
        // If touch circle belongs to this touch, then remove it
        if ([touchCircle connectedToTouch:touch]){
            [GB2Engine sharedInstance].world->DestroyJoint(touchCircle.mouseJoint);
            touchCircle.deleteLater = true;
            [self.touchCircles removeObject:touchCircle];
            currentTouches--;
        }
    }
}

#pragma Listner

// Remove PYJNinjaSprite from enemies mutable array
- (void)removeEnemyFromSpriteLayer:(PYJEnemySprite *)es{
    // If enemy has a mouse joint, it means user is holding it. Decrement the current touches count
    if (es.mouseJoint){
        currentTouches--; // keep track of current touches
    }
    
    [self.enemies removeObject:es];
}

-(void)stopGame{
    [self unscheduleAllSelectors];
}

// Stop all schedules
-(void)resetGame{
    [self unscheduleAllSelectors];
    for (b2Body* b = [GB2Engine sharedInstance].world->GetBodyList(); b; b = b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *) b->GetUserData();
            [self removeChild:sprite cleanup:YES];
        }
        [GB2Engine sharedInstance].world->DestroyBody(b);
    }
    for (int i = 0; i < [self.enemies count]; i++){
        [self removeChild:[self.enemies objectAtIndex:0] cleanup:YES];
    }
    for (int i = 0; i < [self.touchCircles count]; i++){
        [self removeChild:[self.touchCircles objectAtIndex:0] cleanup:YES];
    }
    [self.enemies removeAllObjects];
    [self.touchCircles removeAllObjects];
    refreshedScreen = YES;
    [self startGame];
}

-(void) update:(ccTime)delta{
    
}

-(void) dealloc{
    [_enemies dealloc];
    [_touchCircles dealloc];
	[super dealloc];
}	

@end

