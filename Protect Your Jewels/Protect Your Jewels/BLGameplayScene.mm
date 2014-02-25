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
    [self saveHighScore];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[RSGameOver sceneWithScore:self.currentScore]]];
}

// Save high scores to NSUserDefaults
- (void)saveHighScore {
    NSNumber *highScore         = [NSNumber numberWithInt:self.currentScore];
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
  
    // If NSUserdefaults for key userHighScores doesn't exist, create one
    if (![defaults objectForKey:@"userHighScores"]) {
        NSMutableArray *highScoresMutable = [[NSMutableArray alloc] init];
        [highScoresMutable addObject:highScore];
        [defaults setObject:highScoresMutable forKey:@"userHighScores"];
    } else {
        // Create a mutable version of highscores and modify it
        NSArray *highScores                 = [defaults objectForKey:@"userHighScores"];
        NSMutableArray *highScoresMutable   = [highScores mutableCopy];
      
        for (int i = 0; i < highScoresMutable.count; i++) {
            if(i > 9) break;
            
            // If high score is greater, than insert it at index i
            if ([highScore intValue] >= [[highScoresMutable objectAtIndex:i] intValue]) {
                [highScoresMutable insertObject:highScore atIndex:i];
                // Make sure there are only 10 high scores
                if (highScoresMutable.count > 10) {
                    [highScoresMutable removeLastObject];
                }
                break;
            }
            
            if (i == highScoresMutable.count - 1 && highScoresMutable.count != 10) {
                [highScoresMutable addObject:highScore];
                break;
            }
        }
        // Replace defaults with highScoresMutableArray
        [defaults setObject:highScoresMutable forKey:@"userHighScores"];

    }
    [defaults synchronize];
}

- (void)dealloc{
    // Make sure to clean up all box2D objects when GameScene is deallocated
    [[GB2Engine sharedInstance] deleteAllObjects];
    [super dealloc];
}

@end
