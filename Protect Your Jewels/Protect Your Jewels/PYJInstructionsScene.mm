//
//  PYJInstructionsScene.mm
//  Protect Your Jewels
//
//  Created by Brian Quock on 3/10/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJInstructionsScene.h"
#import "PYJMainMenuLayer.h"
#import "PYJThemeManager.h"
#import "cocos2d.h"
#import "PYJBGLayer.h"
#import "PYJBoxNode.h"
#import "PYJTutorialLayer.h"


@interface PYJInstructionsScene(){
    CCSpriteBatchNode *objectLayer;
}

@property (nonatomic, strong) PYJBGLayer *bgLayer;
@property (nonatomic, strong) PYJTutorialLayer *tutorialLayer;

@end

@implementation PYJInstructionsScene

-(id) init
{
	if( (self=[super init]) )
	{
        _tutorialLayer = [PYJTutorialLayer node];
        [self addChild:_tutorialLayer];
    }
    return self;
}

- (void)decrementLives{
}
- (void)incrementScoreByValue:(int)value{
}

- (void) dealloc
{
    [super dealloc];
}

@end