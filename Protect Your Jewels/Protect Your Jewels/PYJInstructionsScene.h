//
//  PYJInstructionsScene.h
//  Protect Your Jewels
//
//  Created by Brian Quock on 3/10/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "CCScene.h"
#import "cocos2d.h"
#import "Box2D.h"

@interface PYJInstructionsScene : CCScene

- (void)decrementLives;
- (void)incrementScoreByValue:(int)value;


@property int lives;
@property int score;
@end
