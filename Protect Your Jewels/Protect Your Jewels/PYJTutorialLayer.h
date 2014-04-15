//
//  PYJTutorialLayer.h
//  Protect Your Jewels
//
//  Created by Brian Quock on 4/14/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"

typedef enum {
    jewel,
    swipe,
    grab,
    bomb
} Screen;

@interface PYJTutorialLayer : CCLayer

@property Screen screen;

-(void)previousScreen;
-(void)nextScreen;
//extern int const MAX_TOUCHES = 1;

@end
