//
//  GB2Jewel.m
//  GamePlay
//
//  Created by Bennett Lee on 2/20/14.
//  Copyright 2014 Bennett Lee. All rights reserved.
//

#import "BLJewelSprite.h"

@implementation BLJewelSprite

+ (BLJewelSprite *)jewelSprite{
    return [[[self alloc] initWithStaticBody:@"jewel" spriteFrameName:@"jewel.png"] autorelease];
}

- (id)initWithSpriteLayer:(BLSpriteLayer *)sl{
    if (self = [super initWithDynamicBody:@"jewel"
                          spriteFrameName:@"jewel.png"]){
        
        spriteLayer = sl;  // Store the sprite layer
        
        // Set jewel to collide with everything but the player control
        for (b2Fixture *f = self.body->GetFixtureList(); f; f = f->GetNext()){
            b2Filter jf = f->GetFilterData();
            jf.categoryBits = 0x0004;
            jf.maskBits = 0xFFFF ^ 0x0008;
            jf.groupIndex = -1;
            f->SetFilterData(jf);
        }
        
        //b2Filter jf = self.body->GetFixtureList()[0].GetFilterData();
       // jf.categoryBits = 0x0004;
        //jf.maskBits = 0xFFFF ^ 0x0008;
        //jf.groupIndex = -1;
        //self.body->GetFixtureList()[0].SetFilterData(jf);
    }
    return self;
}

@end

