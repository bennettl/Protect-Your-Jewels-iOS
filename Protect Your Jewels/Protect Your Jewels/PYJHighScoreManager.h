//
//  PYJHighScoreManager.h
//  Protect Your Jewels
//
//  Created by Bennett Lee on 2/25/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYJThemeManager.h"

// BLHighScoreManager will take care of saving and retrieving high scores

@interface PYJHighScoreManager : NSObject

// Singleton
+ (instancetype)sharedManager;

// Update high scores list with score
- (void)updateHighScoreWithScore:(int)score;
// Get an NSArray of highscores
- (NSArray *)highScores;
// Get the local highest score
- (int)highestScore;
// Update In Game Currency
- (void)updateInGameCurrency:(int)score;
// Get in game currency
- (NSInteger)userCurrency;
// Update achievement list
- (void)updateAchievementsForTheme:(Theme)theme andScore:(int)score;


@end
