//
//  RSThemeManager.h
//  Protect Your Jewels
//
//  Created by Ryan Stack on 3/8/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSThemeManager : NSObject

// Singleton
+ (instancetype)sharedManager;

// Update high scores list with score
- (void)updateHighScoreWithScore:(int)score;
// Get an NSArray of highscores
- (NSArray *)highScores;
// Get the local highest score
- (int)highestScore;

@end
