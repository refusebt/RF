//
//  RFAppDelegate.m
//  RFApp
//
//  Created by gouzhehua on 14-7-31.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFAppDelegate.h"
#import "RFCmdBgRequest.h"

@implementation RFAppDelegate

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler
{
	NSLog(@"application:handleEventsForBackgroundURLSession:completionHandler:%@",identifier);
	[RFCmdBgRequest setCompletionHandler:completionHandler forIdentifier:identifier];
}

@end
