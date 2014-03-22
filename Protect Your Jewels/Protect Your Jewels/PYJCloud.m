//
//  PYJCloud.m
//  Protect Your Jewels
//
//  Created by Megan Sullivan on 2/23/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJCloud.h"

@implementation PYJCloud

@synthesize velocity = m_Velocity;

// Create the front cloud
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

// Create the back cloud
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
