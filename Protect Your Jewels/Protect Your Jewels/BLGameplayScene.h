//
//  GameplayScene.h
//  GamePlay
//
//  Created by Bennett Lee on 2/21/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BLGameplayScene : CCScene

@property int lives;
@property int score;

- (void)decrementLives;
- (void)incrementScore;
- (void)startGameOver;

@end
