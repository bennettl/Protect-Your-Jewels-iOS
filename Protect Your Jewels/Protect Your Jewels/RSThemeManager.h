//
//  RSThemeManager.h
//  Protect Your Jewels
//
//  Created by Ryan Stack on 3/8/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSThemeManager : NSObject

@property(nonatomic)BOOL isMountain;
@property(nonatomic)BOOL isJungle;
@property(nonatomic)BOOL isGladiator;

// Singleton
+ (instancetype)sharedManager;

- (void)setThemeJungle;
- (void)setThemeMountain;
- (void)setThemeGladiator;


@end
