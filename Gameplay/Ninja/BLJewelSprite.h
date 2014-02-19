//
//  BLJewelPolygon.h
//  GamePlay
//
//  Created by Bennett Lee on 2/18/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLPolygonSprite.h"

@interface BLJewelSprite : BLPolygonSprite {
    
}
// Determine if object intersects with a CGPoint
- (BOOL)intersectsWithPoint:(CGPoint)ccLocation;
@end
