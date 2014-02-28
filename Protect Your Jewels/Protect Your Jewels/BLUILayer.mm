//
//  BLUILayer.m
//  GamePlay
//
//  Created by Bennett Lee on 2/21/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLUILayer.h"


@interface BLUILayer(){
    CCLabelTTF *_livesLabel;
    CCLabelTTF *_scoreLabel;
}
@end

@implementation BLUILayer

- (id)init{
    
    if (self = [super init]){
        // Initialize labels
        _livesLabel             = [CCLabelTTF labelWithString:@"Lives: 3" fontName:FONT_NAME fontSize:20];
        _scoreLabel             = [CCLabelTTF labelWithString:@"Score: 0" fontName:FONT_NAME fontSize:20];
        
        // Set positions
        CGSize s                = [[CCDirector sharedDirector] winSize];
        _livesLabel.position    = ccp(_scoreLabel.contentSize.width/2 + 40, 25);
        _scoreLabel.position    = ccp(s.width - _scoreLabel.contentSize.width/2 - 40, 25);

        // Add to layer
        [self addChild:_livesLabel];
        [self addChild:_scoreLabel];
    }
    return self;
}

- (void)updateLivesLabelWithLives:(int)lives{
    _livesLabel.string = [NSString stringWithFormat:@"Lives %i", lives];
}
- (void)updateScoreLabelWithScore:(int)score{
    _scoreLabel.string = [NSString stringWithFormat:@"Score: %i", score];
}
@end
