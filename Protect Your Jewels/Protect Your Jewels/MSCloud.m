//
//  MSCloud.m
//  Protect Your Jewels
//
//  Created by Megan Sullivan on 2/23/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "MSCloud.h"

@implementation MSCloud

@synthesize velocity = m_Velocity;

-(id) initFrontCloud:(int)xPos
{
    if (self = [super initWithFile:@"Clouds_front_full.png"])
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        self.position = ccp((CGFloat)xPos, (CGFloat)0.6 * winSize.height);
        m_Velocity = 15;
    }
    return self;
}

-(id) initBackCloud:(int)xPos
{
    if (self = [super initWithFile:@"Clouds_back_full.png"]);
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.position = ccp(xPos, 0.81 * winSize.height);
        m_Velocity = 5;
    }
    return self;
}

-(void) update:(ccTime)dt
{
    // Move cloud to the right
    self.position = ccpAdd(self.position, ccpMult(ccp(1,0), m_Velocity * dt));
}



@end
