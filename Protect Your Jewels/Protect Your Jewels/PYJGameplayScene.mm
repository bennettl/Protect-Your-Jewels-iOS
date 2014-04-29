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
#import "PYJShieldSprite.h"

@interface PYJGameplayScene()


@property (nonatomic, strong) PYJFlashLayer *flashLayer;
@property (nonatomic, strong) PYJBGLayer *bgLayer;
@property (nonatomic, strong) PYJSpriteLayer *spriteLayer;
@property (nonatomic, strong) PYJUILayer *uiLayer;
@property (nonatomic, strong) PYJPauseLayer *pauseLayer;


@end

@implementation PYJGameplayScene
static BOOL classicMode;

- (id)init{
    if (self = [super init]){
        
        // Initalization
        _score          = 0;
        _lives          = 3;
        _shieldTicker   = 0;
        
        // Play background music
        [[SimpleAudioEngine sharedEngine] playEffect:@"flute_intro.wav"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mountain-wind.wav" loop:YES];
        
        // Create layers and add sa children
        _flashLayer     = [PYJFlashLayer node];
        _spriteLayer    = [PYJSpriteLayer node];
        _pauseLayer     = [PYJPauseLayer node];
        _bgLayer        = [PYJThemeManager sharedManager].background;

        // Add layers
        [self addChild:_pauseLayer z:100];
        [self addChild:_flashLayer z:5];
        [self addChild:_spriteLayer z:3];
        [self addChild:_bgLayer z:2];
        
        _pauseLayer.visible = NO;
        _state = KShieldDeactivated;
        
        if(!classicMode){
            _uiLayer        = [PYJUILayer nodeWithIsClassic:NO];
            [self scheduleUpdate];
        }
        else{
            _uiLayer        = [PYJUILayer nodeWithIsClassic:YES];
        }
        [self addChild:_uiLayer z:4];
    }
    return self;
}

+(id)nodeWithIsClassic:(BOOL)classic{
    classicMode = classic;
    return [[[self alloc] init] autorelease];
}

#pragma Listner

// Update the score count and label
-(void)incrementScoreByValue:(int)value{
    if(!classicMode){
        self.score = self.score + (2*value);
    }
    else{
        self.score = self.score + value;
    }
    [self.uiLayer updateScoreLabelWithScore:self.score];
    self.shieldTicker = self.shieldTicker + value;
    if(self.shieldTicker >= 30 && self.state == KShieldDeactivated) {
        self.state = kShieldActivated;
        [self scheduleOnce:@selector(deployShield) delay:0];
        
    }
}

- (void)deployShield {
    [self.spriteLayer deployShield];
    [self scheduleOnce:@selector(removeShield) delay:7];
}


- (void)removeShield {
    NSLog(@"removing shield from gameplay");
    self.shieldTicker = 0;
    self.state = KShieldDeactivated;
}

// Update the lives count and decided whether or not it's game over
-(void)decrementLives{
    if(classicMode){
        self.lives--;
    
        // Game is over when user reaches zero life
        if (self.lives == 0){
            // Stop enemies from spawning, pause world physics, stop background music, play sound effect, and flash

            [[GB2Engine sharedInstance] pauseWorld];
            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
            [[SimpleAudioEngine sharedEngine] playEffect:@"drumroll-end.wav"];
            [self.flashLayer flashGameOver];
            [self.spriteLayer stopGame];
        } else {
            // Flash red and update score label
            [self.flashLayer flashLivesLost];
            [self.uiLayer updateLivesLabelWithLives:self.lives];
        }
    }
    else{
        self.score=self.score-2;
        [self.uiLayer updateScoreLabelWithScore:self.score];
    }
}

// Switches to game over scene
-(void)startGameOver{
    [[PYJHighScoreManager sharedManager] updateHighScoreWithScore:self.score];
    [[PYJHighScoreManager sharedManager] updateAchievementsForTheme:[PYJThemeManager sharedManager].theme andScore:self.score];
    [[PYJHighScoreManager sharedManager] updateInGameCurrency:self.score];
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
    [self.spriteLayer stopGame];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[PYJMainMenuLayer node]]];
    
}
- (void)pauseGame {
    self.pauseLayer.visible = YES;
    [[CCDirector sharedDirector] pause];
    [[GB2Engine sharedInstance] pauseWorld];
}

- (void)restartGame {
    self.pauseLayer.visible = NO;
    [[CCDirector sharedDirector] stopAnimation];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
    [[GB2Engine sharedInstance] resumeWorld];
    [[GB2Engine sharedInstance] deleteAllObjects];
    PYJGameplayScene *scene = [PYJGameplayScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:scene]];
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

// Update loop
-(void)update:(ccTime)delta{
    // end game after 60 seconds
    if([self.uiLayer getTime] == 0){
        [[GB2Engine sharedInstance] pauseWorld];
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] playEffect:@"drumroll-end.wav"];
        [self.uiLayer endTimer];
        [self.flashLayer flashGameOver];
        [self.spriteLayer stopGame];
        [self unscheduleUpdate];
    }
}

- (void)dealloc{
    // Make sure to clean up all box2D objects when GameScene is deallocated
    [super dealloc];
}

@end
