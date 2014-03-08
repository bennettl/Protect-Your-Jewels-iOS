//
//  MSBGLayer.h
//  Protect Your Jewels
//
//  Created by Megan Sullivan on 3/8/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "cocos2d.h"

@interface MSBGLayer : CCLayer {
    NSMutableArray *m_FrontCloudArray;
    NSMutableArray *m_BackCloudArray;
    
    int m_FrontCloudWidth;
    int m_BackCloudWidth;
    
    NSString *m_Theme;
}

-(id)initWithTheme:(NSString *)theme;
-(void) update:(ccTime)dt;
-(void) spawnFrontCloud;
-(void) spawnBackCloud;

@end
