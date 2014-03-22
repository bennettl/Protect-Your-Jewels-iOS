//
//  PYJGameplayScene.mm
//  Protect Your Jewels
//
//  Created by Bennett Lee on 2/21/14.
//  Copyright 2014 ITP382RBBM. All rights reserved.
//

#import "PYJGameplayScene.h"
#import "PYJUILayer.h"
#import "PYJSpriteLayer.h"
#import "PYJGameOverLayer.h"
#import "SimpleAudioEngine.h"
#import "GB2Engine.h"
#import "PYJHighScoreManager.h"
#import "PYJFlashLayer.h"
#import "PYJThemeManager.h"
#import "PYJPauseLayer.h"
#import "PYJMainMenuLayer.h"

@interface PYJGameplayScene()

@property (nonatomic, strong) PYJFlashLayer *flashLayer;
@property (nonatomic, strong) PYJBGLayer *bgLayer;
@property (nonatomic, strong) PYJSpriteLayer *spriteLayer;
@property (nonatomic, strong) PYJUILayer *uiLayer;
@property (nonatomic, strong) PYJPauseLayer *pauseLayer;

@end

@implementation PYJGameplayScene

- (id)init{
    
    if (self = [super init]){
        
        // Initalization
        _score          = 0;
        _lives          = 3;
        
        // Play background music
        [[SimpleAudioEngine sharedEngine] playEffect:@"flute_intro.wav"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mountain-wind.wav" loop:YES];
        
        // Create layers and add sa children
        _flashLayer     = [PYJFlashLayer node];
        _uiLayer        = [PYJUILayer node];
        _spriteLayer    = [PYJSpriteLayer node];
        _pauseLayer     = [PYJPauseLayer node];
        _bgLayer        = [PYJThemeManager sharedManager].background;

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
    [[PYJHighScoreManager sharedManager] updateHighScoreWithScore:self.score];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f
                                                                                 scene:[PYJGameOverLayer
                                                                        sceneWithScore:self.score]]];
}

- (void)startExit {
    self.pauseLayer.visible = NO;
    [[CCDirector sharedDirector] stopAnimation];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
    [[GB2Engine sharedInstance] resumeWorld];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[PYJMainMenuLayer node]]];
    
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
