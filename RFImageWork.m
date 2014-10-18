//
//  RFImageWork.m
//  XiaoXunTong
//
//  Created by gouzhehua on 14-8-11.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFImageWork.h"
#import "RFNetworkKit.h"
#import "RFCmdRequest.h"

@implementation RFImageWork
@synthesize workRequest = _workRequest;
@synthesize downloadingBlock = _downloadingBlock;
@synthesize image = _image;

- (id)init
{
	self = [super init];
    if (self)
    {
    }
    return self;
}

- (id)initWithUrl:(NSString *)anUrl
{
	self = [super init];
    if (self)
    {
		_workRequest = [[RFCmdRequest alloc] initWithCmd:self.workName url:anUrl args:nil delegate:self config:nil];
		_workRequest.cacheType = RFCmdRequestCacheTypeCacheFirst;
    }
    return self;
}

- (void)startRelyOn:(id)obj
{
	if (obj == nil)
	{
		[[RFWorkMgr sharedImageMgr] addWork:self];
	}
	else
	{
		[obj rfRunImageWork:self];
	}
}

- (void)dealloc
{
	if (_workRequest != nil)
	{
		[_workRequest cancel];
		SAFE_ARC_RELEASE(_workRequest);
		_workRequest = nil;
	}
	
    SAFE_ARC_SUPER_DEALLOC();
}

- (void)start
{
	if ([[RFNetworkKit shared] isConnect])
	{
		[super start];
	}
	else
	{
		dispatch_async(dispatch_get_main_queue(), ^(){[SVProgressHUD showErrorWithStatus:kRFCmdMsgNoNet];});
		[self setWorkFinish];
	}
}

- (void)main
{
	[_workRequest startWithType:RFCmdRequestTypeGet];
}

- (void)cancelProc
{
	if (_workRequest != nil)
	{
		[_workRequest cancel];
		_workRequest = nil;
	}
	
	[super cancelProc];
}

- (void)onCmdRequestFinish:(RFCmdBaseRequest *)aRequest
{
	self.image = [UIImage imageWithData:aRequest.cmdResult.buffer];
	
	[self enterSuccess];
}

- (void)onCmdRequestFailed:(RFCmdBaseRequest *)aRequest
{
	[self enterFailed];
}

- (void)onCmdRequestDownloading:(RFCmdBaseRequest *)aRequest
{
	if (_downloadingBlock != nil)
	{
		dispatch_async(dispatch_get_main_queue(), ^(){
			self.downloadingBlock(self);
		});
	}
}

@end
