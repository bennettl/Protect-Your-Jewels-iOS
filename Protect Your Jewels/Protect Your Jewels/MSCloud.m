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

-(id) initFrontCloud:(int)xPos withTheme:(NSString *)theme
{
    NSString *filename = [NSString stringWithFormat:@"%@_Clouds_front_full.png", theme];
    if (self = [super initWithFile:filename])
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CGFloat cloudHeight = -1;
        if ([theme isEqualToString:@"Mountain"]) {
            cloudHeight = 0.6 * winSize.height;
        }
        else if ([theme isEqualToString:@"Jungle"]) {
            cloudHeight = 0.57 * winSize.height;
        }
        else {
            cloudHeight = 0.55 * winSize.height;
        }
        
        self.position = ccp((CGFloat)xPos, cloudHeight);
        m_Velocity = 15;
    }
    return self;
}

-(id) initBackCloud:(int)xPos withTheme:(NSString *)theme
{
    NSString *filename = [NSString stringWithFormat:@"%@_Clouds_back_full.png", theme];
    if (self = [super initWithFile:filename]);
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];

        CGFloat cloudHeight = -1;
        if ([theme isEqualToString:@"Mountain"]) {
            cloudHeight = 0.81 * winSize.height;
        }
        else if ([theme isEqualToString:@"Jungle"]) {
            cloudHeight = 0.80 * winSize.height;
        }
        else {
            cloudHeight = 0.75 * winSize.height;
        }
        
        self.position = ccp(xPos, cloudHeight);
        m_Velocity = 8;
    }
    return self;
}

-(void) update:(ccTime)dt
{
    // Move cloud to the right
    self.position = ccpAdd(self.position, ccpMult(ccp(1,0), m_Velocity * dt));
}



@end
