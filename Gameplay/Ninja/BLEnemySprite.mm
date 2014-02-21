//
//  BLEnemySprite.m
//  GamePlay
//
//  Created by Bennett Lee on 2/20/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLEnemySprite.h"


@implementation BLEnemySprite

+(BLEnemySprite *)enemySprite{
    return [[[self alloc] initWithDynamicBody:@"ninja" spriteFrameName:@"ninja/attack.png"] autorelease];
}


-(BOOL)intersectsWithPoint:(CGPoint)ccLocation{
    b2Vec2 b2Location(ccLocation.x/PTM_RATIO, ccLocation.y/PTM_RATIO);
    
    for (b2Fixture *fixture = self.body->GetFixtureList(); fixture; fixture = fixture->GetNext()){
        if (fixture->TestPoint(b2Location)){
            return YES;
        }
    }
    return NO;

}

@end
