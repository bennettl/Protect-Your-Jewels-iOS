//
//  PYJCloud.h
//  Protect Your Jewels
//
//  Created by Megan Sullivan on 2/23/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "CCSprite.h"
#include "cocos2d.h"

@interface PYJCloud : CCSprite
{
    int m_Velocity;
}

@property int velocity;

-(id) initFrontCloud:(int)xPos withTheme:(NSString *)theme;
-(id) initBackCloud:(int)xPos withTheme:(NSString *)theme;

@end
