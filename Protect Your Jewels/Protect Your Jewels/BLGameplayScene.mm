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
#import "BLGameOverLayer.h"
#import "SimpleAudioEngine.h"
#import "GB2Engine.h"
#import "BLHighScoreManager.h"

@interface BLGameplayScene()

@property (nonatomic, strong) BLBackgroundLayer *bgLayer;
@property (nonatomic, strong) BLSpriteLayer *spriteLayer;
@property (nonatomic, strong) BLUILayer *uiLayer;

@end

@implementation BLGameplayScene


- (id)init{
    
    if (self = [super init]){
        
        // Play background music
        [[SimpleAudioEngine sharedEngine] playEffect:@"flute_intro.wav"];
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
    [[BLHighScoreManager sharedManager] updateHighScoreWithScore:self.currentScore];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[BLGameOverLayer sceneWithScore:self.currentScore]]];
}

- (void)dealloc{
    // Make sure to clean up all box2D objects when GameScene is deallocated
    [[GB2Engine sharedInstance] deleteAllObjects];
    [super dealloc];
}

@end
