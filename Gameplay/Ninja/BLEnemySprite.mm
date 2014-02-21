//
//  BLEnemySprite.m
//  GamePlay
//
//  Created by Bennett Lee on 2/20/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLEnemySprite.h"
#import "GB2Contact.h"

@implementation BLEnemySprite

+(BLEnemySprite *)enemySprite{
    return [[[self alloc] initWithDynamicBody:@"ninja"
                              spriteFrameName:@"ninja/attack.png"] autorelease];
}

- (id)initWithSpriteLayer:(BLSpriteLayer *)sl{
    if (self = [super initWithDynamicBody:@"ninja"
                          spriteFrameName:@"ninja/attack.png"]){
    
        // Do not let the enemy rotate
        [self setFixedRotation:true];
    
        // Store the sprite layer
        spriteLayer = sl;
    }
    
    return self;
}

// Does ccLocation intersect with any of the body's fixtures?
-(BOOL)intersectsWithPoint:(CGPoint)ccLocation{
    b2Vec2 b2Location(ccLocation.x/PTM_RATIO, ccLocation.y/PTM_RATIO);

    // Loop through and test all fixtures
    for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()){
        if (f->TestPoint(b2Location)){
            return YES;
        }
    }
    return NO;
}

#pragma mark Collision Detection

// write functions in the form of [objectA endContactWithMonkey:collisionA];

- (void)beginContactWithBLJewelSprite:(GB2Contact*)contact{
    NSLog(@"ouch");
}

@end
