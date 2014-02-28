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
#import "BLFlashLayer.h"

@interface BLGameplayScene()

@property (nonatomic, strong) BLFlashLayer *flashLayer;
@property (nonatomic, strong) BLBackgroundLayer *bgLayer;
@property (nonatomic, strong) BLSpriteLayer *spriteLayer;
@property (nonatomic, strong) BLUILayer *uiLayer;

@end

@implementation BLGameplayScene

- (id)init{
    
    if (self = [super init]){
        
        // Initalization
        self.score          = 0;
        self.lives          = 3;
        
        // Play background music
        [[SimpleAudioEngine sharedEngine] playEffect:@"flute_intro.wav"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mountain-wind.wav" loop:YES];
        
        // Create layers and add sa children
        self.flashLayer     = [BLFlashLayer node];
        self.uiLayer        = [BLUILayer node];
        self.spriteLayer    = [BLSpriteLayer node];
        self.bgLayer        = [BLBackgroundLayer node];
        
        [self addChild:self.flashLayer z:5];
        [self addChild:self.uiLayer z:4];
        [self addChild:self.spriteLayer z:3];
        [self addChild:self.bgLayer z:2];
    }
    
    return self;
}

#pragma Listner

// Update the score conunt and label
-(void)incrementScore{
    self.score++;
    [self.uiLayer updateScoreLabelWithScore:self.score];
}

// Update the lives count and decided whether or not it's game over
-(void)decrementLives{
    self.lives--;
    
    // Game is over when user reaches zero life
    if (self.lives == 0){
        // Stop enemies from spawning, pause world physics, stop background music, play sound effect, and flash
        [self.spriteLayer unschedule:@selector(spawnEnemyAtRadomLocation)];
        [[GB2Engine sharedInstance] pauseWorld];
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] playEffect:@"drumroll-end.wav"];
        [self.flashLayer flashGameOver];
    } else {
        // Flash red and update score label
        [self.flashLayer flashLivesLost];
        [self.uiLayer updateLivesLabelWithLives:self.lives];
    }
}

// Switches to game over scene
-(void)startGameOver{
    [[BLHighScoreManager sharedManager] updateHighScoreWithScore:self.score];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f
                                                                                 scene:[BLGameOverLayer sceneWithScore:self.score]]];
}

// When GameplayScenes exits the "stage"
- (void)onExit{
    [super onExit];
    // Resume world physics
    [[GB2Engine sharedInstance] resumeWorld];
}

- (void)dealloc{
    // Make sure to clean up all box2D objects when GameScene is deallocated
    [[GB2Engine sharedInstance] deleteAllObjects];
    [super dealloc];
}

@end
