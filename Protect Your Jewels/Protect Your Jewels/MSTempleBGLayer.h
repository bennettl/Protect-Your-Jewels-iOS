//
//  MSTempleBGLayer.h
//  Protect Your Jewels
//
//  Created by Megan Sullivan on 3/9/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "MSBGLayer.h"

@interface MSTempleBGLayer : MSBGLayer

-(void) update:(ccTime)dt;
-(void) spawnFrontCloud;
-(void) spawnBackCloud;

@end
