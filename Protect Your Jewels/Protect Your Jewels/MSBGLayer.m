//
//  MSBGLayer.m
//  Protect Your Jewels
//
//  Created by Megan Sullivan on 3/8/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "MSBGLayer.h"
#import "MSCloud.h"

@implementation MSBGLayer

// Init function adds background
- (id)initWithTheme:(NSString *)theme {
    if (self = [super init]){
        
        m_Theme = theme;
        
        NSString *foreground_name = [NSString stringWithFormat:@"%@_FG_iPhone5.png", theme];
        
        // Add mountains in foreground
        CCSprite *mountainSprite = [CCSprite spriteWithFile:foreground_name];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        mountainSprite.position = ccp(winSize.width/2, winSize.height/2);
        
        [self addChild:mountainSprite z:2];
        
        // Initialize arrays for clouds, and populate with initial clouds
        m_FrontCloudArray = [[NSMutableArray alloc] init];
        m_BackCloudArray = [[NSMutableArray alloc] init];
        
        // Add initial front clouds
        MSCloud *new_Cloud = [[[MSCloud alloc] initFrontCloud:(3*winSize.width/2) withTheme:m_Theme] autorelease];
        [m_FrontCloudArray addObject:new_Cloud];
        [self addChild:new_Cloud z:1];
        
        new_Cloud = [[[MSCloud alloc] initFrontCloud:(winSize.width/2) withTheme:m_Theme] autorelease];
        [m_FrontCloudArray addObject:new_Cloud];
        [self addChild:new_Cloud z:1];
        
        new_Cloud = [[[MSCloud alloc] initFrontCloud:(-winSize.width/2) withTheme:m_Theme] autorelease];
        [m_FrontCloudArray addObject:new_Cloud];
        [self addChild:new_Cloud z:1];
        
        // Find width of front cloud image
        m_FrontCloudWidth = new_Cloud.contentSize.width;
        
        
        // Add initial back clouds
        new_Cloud = [[[MSCloud alloc] initBackCloud:(3*winSize.width/2) withTheme:m_Theme] autorelease];
        [m_BackCloudArray addObject:new_Cloud];
        [self addChild:new_Cloud z:0];
        
        new_Cloud = [[[MSCloud alloc] initBackCloud:(winSize.width/2) withTheme:m_Theme] autorelease];
        [m_BackCloudArray addObject:new_Cloud];
        [self addChild:new_Cloud z:0];
        
        new_Cloud = [[[MSCloud alloc] initBackCloud:(-winSize.width/2) withTheme:m_Theme] autorelease];
        [m_BackCloudArray addObject:new_Cloud];
        [self addChild:new_Cloud z:0];
        
        // Find the width of back cloud images
        m_BackCloudWidth = new_Cloud.contentSize.width;
        
        [self scheduleUpdate];
        
    }
    return self;
}

- (void) update:(ccTime)dt
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // Use these to check whether we need to change cloud arrays
    //  (since can't edit array while iterating over it)
    BOOL spawnFront = NO;
    BOOL spawnBack = NO;
    MSCloud* toRemove = nil;
    
    for (MSCloud *m_Cloud in m_FrontCloudArray)
    {
        CGPoint prevPosition = m_Cloud.position;
        [m_Cloud update:dt];
        
        // If cloud is completely off screen, remove it from the array
        if (m_Cloud.position.x > winSize.width + m_FrontCloudWidth) {
            toRemove = m_Cloud;
        }
        
        // If cloud has crossed spawn point, create a new cloud
        CGFloat spawnPoint = winSize.width - m_FrontCloudWidth/2;
        if (prevPosition.x < spawnPoint && m_Cloud.position.x > spawnPoint)
        {
            spawnFront = YES;
        }
    }
    
    // Check if there is a front cloud to be removed
    if (toRemove != nil) {
        [self removeChild:toRemove cleanup:YES];
        [m_FrontCloudArray removeObject:toRemove];
        toRemove = nil;
    }
    
    // Check if a front cloud needs to be spawned
    if (spawnFront){
        [self scheduleOnce:@selector(spawnFrontCloud) delay:0.0f];
    }
    
    for (MSCloud *m_Cloud in m_BackCloudArray)
    {
        CGPoint prevPosition = m_Cloud.position;
        [m_Cloud update:dt];
        
        // If cloud is completely off screen, remove it from the array
        if (m_Cloud.position.x > winSize.width + m_BackCloudWidth) {
            toRemove = m_Cloud;
        }
        
        // If cloud has crossed spawn point, create a new cloud
        CGFloat spawnPoint = winSize.width - m_BackCloudWidth/2;
        if (prevPosition.x < spawnPoint && m_Cloud.position.x > spawnPoint)
        {
            spawnBack = YES;
        }
    }
    
    // Check if there is a back cloud to be removed
    if (toRemove != nil) {
        [self removeChild:toRemove cleanup:YES];
        [m_BackCloudArray removeObject:toRemove];
        toRemove = nil;
    }
    
    // Check if a back cloud needs to be spawned
    if (spawnBack){
        [self scheduleOnce:@selector(spawnBackCloud) delay:0.0f];
    }
}

-(void) spawnFrontCloud
{
    MSCloud *new_Cloud = [[[MSCloud alloc] initFrontCloud:(-m_FrontCloudWidth/2) withTheme:m_Theme] autorelease];
    [m_FrontCloudArray addObject:new_Cloud];
    [self addChild:new_Cloud z:1];
}


-(void) spawnBackCloud
{
    MSCloud *new_Cloud = [[[MSCloud alloc] initBackCloud:(-m_BackCloudWidth/2) withTheme:m_Theme] autorelease];
    [m_BackCloudArray addObject:new_Cloud];
    [self addChild:new_Cloud z:0];
}

@end