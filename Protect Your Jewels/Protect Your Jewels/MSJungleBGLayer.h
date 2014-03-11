//
//  MSJungleBGLayer.h
//  Protect Your Jewels
//
//  Created by Megan Sullivan on 3/8/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "CCLayer.h"
#import "MSBGLayer.h"

@interface MSJungleBGLayer : MSBGLayer

-(void) update:(ccTime)dt;
-(void) spawnFrontCloud;
-(void) spawnBackCloud;

@end
