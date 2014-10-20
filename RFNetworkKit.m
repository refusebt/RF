//
//  RFNetworkKit.m
//  RF
//
//  Created by gouzhehua on 14-6-26.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFNetworkKit.h"

@interface RFNetworkKit (inner)
- (void)handleReachabilityChangedNotification:(NSNotification *)note;
@end

@implementation RFNetworkKit
@synthesize delegate;

- (id)init
{
	self = [super init];
    if (self)
    {
		delegate = nil;
		canUse3G = YES;
		canUseWifi = YES;
		has3G = YES;
		hasWifi = YES;
		isOnlyUseOnWifi = NO;
		lastNetworkStatus = ReachableViaWiFi;
    }
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
	
	SAFE_ARC_SUPER_DEALLOC();
}

+ (RFNetworkKit *)shared
{
	static RFNetworkKit *s_networkKit = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		s_networkKit = [[RFNetworkKit alloc] init];
	});
	
	return s_networkKit;
}

// 注册检查网络
- (void)startCheck
{
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleReachabilityChangedNotification:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [reach startNotifier];
}

// 是否连接网络(3G设置、WIFI设置参与影响)
- (BOOL)isConnect
{
	if (isOnlyUseOnWifi)
	{
		return hasWifi;
	}
	else
	{
		return (has3G || hasWifi);
	}
}

- (BOOL)isOffline
{
	if (!canUse3G && !canUseWifi)
		return YES;
	else
		return NO;
}

- (NetworkStatus)lastNetworkStatus
{
	return lastNetworkStatus;
}

- (void)use3G:(BOOL)bUse
{
	canUse3G = bUse;
}

- (BOOL)canUse3G
{
	return canUse3G;
}

- (void)useWifi:(BOOL)bUse
{
	canUseWifi = bUse;
}

- (BOOL)canUseWifi
{
	return canUseWifi;
}

- (BOOL)hasNetWork
{
	if (has3G || hasWifi)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

- (BOOL)has3G
{
	return has3G;
}

- (BOOL)hasWifi
{
	return hasWifi;
}

- (void)setIsOnlyUseOnWifi:(BOOL)bValue
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:bValue] forKey:@"NekworkKitIsOnlyUseOnWifi"];
    [[NSUserDefaults standardUserDefaults] synchronize];
	isOnlyUseOnWifi = bValue;
}

- (BOOL)isOnlyUseOnWifi
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"NekworkKitIsOnlyUseOnWifi"];
    isOnlyUseOnWifi = (num != nil) ? [num boolValue] : NO;
	return isOnlyUseOnWifi;
}

- (void)handleReachabilityChangedNotification:(NSNotification *)note
{
	Reachability * curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	NetworkStatus currentStatus = [curReach currentReachabilityStatus];
	if (currentStatus == NotReachable)
	{
		has3G = NO;
		hasWifi = NO;
	}
	else if (currentStatus == ReachableViaWiFi)
	{
		has3G = NO;
		hasWifi = YES;
	}
	else if (currentStatus == ReachableViaWWAN)
	{
		has3G = YES;
		hasWifi = NO;
	}

    NSLog(@"reachabilityChanged -> has3G:%d , hasWifi:%d", has3G, hasWifi);
	
	if (delegate != nil)
	{
		[delegate onNetworkStatusChanged:self];
	}
	else
	{
		if (![self isConnect])
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Note", nil)
															message:NSLocalizedString(@"No Network", nil)
														   delegate:nil
												  cancelButtonTitle:nil
												  otherButtonTitles:nil];
			[alert show];
			SAFE_ARC_AUTORELEASE(alert);
		}
	}

	lastNetworkStatus = currentStatus;
}

@end
