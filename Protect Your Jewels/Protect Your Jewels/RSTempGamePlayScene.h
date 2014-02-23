//
//  RSTempGamePlayScene.h
//  Operation: Protect Your Jewels
//
//  Created by Ryan Stack on 2/22/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "CCScene.h"

@interface RSTempGamePlayScene : CCScene

@property(nonatomic) int roundNumber;
@property(nonatomic) int waveNumber;

-(void) update:(ccTime)dt;

@end
