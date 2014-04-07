//
//  PYJHighScoreManager.mm
//  Protect Your Jewels
//
//  Created by Bennett Lee on 2/25/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJHighScoreManager.h"

#define HIGH_SCORES_KEY @"userHighScores"
#define IN_GAME_CURRENCY_KEY @"userCurrency"

@interface PYJHighScoreManager(){
    NSMutableArray *_highScores;
    int _highestScore;
    int _userCurrency;
}

@end

@implementation PYJHighScoreManager

// Return a singleton
+ (instancetype)sharedManager {
    static PYJHighScoreManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init{
    if (self = [super init]){
        NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
        _highScores                 = [[defaults objectForKey:HIGH_SCORES_KEY] mutableCopy];
        _highestScore               = 0;
        _userCurrency               = 0;
        
        [defaults setInteger:_userCurrency forKey:IN_GAME_CURRENCY_KEY];

        // If highscores array exist, calculate highest score
        if (_highScores){
            for (int i = 0; i < _highScores.count; i++) {
                int currentScore = [[_highScores objectAtIndex:i] intValue];
                if (currentScore > _highestScore){
                    _highestScore = currentScore;
                }
            }
        
        }
    }

    return self;
}


// Return the highscorces array
- (NSArray *)highScores{
    return _highScores;
}

// Retrieve the local highest score
- (int)highestScore{
    return _highestScore;
}

- (NSInteger)userCurrency {
    return [[NSUserDefaults standardUserDefaults] integerForKey:IN_GAME_CURRENCY_KEY];
}

- (void)updateInGameCurrency:(int)score {
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    NSInteger userCurrency      = [defaults integerForKey:IN_GAME_CURRENCY_KEY];
    userCurrency += score;
    [defaults setInteger:userCurrency forKey:IN_GAME_CURRENCY_KEY];
    [defaults synchronize];
}


// Update high scores list with score
- (void)updateHighScoreWithScore:(int)score{
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    NSNumber *highScore         = [NSNumber numberWithInt:score];

    // If NSUserdefaults for key userHighScores doesn't exist, create one
    if (_highScores == nil) {
        NSMutableArray *highScoresMutable   = [[NSMutableArray alloc] init];
        [highScoresMutable addObject:highScore];
        [defaults setObject:highScoresMutable forKey:HIGH_SCORES_KEY];
    } else {
        // Create a mutable version of highscores and modify it
        
        for (int i = 0; i < _highScores.count; i++) {
            if(i > 9) break;
            
            // If high score is greater, than insert it at index i
            if ([highScore intValue] >= [[_highScores objectAtIndex:i] intValue]) {
               
                [_highScores insertObject:highScore atIndex:i];
               
                // Make sure there are only 10 high scores
                if (_highScores.count > 10) {
                    [_highScores removeLastObject];
                }
                break;
            }
            
            if (i == _highScores.count - 1 && _highScores.count != 10) {
                [_highScores addObject:highScore];
                break;
            }
        }
        // Replace defaults with highScoresMutableArray
        [defaults setObject:_highScores forKey:HIGH_SCORES_KEY];
    }
    // Save high scores to NSUserDefaults
    [defaults synchronize];
}
@end
