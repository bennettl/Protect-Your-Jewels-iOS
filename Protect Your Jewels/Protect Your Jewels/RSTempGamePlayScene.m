//
//  RSTempGamePlayScene.m
//  Operation: Protect Your Jewels
//
//  Created by Ryan Stack on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "RSTempGamePlayScene.h"
#import "RSGameOver.h"
#import "cocos2d.h"

@interface RSTempGamePlayScene()

enum GameState {
    RoundBreak = 0,
    Wave,
    WaveBreak,
    GameOver
};
@property (nonatomic) enum GameState gameState;

@end

@implementation RSTempGamePlayScene

- (id) init
{
	if(self=[super init]) {
        
        _roundNumber = 0;
        _waveNumber = 0;
        
        [self scheduleUpdate];
        [self startRoundBreak];
        
        
	}
	return self;
}


- (void)update:(ccTime)dt {
    //add more logic to determine state
    if(self.gameState == Wave) {
        [self startWaveBreak];
    }
    
}

- (void)startRoundBreak {
    self.gameState = RoundBreak;
    self.roundNumber++;
    self.waveNumber = 0;
    [self scheduleOnce:@selector(startWave) delay:5];
    
}

- (void)startWave {
    self.gameState = Wave;
    self.waveNumber++;
}

- (void)startWaveBreak {
    self.gameState = WaveBreak;
    //logic to determine end of wave
    if(YES) {
        [self endWave];
    }
}

- (void)endWave {
    if(self.waveNumber == 5) {
        [self startRoundBreak];
    } else {
        [self scheduleOnce:@selector(startWave) delay:3];
    }
}

- (void)startGameOver {
    [self scheduleOnce:@selector(exitScene) delay:3];
}

- (void)exitScene {
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionFade transitionWithDuration:0.5
                                        scene:[RSGameOver scene]]];
}

@end
