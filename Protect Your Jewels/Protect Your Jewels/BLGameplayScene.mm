//
//  GameplayScene.m
//  GamePlay
//
//  Created by Bennett Lee on 2/21/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLGameplayScene.h"
#import "BLUILayer.h"
#import "BLSpriteLayer.h"
#import "BLBackgroundLayer.h"
#import "RSGameOver.h"
#import "SimpleAudioEngine.h"

@interface BLGameplayScene()

@property (nonatomic, strong) BLBackgroundLayer *bgLayer;
@property (nonatomic, strong) BLSpriteLayer *spriteLayer;
@property (nonatomic, strong) BLUILayer *uiLayer;

@end

@implementation BLGameplayScene


- (id)init{
    
    if (self = [super init]){
        
        // Load background music
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mountain-wind.wav" loop:YES];
        
        // Create layers and add sa children
        self.uiLayer = [BLUILayer node];
        self.spriteLayer = [BLSpriteLayer node];
        self.bgLayer = [BLBackgroundLayer node];
        
        [self addChild:self.uiLayer z:4];
        [self addChild:self.spriteLayer z:3];
        [self addChild:self.bgLayer z:2];
    }
    
    return self;
}

#pragma Listner

// Update the label
-(void)incrementScore{
    self.currentScore++;
    [self.uiLayer updateLabelWithScore:self.currentScore];
}

// Switches to game over scene
-(void)startGameOver{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[RSGameOver sceneWithScore:self.currentScore]]];
}

@end
