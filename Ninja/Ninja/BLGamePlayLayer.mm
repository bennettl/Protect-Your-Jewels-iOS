//
//  HelloWorldLayer.mm
//  Ninja
//
//  Created by Bennett Lee on 2/15/14.
//  Copyright Bennett Lee 2014. All rights reserved.
//

#import "BLGamePlayLayer.h"
#import "BLEnemy.h"
#import "BLContactListener.h"

#define BOX_TAG 1
#define ENEMY_TAG 2

#pragma mark - BLGamePlayLayer

@interface BLGamePlayLayer(){
    b2World *_world;
    b2Body *_boxBody;
    BLContactListener *_contactListener;
    float _forceMultiplier;
    GLESDebugDraw *_debugDraw;
    CCLabelTTF *_label;
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
        
        _forceMultiplier    = 40.0f;
        self.totalScore          = 0;
        
        [self createScoreLabel];
        [self createWorld];
        [self createBoundingBox];
        
        self.enemies = [[NSMutableArray alloc] init];
        
        
        // Collision Detection
        _contactListener = new BLContactListener(self);
        _world->SetContactListener(_contactListener);
        
        // Touching
        self.touchEnabled = YES;
        
        // Schedule
        [self scheduleUpdate];
        
        float enemyFrequency = 5.0; // THIS WILL DECREASE FOR MORE DIFFICULT WAVES
        [self schedule:@selector(startWave) interval:enemyFrequency];
    }
	return self;
}

// Creates label score in lower right corner
- (void)createScoreLabel{
    CGSize winSize     = [[CCDirector sharedDirector] winSize];
    _label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i", self.totalScore] fontName:@"Marker Felt" fontSize:20];
    _label.position = ccp(winSize.width - _label.contentSize.width/2 - 40,
                         25);
    [self addChild:_label];
    
}

// Initializes the world
-(void)createWorld{
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
    _world = new b2World(gravity);
}

// Initializes enemy at location
- (void)spawnEnemyAtLocation:(CGPoint)location{
    BLEnemy *be = [[BLEnemy alloc] initWithWorld:_world andLocation:ccp(location.x, location.y)];
    [self addChild:be.sprite];
    [self.enemies addObject:be];
}

// Creates the bonding box
- (void)createBoundingBox{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    b2Vec2 padding = b2Vec2(52/PTM_RATIO, 52/PTM_RATIO); // padding should be size of enemy
    
    // Create bounding box
    b2BodyDef boxBodyDef;
    boxBodyDef.position.Set(-padding.x, -padding.y);
    _boxBody = _world->CreateBody(&boxBodyDef);
    
    b2EdgeShape boxShape;
    b2FixtureDef boxShapeDef;
    boxShapeDef.shape = &boxShape;
    boxShapeDef.isSensor = true;
    
    // Bottom
    boxShape.Set(b2Vec2(-padding.x, -padding.y),
                 b2Vec2((winSize.width/PTM_RATIO) + padding.x, -padding.y));
    _boxBody->CreateFixture(&boxShapeDef);
    
    // Left
    boxShape.Set(b2Vec2(padding.x, -padding.y),
                 b2Vec2(padding.x, (winSize.height/PTM_RATIO) + padding.y));
    _boxBody->CreateFixture(&boxShapeDef);
    
    // Top
    boxShape.Set(b2Vec2(-padding.x, (winSize.height/PTM_RATIO) + padding.y),
                 b2Vec2((winSize.width/PTM_RATIO) + padding.x, (winSize.height/PTM_RATIO) + padding.y));
    _boxBody->CreateFixture(&boxShapeDef);
    
    // Right
    boxShape.Set(b2Vec2((winSize.width/PTM_RATIO) + padding.x, (winSize.height/PTM_RATIO) + padding.y),
                 b2Vec2((winSize.width/PTM_RATIO) + padding.x, - padding.y));
    _boxBody->CreateFixture(&boxShapeDef);
}


#pragma mark Touch

