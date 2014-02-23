//
//  RSGameOver.m
//  Operation: Protect Your Jewels
//
//  Created by Ryan Stack on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "RSGameOver.h"
#import "BLGameplayScene.h"
#import "RSMainMenuLayer.h"

// Use to play different audio files
typedef enum {
    kLow,
    kMedium,
    kHigh
} scoreType;


@interface RSGameOver(){
    int _beginScore;
    int _finalScore;
    CCLabelTTF *scoreLabel;
}

@end

#define FONT_NAME @"angrybirds-regular"

@implementation RSGameOver

// Create a scene with the user's current score
+ (CCScene *)sceneWithScore:(int)score {
    CCScene *scene      = [CCScene node];
	RSGameOver *layer   = [[RSGameOver alloc] initWithScore:score];
	[scene addChild: layer];
	return scene;
}

-(id) initWithScore:(int)score
{
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
    _beginScore++;
    
    // Stop the scheduling when final score reaches begin score
    if (_beginScore <= _finalScore){
        scoreLabel.string = [NSString stringWithFormat:@"Score: %i", _beginScore];
    } else{
        [self unschedule:@selector(incrementScoreLabel:)];
    }
    
}


@end
