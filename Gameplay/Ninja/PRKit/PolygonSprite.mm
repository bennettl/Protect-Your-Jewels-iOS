//
//  PolygonSprite.m
//  CutCutCut
//
//  Created by Allen Benson G Tan on 5/20/12.
//  Copyright 2012 WhiteWidget Inc. All rights reserved.
//

#import "PolygonSprite.h"

@implementation PolygonSprite

#pragma mark Initialization


+(id)spriteWithFile:(NSString*)filename body:(b2Body*)body original:(BOOL)original{
    return [[[self alloc] initWithFile:filename body:body original:original] autorelease];
}

+(id)spriteWithTexture:(CCTexture2D*)texture body:(b2Body*)body original:(BOOL)original{
    return [[[self alloc] initWithTexture:texture body:body original:original] autorelease];
}

//+(id)spriteWithWorld:(b2World*)world{
//    return [[[self alloc] initWithWorld:world] autorelease];
//}

// Load the texture and call initWithTexture
-(id)initWithFile:(NSString*)filename body:(b2Body*)body original:(BOOL)original{
    NSAssert(filename != nil, @"Invalid file name yo!");
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:filename];
    return [self initWithTexture:texture body:body original:original];
}

// Load the points and call initWithPoints (PRFilledPolygon class)
-(id)initWithTexture:(CCTexture2D*)texture body:(b2Body*)body original:(BOOL)original{
    // Get all points/verticies and store them in a NSMutableaArray
    b2Fixture *fixture              = body->GetFixtureList();
    b2PolygonShape *polygonShape    = (b2PolygonShape *)fixture->GetShape();
    int verticies                   = polygonShape->GetVertexCount();
    NSMutableArray *points          = [NSMutableArray arrayWithCapacity:verticies];
    
    for (int i = 0; i < verticies; i++) {
        CGPoint point = ccp(polygonShape->GetVertex(i).x * PTM_RATIO, polygonShape->GetVertex(i).y * PTM_RATIO); // convert to box2D points;
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    
    // PRFilledPolyGon will take care of points/texture initializations
    if (self = [super initWithPoints:points andTexture:texture]){
        // initialize the rest
        self.body           = body;
        self.body->SetUserData(self);
        self.original       = original;
        // get center of polygon
        self.centroid       = body->GetLocalCenter();
        // assgin anchor point base on center
        self.anchorPoint    = ccp(self.centroid.x * PTM_RATIO / texture.contentSize.width,
                                  self.centroid.y * PTM_RATIO/ texture.contentSize.height);
        
    }
    return self;
}

-(id)initWithWorld:(b2World*)world{
    return nil;
}

-(b2Body*)createBodyForWorld:(b2World*)world
                    position:(b2Vec2)position
                    rotation:(float)rotation
                    vertices:(b2Vec2*)vertices
                 vertexCount:(int32)count
                     density:(float)density
                    friction:(float)friction
                 restitution:(float)restitution{
    
    // Body def and body
    b2BodyDef bodyDef;
    bodyDef.type                    = b2_dynamicBody;
    bodyDef.position                = position;
    bodyDef.angle                   = rotation;
    b2Body *body                    = world->CreateBody(&bodyDef);
    
    // Shape
    b2PolygonShape polygonShape;
    polygonShape.Set(vertices, count);
    
    // fixtureDef, and fixture
    b2FixtureDef fixtureDef;
    fixtureDef.shape                = &polygonShape;
    fixtureDef.density              = density;
    fixtureDef.friction             = friction;
    fixtureDef.restitution          = restitution;
    
    // Collision filtering
    fixtureDef.filter.categoryBits  = 0;
    fixtureDef.filter.maskBits      = 0;
    
    body->CreateFixture(&fixtureDef);
    
    return body;
}


// Overload parent: Whenever sprite's position gets updated, the b2Body position gets updated as well
- (void)setPosition:(CGPoint)position{
    self.position = position;
    self.body->SetTransform(b2Vec2(position.x/ PTM_RATIO, position.y/ PTM_RATIO), self.body->GetAngle());
}


-(void)activateCollisions{
    b2Fixture *fixture      = self.body->GetFixtureList();
    b2Filter filter         = fixture->GetFilterData();
    // setting everything to the same non-zero category/maskbits will enable collision with everything
    filter.categoryBits     = 0x0001;
    filter.maskBits         = 0x0001;
    fixture->SetFilterData(filter);
}

-(void)deactivateCollisions{
    b2Fixture *fixture      = self.body->GetFixtureList();
    b2Filter filter         = fixture->GetFilterData();
    // setting everything to zero category/mask bits will disable collision
    filter.categoryBits     = 0;
    filter.maskBits         = 0;
    fixture->SetFilterData(filter);
}

// Make sure that our Box2D shape and our sprite are in the same position when moving
-(CGAffineTransform) nodeToParentTransform{
    b2Vec2 pos  = _body->GetPosition();
    
    float x = pos.x * PTM_RATIO;
    float y = pos.y * PTM_RATIO;
    if ( !self.ignoreAnchorPointForPosition ) {
        x += _anchorPointInPoints.x;
        y += _anchorPointInPoints.y;
    }
    
    // Make matrix
    float radians = _body->GetAngle();
    float c = cosf(radians);
    float s = sinf(radians);
    
    if( ! CGPointEqualToPoint(_anchorPointInPoints, CGPointZero) ){
        x += c*-_anchorPointInPoints.x+ -s*-_anchorPointInPoints.y;
        y += s*-_anchorPointInPoints.x+ c*-_anchorPointInPoints.y;
    }
    
    // Rot, Translate Matrix
    _transform = CGAffineTransformMake( c,  s,
                                       -s,c,
                                       x,y );
    
    return _transform;
}
@end