-(void)update:(ccTime)dt{
    _world->Step(dt, 10, 10); // run physics simulation
    
    // Loop through and update all body sprites on results from physics simulation
    for (b2Body *b = _world->GetBodyList(); b; b = b->GetNext()) {
        // If user data is available, update it's sprite position
        if (b->GetUserData() != NULL){
            CCSprite *sprite = (CCSprite *)b->GetUserData();
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
        }
    }
    
    [self detectCollision]; // collision detection
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    // Convert touch -> ccLocation -> b2Location
    UITouch *touch      = (UITouch *)[touches anyObject];
    CGPoint ccLocation  = [[CCDirector sharedDirector] convertTouchToGL:touch];
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
    for (BLEnemy *be in self.enemies) {
        
        // If intersects with point, create mouse joint
        if ([be intersectsWithPoint:ccLocation]){
            b2MouseJointDef md;
            md.bodyA = _boxBody;
            md.bodyB = be.body; //bodyB is body you want to move
            md.target = b2Location; // point you want to move to
            md.collideConnected = true;
            md.maxForce = 3000.0f * be.body->GetMass(); // force you have when moving body
            be.mouseJoint = (b2MouseJoint *)_world->CreateJoint(&md);
            be.body->SetAwake(true);
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
    for (BLEnemy *be in self.enemies) {
        // If mousejoint exists, update it
        if (be.mouseJoint){
            be.mouseJoint->SetTarget(b2Location);
        }
    }
}

- (void)removeMouseJoint{
    // Loop through all enemies
    for (BLEnemy *be in self.enemies) {
        // If mousejoint exists, delete it
        if (be.mouseJoint){
            _world->DestroyJoint(be.mouseJoint);
            be.mouseJoint = NULL;
        }
    }
}

#pragma mark collision detection

- (void)detectCollision{
    
    // Iterate through each collision detection
    std::vector<b2Body *> destroyBlocks;
    std::vector<MyContact>::iterator pos;
    
    for (pos = _contactListener->_contacts.begin();
         pos != _contactListener->_contacts.end(); ++pos){
        
        MyContact contact = *pos;
       //     NSLog(@"something was hit");
        
            // Examine bodies
            b2Body * bodyA = contact.fixtureA->GetBody();
            b2Body * bodyB = contact.fixtureB->GetBody();
            
            // Two Enemies
            if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL){
                CCSprite *bodyASprite = (CCSprite *)bodyA->GetUserData();
                CCSprite *bodyBSprite = (CCSprite *)bodyB->GetUserData();
                
                
            }
            
//            if (bodyB == _boxBody)
        }
    
        // Ball fixture collides with bottomFixture
//        if ((contact.fixtureA == _bottomFixture && contact.fixtureB == _ballFixture) ||
//            (contact.fixtureA == _ballFixture && contact.fixtureB == _bottomFixture) ){
//            CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
//            [[CCDirector sharedDirector] replaceScene:gameOverScene];
//            [self unschedule:@selector(tick:)];
//            return;
//        }
        
  
        
//        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL){
//            CCSprite *bodyASprite = (CCSprite *)bodyA->GetUserData();
//            CCSprite *bodyBSprite = (CCSprite *)bodyB->GetUserData();
//            NSLog(@"%i %i", bodyASprite.tag, bodyBSprite.tag);
//            
//            // Determine if its a ball (1) and block (2) base on sprite tags
//                // If body b is not already in there
//                if (std::find(destroyBlocks.begin(), destroyBlocks.end(), bodyB) == destroyBlocks.end()) {
//                    destroyBlocks.push_back(bodyB);
//                }
//            } else if (bodyASprite.tag == 2 && bodyBSprite.tag == 1){
//                // Body body A isn't already there
//                if (std::find(destroyBlocks.begin(), destroyBlocks.end(), bodyA) == destroyBlocks.end()){
//                    destroyBlocks.push_back(bodyA);
//                }
//            }
//        }
    
   
    
    // Iterate through each destroyBlocks and destroy them
    std::vector<b2Body *>::iterator pos2;
    for (pos2 = destroyBlocks.begin(); pos2 != destroyBlocks.end(); ++pos2){
        b2Body *body = *pos2;
        if (body->GetUserData() != NULL){
            CCSprite *bodySprite = (CCSprite *)body->GetUserData();
            [self removeChild:bodySprite cleanup:YES];
        }
        _world->DestroyBody(body);
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
    
    if (spriteA == NULL && spriteB != NULL){
        if (spriteB.tag == ENEMY_TAG){
            self.totalScore++;
            // remove ball
        }
    } else if (spriteA != NULL && spriteB == NULL){
        if (spriteA.tag == ENEMY_TAG){
            self.totalScore++;
            // remove ball
        }
    }
    [_label setString:[NSString stringWithFormat:@"Score: %i", self.totalScore]];
}

- (void)endContact:(b2Contact*)contact{
    
}

- (void)startWave{
    int currentTime = CACurrentMediaTime();
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // Spawn from right
    CGPoint randR = CGPointMake((int) winSize.width,arc4random() % (int) winSize.height);
    // Spawn from left
    CGPoint randL = CGPointMake(0,arc4random() % (int) winSize.height);
    // Spawn from top
    CGPoint randT = CGPointMake(arc4random() % (int) winSize.width,(int) winSize.height);
    // Spawn from bottom
    CGPoint randB = CGPointMake(arc4random() % (int) winSize.width,0);
    
    int direct = random()%4;
    if(direct == 0){
        [self spawnEnemyAtLocation:randT];
    }else if(direct == 1){
        [self spawnEnemyAtLocation:randB];
    }else if(direct ==2){
        [self spawnEnemyAtLocation:randL];
    }else{
        [self spawnEnemyAtLocation:randR];
    }
}

-(void) dealloc{
	delete _world;
	_world = NULL;
	
	
	[super dealloc];
}	

@end


















