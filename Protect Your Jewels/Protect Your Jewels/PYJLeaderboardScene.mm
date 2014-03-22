//
//  PYJLeaderboardScene.mm
//  Operation: Protect Your Jewels
//
//  Created by Ryan Stack on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJLeaderboardScene.h"
#import "PYJMainMenuLayer.h"
#import "PYJHighScoreManager.h"
#import "PYJBGLayer.h"
#import "PYJThemeManager.h"

@interface PYJLeaderboardScene()
@end

@implementation PYJLeaderboardScene

-(id) init
{
	if( (self=[super init]) )
	{
		CGSize size = [[CCDirector sharedDirector] winSize];
		
        PYJBGLayer *background = [[PYJThemeManager sharedManager] background];
        
		[self addChild: background z:-1];
		
        // Create menu items
        [CCMenuItemFont setFontSize:23];
        [CCMenuItemFont setFontName:FONT_NAME];

		// Back Menu
		CCMenuItem *backMenuItem = [CCMenuItemFont itemWithString:@"Back" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[PYJMainMenuLayer node]]];
		}];
        backMenuItem.color = ccBLACK;
        CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem, nil];
        [backMenu alignItemsVerticallyWithPadding:10];
        [backMenu setPosition:ccp(30, size.height-30)];
        [self addChild:backMenu];
        
        // High scores
        // Grab high scores from PYJHighScoreManager
        NSMutableString *highScoresString = [[[NSMutableString alloc] init] autorelease];
        NSArray *highScores = [[PYJHighScoreManager sharedManager] highScores];
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
	[super dealloc];
}

@end
