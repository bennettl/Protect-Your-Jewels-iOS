//
//  BLBackGroundLayer.m
//  GamePlay
//
//  Created by Bennett Lee on 2/21/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLBackgroundLayer.h"


@implementation BLBackgroundLayer

// Init function adds background
- (id)init{
    if (self = [super init]){
        CCSprite *backgroundSprite = [CCSprite spriteWithFile:@"game_background.png"];
        
        // Center of window
        CGSize winSize              = [[CCDirector sharedDirector] winSize];
        backgroundSprite.position   = ccp(winSize.width/2, winSize.height/2);
        
        [self addChild:backgroundSprite];
    }
    return self;    
}

@end
