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
    NSNumber *highScore = [NSNumber numberWithInt:self.currentScore];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"userHighScores"]) {
        NSMutableArray *highScoresArray = [[NSMutableArray alloc] init];
        
        [highScoresArray addObject:highScore];
        
        [defaults setObject:highScoresArray forKey:@"userHighScores"];
    }
    else {
        NSArray *highScoresArray = [defaults objectForKey:@"userHighScores"];
        NSMutableArray *highScoresArrayTemp = [highScoresArray mutableCopy];
        for(int i = 0; i <highScoresArrayTemp.count; i++) {
            if(i > 9) break;
            if([highScore intValue] >= [[highScoresArrayTemp objectAtIndex:i] intValue]) {
                [highScoresArrayTemp insertObject:highScore atIndex:i];
                if (highScoresArrayTemp.count > 10) {
                    [highScoresArrayTemp removeLastObject];
                }
                break;
                
            }
            if(i == highScoresArrayTemp.count - 1 && highScoresArrayTemp.count != 10) {
                [highScoresArrayTemp addObject:highScore];
                break;
                
            }
        }
        // Replace defaults with highScoresMutableArray
        [defaults setObject:highScoresMutableArray forKey:@"userHighScores"];
    }
    [defaults synchronize];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[RSGameOver sceneWithScore:self.currentScore]]];
}

- (void)dealloc{
    // Make sure to clean up all box2D objects when GameScene is deallocated
    [[GB2Engine sharedInstance] deleteAllObjects];
    [super dealloc];
}

@end
