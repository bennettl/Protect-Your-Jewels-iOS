//
//  RSThemeManager.m
//  Protect Your Jewels
//
//  Created by Ryan Stack on 3/8/14.
//  Copyright (c) 2014 Bennett Lee. All rights reserved.
//

#import "RSThemeManager.h"

@implementation RSThemeManager

+ (instancetype)sharedManager {
    static RSThemeManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        _isGladiator = NO;
        _isJungle = NO;
        _isMountain = YES;
    }
    return self;
}

- (void)setThemeJungle {
    self.isJungle = YES;
    self.isMountain = NO;
    self.isGladiator = NO;
}

- (void)setThemeMountain {
    self.isJungle = NO;
    self.isMountain = YES;
    self.isGladiator = NO;
}

- (void)setThemeGladiator {
    self.isJungle = NO;
    self.isMountain = NO;
    self.isGladiator = YES;
}

@end
