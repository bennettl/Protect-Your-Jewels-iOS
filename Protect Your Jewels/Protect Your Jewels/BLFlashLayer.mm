//
//  BLFlashLayer.mm
//  Protect Your Jewels
//
//  Created by Bennett Lee on 2/28/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "BLFlashLayer.h"
#import "GB2Engine.h"

#define FLASH_TIME 0.05f

@implementation BLFlashLayer

// Flashes red
- (void)flashLivesLost{
    self.color = ccc3(186, 50, 40);
    CCFadeIn *fadeInAction = [CCFadeIn actionWithDuration:FLASH_TIME];
    CCFadeOut *fadeOutAction = [CCFadeOut actionWithDuration:FLASH_TIME];
    
    [self runAction:[CCSequence actions:fadeInAction, fadeOutAction, nil]];
}

// Pauses the world, flashes whie color, and calls [BLGameplayScene startGameOver] when animation finishes
- (void)flashGameOver{
    self.color = ccc3(255, 255, 255);
    CCFadeIn *fadeInAction = [CCFadeIn actionWithDuration:FLASH_TIME];
    CCFadeOut *fadeOutAction = [CCFadeOut actionWithDuration:FLASH_TIME];
    CCCallFunc *callFuncAction = [CCCallFunc actionWithTarget:self.parent selector:@selector(startGameOver)];
    CCDelayTime *delayTimeAction = [CCDelayTime actionWithDuration:1.5f];
    
    [self runAction:[CCSequence actions:fadeInAction, fadeOutAction, delayTimeAction, callFuncAction, nil]];

}


@end
