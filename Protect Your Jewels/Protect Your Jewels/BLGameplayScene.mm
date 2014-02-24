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
#import "GB2Engine.h"

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
    [self updateHighScore];
    
    // Transition to GameOverScene
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[RSGameOver sceneWithScore:self.currentScore]]];
}

// Updates and save high score to NSUserDefaults
- (void)updateHighScore{
    
    NSNumber *highScore         = [NSNumber numberWithInt:self.currentScore];
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    
    // If userHighScores doesn't exist in NSUserDefaults, create one
    if (![defaults objectForKey:@"userHighScores"]) {
        NSMutableArray *highScoresArray = [[NSMutableArray alloc] init];
        
        [highScoresArray addObject:highScore];
        
        [defaults setObject:highScoresArray forKey:@"userHighScores"];
    } else {
        NSArray *highScoresArray            = [defaults objectForKey:@"userHighScores"];
        NSMutableArray *highScoresMutableArray = [highScoresArray mutableCopy];
        
        // Loop through highScoresMutableArray and if highscore is greater, replace object
        for (int i = 0; i < highScoresMutableArray.count; i++) {
            if (i > 9) break;
            if (highScore > [highScoresMutableArray objectAtIndex:i]) {
                [highScoresMutableArray insertObject:highScore atIndex:i];
                break;
            }
        }
        // Replace defaults with highScoresMutableArray
        [defaults setObject:highScoresMutableArray forKey:@"userHighScores"];
    }
    
    [defaults synchronize]; // save new NSUserDefaults
}

- (void)dealloc{
    // Make sure to clean up all box2D objects when GameScene is deallocated
    [[GB2Engine sharedInstance] deleteAllObjects];
    [super dealloc];
}

@end
