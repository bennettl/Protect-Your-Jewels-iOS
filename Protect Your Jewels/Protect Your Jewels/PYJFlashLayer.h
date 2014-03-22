//
//  PYJFlashLayer.h
//  Protect Your Jewels
//
//  Created by Bennett Lee on 2/28/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// Layer will provide a white flash when game is over

@interface PYJFlashLayer : CCLayerColor <CCRGBAProtocol>

- (void)flashLivesLost;
- (void)flashGameOver;

@end
