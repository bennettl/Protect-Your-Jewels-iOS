//
//  BLBackGroundLayer.h
//  GamePlay
//
//  Created by Bennett Lee on 2/21/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "cocos2d.h"
#import "MSBGLayer.h"

@interface MSMountainBGLayer : MSBGLayer

-(void) update:(ccTime)dt;
-(void) spawnFrontCloud;
-(void) spawnBackCloud;

@end
