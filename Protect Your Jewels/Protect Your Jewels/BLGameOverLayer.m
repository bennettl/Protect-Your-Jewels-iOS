//
//  RSGameOver.m
//  Operation: Protect Your Jewels
//
//  Created by Ryan Stack on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "BLGameOverLayer.h"
#import "BLGameplayScene.h"
#import "RSMainMenuLayer.h"
#import "SimpleAudioEngine.h"
#import "BLHighScoreManager.h"
#import "RSThemeManager.h"
#import "MSBGLayer.h"
#import "MSMountainBGLayer.h"
#import "MSJungleBGLayer.h"

@interface BLGameOverLayer(){
    int _beginScore;
    int _finalScore;
    CCLabelTTF *scoreLabel;
}

@end

#define DRUMROLL_SCORE 20 // only play drumroll effect if score is above this counter
#define LOW_SCORE 20 // Audience will laugh at low scores

@implementation BLGameOverLayer

// Create a scene with the user's current score
+ (CCScene *)sceneWithScore:(int)score {
    CCScene *scene      = [CCScene node];
	BLGameOverLayer *layer   = [[BLGameOverLayer alloc] initWithScore:score];
	[scene addChild: layer];
	return scene;
}

-(id) initWithScore:(int)score{
	if( (self=[super init])){
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		MSBGLayer *background;
        // Create menu logo and background
        if ([[RSThemeManager sharedManager] isMountain]) {
            background = [MSMountainBGLayer node];
        } else if ([[RSThemeManager sharedManager] isJungle]) {
            background = [MSJungleBGLayer node];
        } else if([[RSThemeManager sharedManager] isGladiator]) {
            background = [MSMountainBGLayer node];
        }
        
		[self addChild: background z:-1];
		
        // Create logo
        CCLabelTTF *gameoverlabel = [CCLabelTTF labelWithString:@"Game Over" fontName:FONT_NAME fontSize:80];
        gameoverlabel.color = ccBLACK;
        gameoverlabel.position = ccp(size.width/2, size.height - gameoverlabel.contentSize.height);
        [self addChild:gameoverlabel z:1];
        
        // Create score label
        _beginScore         = 0;
        _finalScore         = score;
        scoreLabel          = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i", _beginScore] fontName:FONT_NAME fontSize:28];
        scoreLabel.position = ccp(size.width/2, 160);
        [self addChild:scoreLabel z:1];
        
        // Create menu items
		[CCMenuItemFont setFontSize:23];
        [CCMenuItemFont setFontName:FONT_NAME];
		
		CCMenuItem *itemNewGame = [CCMenuItemFont itemWithString:@"Play Again" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[BLGameplayScene node]]];
		}];
        CCMenuItem *itemMainMenu = [CCMenuItemFont itemWithString:@"Back to Main Menu" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[RSMainMenuLayer node]]];
		}];
		
		CCMenu *menu = [CCMenu menuWithItems:itemNewGame, itemMainMenu, nil];
		
		[menu alignItemsVerticallyWithPadding:10];
        [menu setPosition:ccp(size.width/2, 100)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
       
        [self schedule:@selector(incrementScoreLabel:) interval:0.05f];
        
	}
	return self;
}

// Increment the score label from beginScore until finalScore
- (void)incrementScoreLabel:(ccTime)dt{
    // Play drum roll audio when the begin score is 0 and user has a high enough score (>DRUMROLL_SCORE)
    if (_beginScore == 0 && _finalScore > DRUMROLL_SCORE){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"drumroll-begin.wav" loop:YES];
    }
    
    _beginScore++;
 
    // Stop the scheduling when final score reaches begin score
    if (_beginScore <= _finalScore){
        scoreLabel.string = [NSString stringWithFormat:@"Score: %i", _beginScore];
    } else{
        [self playAudienceReactionAudio];
        [self unschedule:@selector(incrementScoreLabel:)];
    }
}

// Finish drum roll and play audiences reaction
- (void)playAudienceReactionAudio{
    // Finish drumroll if user has a high enough score (> DRUMROLL_SCORE)
    if (_finalScore > DRUMROLL_SCORE){
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] playEffect:@"drumroll-end.wav"];
    }
    
    // Play audience audio base on score
    if (_finalScore > [[BLHighScoreManager sharedManager] highestScore]){
      [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"applause-loud.wav" loop:NO];
    } else if (_finalScore > LOW_SCORE){
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"applause-medium.wav" loop:NO];
    } else{
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"applause-laugh.wav" loop:NO];
    }
}


@end
