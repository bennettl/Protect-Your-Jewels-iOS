//
//  BLUILayer.m
//  GamePlay
//
//  Created by Bennett Lee on 2/21/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLUILayer.h"

@interface BLUILayer(){
    CCLabelTTF *_label;
}
@end

@implementation BLUILayer

- (id)init{
    if (self = [super init]){
        CGSize s = [[CCDirector sharedDirector] winSize];
       
        self.currentScore   = 0;
        _label              = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i", self.currentScore] fontName:@"Marker Felt" fontSize:20];
        
        _label.position = ccp(s.width - _label.contentSize.width/2 - 40,
                              25);
        [self addChild:_label];
        
    }
    return self;
}

@end
