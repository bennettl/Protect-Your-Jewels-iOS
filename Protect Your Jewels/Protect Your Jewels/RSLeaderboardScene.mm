//
//  RSLeaderboardScene.m
//  Operation: Protect Your Jewels
//
//  Created by Ryan Stack on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "RSLeaderboardScene.h"
#import "RSMainMenuLayer.h"
#import "BLHighScoreManager.h"
#import "MSBGLayer.h"
#import "RSThemeManager.h"

@interface RSLeaderboardScene()
@end

@implementation RSLeaderboardScene

-(id) init
{
	if( (self=[super init]) )
	{
        
		CGSize size = [[CCDirector sharedDirector] winSize];
		
//		CCSprite *background    = [CCSprite spriteWithFile:@"game_background.png"];
        // Create menu logo and backgr
        //ound
		//CCSprite *background    = [CCSprite spriteWithFile:@"game_background.png"];
        MSBGLayer *background = [[RSThemeManager sharedManager] background];
        
        // Center the background
		//if (size.height > size.width) {
        //    background.position = ccp(size.height/2, size.width/2);
        //} else {
        //    background.position = ccp(size.width/2, size.height/2);
        //}
        
		[self addChild: background z:-1];
		
        // Create menu items
        [CCMenuItemFont setFontSize:23];
        [CCMenuItemFont setFontName:FONT_NAME];

		// Back Menu
		CCMenuItem *backMenuItem = [CCMenuItemFont itemWithString:@"Back" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[RSMainMenuLayer node]]];
		}];
        backMenuItem.color = ccBLACK;
        CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem, nil];
        [backMenu alignItemsVerticallyWithPadding:10];
        [backMenu setPosition:ccp(30, size.height-30)];
        [self addChild:backMenu];
        
        // High scores
        // Grab high scores from BLHighScoreManager
        NSMutableString *highScoresString = [[[NSMutableString alloc] init] autorelease];
        NSArray *highScores = [[BLHighScoreManager sharedManager] highScores];
        if ([highScores count] != 0) {
            for (int i = 0; i < highScores.count; i++) {
                [highScoresString appendFormat:@"%i. %i\n", i + 1, [[highScores objectAtIndex:i] intValue]];
            }
        }
        
        CCLabelTTF *scores = [CCLabelTTF labelWithString:highScoresString fontName:FONT_NAME fontSize:17];
        scores.color = ccBLACK;
        [scores setPosition:ccp(size.width / 2, size.height/2)];
        [self addChild:scores];
    }
	return self;
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
