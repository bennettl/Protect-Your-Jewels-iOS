//
//  PYJFacebookManager.m
//  Protect Your Jewels
//
//  Created by Megan Sullivan on 3/31/14.
//  Copyright (c) 2014 ITP382RBBM. All rights reserved.
//

#import "PYJFacebookManager.h"

@implementation PYJFacebookManager

+ (instancetype)sharedManager {
    static PYJFacebookManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

// A helper function for parsing URL parameters returned by the Feed Dialog
- (NSDictionary *)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

// https://developers.facebook.com/docs/ios/share#status
- (int)shareScore:(int)score
{
    // Check to see if the Facebook app is installed
    
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:@"https://developers.facebook.com/apps/306599482821288/dashboard/"];
    params.name = @"Protect Your Jewels";
    params.caption = @"***NOT SURE WHERE CAPTION GOES***";
    //params.picture = [NSURL URLWithString:@"UPLOAD ICON TO SOME URL"];
    params.description = [NSString stringWithFormat:@"I scored %d in Protect Your Jewels!", score];
    
    // If Facebook app is installed, use share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if (error) {
                                              // Error occurred, need to handle error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                          }
                                          else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
    }
    // Otherwise, fall back to feed dialog (doesn't require native FB for iOS app)
    else {
        // Present feed dialog (web-based dialog)
        // Has to ask user for Facebook credentials to verify their identity
        
        // Put together dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Sharing Tutorial", @"name",
                                       @"***NOT SURE WHERE CAPTION GOES***", @"caption",
                                       params.description, @"description",
                                       @"https://developers.facebook.com/apps/306599482821288/dashboard/", @"link",
                                       @"", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Error occurred, so handle error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                      }
                                                      else {
                                                          if (result == FBWebDialogResultDialogCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          }
                                                          else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                              }
                                                              else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat:@"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
    
    return 0;
}

@end
