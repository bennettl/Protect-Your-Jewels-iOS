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
#import "MSMountainBGLayer.h"
#import "MSJungleBGLayer.h"
#import "MSTempleBGLayer.h"
#import "BLGameOverLayer.h"
#import "SimpleAudioEngine.h"
#import "GB2Engine.h"
#import "BLHighScoreManager.h"
#import "BLFlashLayer.h"
#import "RSThemeManager.h"
#import "RSPauseLayer.h"
#import "RSMainMenuLayer.h"

@interface BLGameplayScene()

@property (nonatomic, strong) BLFlashLayer *flashLayer;
@property (nonatomic, strong) MSBGLayer *bgLayer;
@property (nonatomic, strong) BLSpriteLayer *spriteLayer;
@property (nonatomic, strong) BLUILayer *uiLayer;
@property (nonatomic, strong) RSPauseLayer *pauseLayer;

@end

@implementation BLGameplayScene

- (id)init{
    
    if (self = [super init]){
        
        // Initalization
        _score          = 0;
        _lives          = 3;
        
        // Play background music
        [[SimpleAudioEngine sharedEngine] playEffect:@"flute_intro.wav"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mountain-wind.wav" loop:YES];
        
        // Create layers and add sa children
        _flashLayer     = [BLFlashLayer node];
        _uiLayer        = [BLUILayer node];
        _spriteLayer    = [BLSpriteLayer node];
        _pauseLayer     = [RSPauseLayer node];
        _bgLayer        = [RSThemeManager sharedManager].background;
        
        // Choose background layer based on theme
        if ([RSThemeManager sharedManager].theme == MOUNTAIN){
            self.bgLayer    = [MSMountainBGLayer node];
        }
        else if ([RSThemeManager sharedManager].theme == JUNGLE){
            self.bgLayer    = [MSJungleBGLayer node];
        }
        else {
            self.bgLayer    = [MSTempleBGLayer node];
            if ([RSThemeManager sharedManager].theme != GLADIATOR) { // If no theme set yet, set Gladiator by default
                [RSThemeManager sharedManager].theme = GLADIATOR;
            }
        }

        // Add layers
        [self addChild:_pauseLayer z:100];
        [self addChild:_flashLayer z:5];
        [self addChild:_uiLayer z:4];
        [self addChild:_spriteLayer z:3];
        [self addChild:_bgLayer z:2];
        
        _pauseLayer.visible = NO;
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
                                                                                 scene:[BLGameOverLayer
                                                                        sceneWithScore:self.score]]];
}

- (void)startExit {
    self.pauseLayer.visible = NO;
    [[CCDirector sharedDirector] stopAnimation];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
    [[GB2Engine sharedInstance] resumeWorld];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[RSMainMenuLayer node]]];
    
}
- (void)pauseGame {
    self.pauseLayer.visible = YES;
    [[CCDirector sharedDirector] pause];
    [[GB2Engine sharedInstance] pauseWorld];
}

- (void)resumeGame {
    self.pauseLayer.visible = NO;
    [[CCDirector sharedDirector] stopAnimation];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
    [[GB2Engine sharedInstance] resumeWorld];
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
