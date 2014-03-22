//
//  PYJUILayer.mm
//  GamePlay
//
//  Created by Bennett Lee on 2/21/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJUILayer.h"
#import "GB2Engine.h"


@interface PYJUILayer(){
    CCLabelTTF *_livesLabel;
    CCLabelTTF *_scoreLabel;
    CCMenuItem *_pauseLabel;
}
@end

@implementation PYJUILayer

- (id)init{
    
    if (self = [super init]){
        CGSize size = [[CCDirector sharedDirector] winSize];

        
        // Initialize labels
        _livesLabel             = [CCLabelTTF labelWithString:@"Lives: 3" fontName:FONT_NAME fontSize:20];
        _scoreLabel             = [CCLabelTTF labelWithString:@"Score: 0" fontName:FONT_NAME fontSize:20];
        _pauseLabel             = [CCMenuItemFont itemWithString:@"I I" target:self selector:@selector(pauseMenu)];
        _pauseLabel.color = ccBLACK;
        
        CCMenu *menu = [CCMenu menuWithItems:_pauseLabel, nil];
        [menu setPosition:ccp(size.width - 40, size.height - 40)];
        
        // Set positions
        CGSize s                = [[CCDirector sharedDirector] winSize];
        _livesLabel.position    = ccp(_scoreLabel.contentSize.width/2 + 40, 25);
        _scoreLabel.position    = ccp(s.width - _scoreLabel.contentSize.width/2 - 40, 25);

        // Add to layer
        [self addChild:_livesLabel];
        [self addChild:_scoreLabel];
        [self addChild:menu];
    }
    return self;
}

- (void)updateLivesLabelWithLives:(int)lives{
    _livesLabel.string = [NSString stringWithFormat:@"Lives %i", lives];
}
- (void)updateScoreLabelWithScore:(int)score{
    _scoreLabel.string = [NSString stringWithFormat:@"Score: %i", score];
}

- (void)pauseMenu {
    if([self.parent respondsToSelector:@selector(pauseGame)]) {
        [self.parent performSelector:@selector(pauseGame)];
        NSLog(@"pause menu called from uilayer");
    }
}
@end
