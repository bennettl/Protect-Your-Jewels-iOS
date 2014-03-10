//
//  MSTempleBGLayer.m
//  Protect Your Jewels
//
//  Created by Megan Sullivan on 3/9/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "MSTempleBGLayer.h"

@implementation MSTempleBGLayer

// Init function adds background
- (id)init{
    
    self = [super initWithTheme:@"Temple"];
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
