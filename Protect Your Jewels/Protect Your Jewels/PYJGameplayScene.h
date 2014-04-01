//
//  PYJGameplayScene.h
//  Protect Your Jewels
//
//  Created by Bennett Lee on 2/21/14.
//  Copyright 2014 ITP382RBBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PYJGameplayScene : CCScene

@property int lives;
@property int score;

- (void)decrementLives;
- (void)incrementScoreByValue:(int)value;
- (void)startGameOver;
- (void)pauseGame;
- (void)resumeGame;

@end
