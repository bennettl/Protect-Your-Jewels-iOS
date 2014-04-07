//
//  PYJFacebookManager.h
//  Protect Your Jewels
//
//  Created by Megan Sullivan on 3/31/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PYJFacebookManager : NSObject

// PYJFacebookManager handles any FB sharing

// Singleton
+ (instancetype)sharedManager;

- (NSDictionary *)parseURLParams:(NSString *)query;
- (int)shareScore:(int)score;

@end
