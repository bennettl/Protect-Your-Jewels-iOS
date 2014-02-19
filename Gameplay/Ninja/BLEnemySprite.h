//
//  BLEnemyPolygon.h
//  GamePlay
//
//  Created by Bennett Lee on 2/18/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLPolygonSprite.h"

@interface BLEnemySprite : BLPolygonSprite {
    
}
- (id)initWithWorld:(b2World *)world atLocation:(CGPoint)ccLocation;
- (BOOL)intersectsWithPoint:(CGPoint)ccLocation;

@end
