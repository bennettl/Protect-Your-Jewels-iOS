//
//  MSJungleBGLayer.m
//  Protect Your Jewels
//
//  Created by Megan Sullivan on 3/8/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "MSJungleBGLayer.h"

@implementation MSJungleBGLayer

// Init function adds background
- (id)init{
    
    self = [super initWithTheme:@"Jungle"];
    return self;
    
}

- (void) update:(ccTime)dt
{
    [super update:dt];
}

-(void) spawnFrontCloud
{
    [super spawnFrontCloud];
}


-(void) spawnBackCloud
{
    [super spawnBackCloud];
}

@end
