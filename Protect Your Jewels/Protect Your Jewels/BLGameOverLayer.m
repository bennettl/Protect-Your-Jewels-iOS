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

@interface BLGameOverLayer(){
    int _beginScore;
    int _finalScore;
    CCLabelTTF *scoreLabel;
}

@end

#define LOW_SCORE 20 // use to play different audio files
#define FONT_NAME @"AngryBirds-Regular"

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
        
		CCSprite *background = [CCSprite spriteWithFile:@"game_background.png"];
        
        // Make sure background is center
		if(size.height > size.width) {
            background.position = ccp(size.height/2, size.width/2);
        } else {
            background.position = ccp(size.width/2, size.height/2);
        }
        
		[self addChild: background z:-1];
		
        // Create logo
        CCLabelTTF *gameoverlabel = [CCLabelTTF labelWithString:@"Game Over" fontName:FONT_NAME fontSize:80];
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
    if (_beginScore == 0){
        // Play drum roll audio
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
    // Finish drumroll
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playEffect:@"drumroll-end.wav"];
    
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
