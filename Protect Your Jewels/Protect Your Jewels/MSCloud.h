//
//  MSCloud.h
//  Protect Your Jewels
//
//  Created by Megan Sullivan on 2/23/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "CCSprite.h"
#include "cocos2d.h"

@interface MSCloud : CCSprite
{
    int m_Velocity;
}

@property int velocity;

-(id) initFrontCloud:(int)xPos;
-(id) initBackCloud:(int)xPos;

@end
