//
//  RFCmdConfig.m
//  RFApp
//
//  Created by gouzhehua on 14-7-11.
//  Copyright (c) 2014年 skyinfo. All rights reserved.
//

#import "RFCmdConfig.h"
#import "RFKit.h"
#import "RFStorageKit.h"
#import "SVProgressHUD.h"

@implementation RFCmdConfig
@synthesize boundary = _boundary;
@synthesize isShowLoading = _isShowLoading;

- (id)init
{
	self = [super init];
    if (self)
    {
		self.boundary = @"UploadBoundary";
    }
    return self;
}

- (void)dealloc
{
	SAFE_ARC_RELEASE(_boundary);
	
	SAFE_ARC_SUPER_DEALLOC();
}

- (NSString *)cachePathWithUrl:(NSString *)anUrl args:(NSDictionary *)anArgs
{
	NSString *ext = [[anUrl lastPathComponent] pathExtension];
	NSString *cacheKey = [self cacheKeyWithUrl:anUrl args:anArgs];
	NSString *cachefile = [NSString stringWithFormat:@"%@.%@", cacheKey, ext];
	NSString *cachePath = [RFStorageKit cachePathWithDirectory:kRFStorageDirCache file:cachefile];
	return cachePath;
}

- (NSString *)cacheKeyWithUrl:(NSString *)anUrl args:(NSDictionary *)anArgs
{
	NSString *ret = @"";
	NSMutableString *buffer = [[NSMutableString alloc] initWithString:anUrl];
	{
		NSArray* keyList = [[anArgs allKeys] sortedArrayUsingSelector:@selector(compare:)];
		for (NSString *key in keyList)
		{
			NSString *value = [anArgs objectForKey:key];
			[buffer appendFormat:@"%@=%@", key, value];
		}
		ret = [buffer toMD5];
	}
	SAFE_ARC_RELEASE(buffer);
	return ret;
}

- (void)modifyArgsWithCmdRequest:(RFCmdBaseRequest *)aCmdRequest
{
	
}

- (void)modifyUrlRequestWithCmdRequest:(RFCmdBaseRequest *)aCmdRequest
{
	
}

- (void)showLoading:(NSString *)aMsg cmdRequest:(RFCmdBaseRequest *)aCmdRequest
{
	self.isShowLoading = YES;
//	dispatch_async(dispatch_get_main_queue(), ^(){
//		[SVProgressHUD showWithStatus:aMsg maskType:SVProgressHUDMaskTypeNone];
//	});
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)showMessage:(NSString *)aMsg cmdRequest:(RFCmdBaseRequest *)aCmdRequest
{
	dispatch_async(dispatch_get_main_queue(), ^(){
		[SVProgressHUD showImage:nil status:aMsg];
	});
}

- (void)showError:(NSString *)aMsg cmdRequest:(RFCmdBaseRequest *)aCmdRequest
{
	dispatch_async(dispatch_get_main_queue(), ^(){
		[SVProgressHUD showErrorWithStatus:aMsg];
	});
}

- (void)hideLoading:(RFCmdBaseRequest *)aCmdRequest
{
	if (self.isShowLoading)
	{
//		dispatch_async(dispatch_get_main_queue(), ^(){
//			[NSObject cancelPreviousPerformRequestsWithTarget:[SVProgressHUD class] selector:@selector(dismiss) object:nil];
//			[[SVProgressHUD class] performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
//		});
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
	self.isShowLoading = NO;
}

+ (RFCmdConfig *)defaultConfig
{
	return SAFE_ARC_AUTORELEASE([[RFCmdConfig alloc] init]);
}

@end
