//
//  BLEnemySprite.h
//  GamePlay
//
//  Created by Bennett Lee on 2/20/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "GB2Sprite.h"

@interface BLEnemySprite : GB2Sprite {
    
}

+(BLEnemySprite *)enemySprite;
-(BOOL)intersectsWithPoint:(CGPoint)ccLocation;

@end
