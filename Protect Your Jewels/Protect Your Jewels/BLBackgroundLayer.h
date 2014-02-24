//
//  BLBackGroundLayer.h
//  GamePlay
//
//  Created by Bennett Lee on 2/21/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "cocos2d.h"

@interface BLBackgroundLayer : CCLayer {
    NSMutableArray *m_FrontCloudArray;
    NSMutableArray *m_BackCloudArray;
    
    int m_FrontCloudWidth;
    int m_BackCloudWidth;
}

-(void) update:(ccTime)dt;
-(void) spawnFrontCloud;
-(void) spawnBackCloud;

@end
