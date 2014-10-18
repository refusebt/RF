//
//  RFRequestWork.m
//  XiaoXunTong
//
//  Created by gouzhehua on 14-8-4.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFRequestWork.h"
#import "RFNetworkKit.h"
#import "RFCmdRequest.h"

@implementation RFRequestWork
@synthesize workRequest = _workRequest;
@synthesize requestType = _requestType;
@synthesize isDownlodingNotify = _isDownlodingNotify;
@synthesize isUploadingNotify = _isUploadingNotify;
@synthesize downloadingBlock = _downloadingBlock;
@synthesize uploadingBlock = _uploadingBlock;
@synthesize resultCode = _resultCode;
@synthesize resultMsg = _resultMsg;
@synthesize resultDesc = _resultDesc;

- (id)init
{
	self = [super init];
    if (self)
    {
		_isDownlodingNotify = NO;
		_isUploadingNotify = NO;
    }
    return self;
}

- (id)initWithUrl:(NSString *)anUrl args:(NSDictionary *)anArgs requestType:(RFCmdRequestType)aRequestType
{
	self = [super init];
    if (self)
    {
		_workRequest = [[RFCmdRequest alloc] initWithCmd:self.workName url:anUrl args:anArgs delegate:self config:nil];
		_requestType = aRequestType;
		_isDownlodingNotify = NO;
		_isUploadingNotify = NO;
    }
    return self;
}

- (void)main
{
	[_workRequest startWithType:_requestType];
}

- (void)dealloc
{
	if (_workRequest != nil)
	{
		[_workRequest cancel];
		SAFE_ARC_RELEASE(_workRequest);
		_workRequest = nil;
	}
	
	self.downloadingBlock = nil;
	self.uploadingBlock = nil;
	
	SAFE_ARC_RELEASE(_resultMsg);
	SAFE_ARC_RELEASE(_resultDesc);
	
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

- (void)cancelProc
{
	[self rfCancelWorks];
	
	if (_workRequest != nil)
	{
		[_workRequest cancel];
		_workRequest = nil;
	}
	
	[super cancelProc];
}

- (void)downloadingNotify
{
	if (_downloadingBlock != nil)
	{
		dispatch_async(dispatch_get_main_queue(), ^(){
			self.downloadingBlock(self);
		});
	}
	
	if (_isDownlodingNotify)
	{
		[self notify];
	}
}

- (void)uploadingNotify
{
	if (_uploadingBlock != nil)
	{
		dispatch_async(dispatch_get_main_queue(), ^(){
			self.uploadingBlock(self);
		});
	}
	
	if (_isUploadingNotify)
	{
		[self notify];
	}
}

- (void)onCmdRequestFinish:(RFCmdBaseRequest *)aRequest
{
	[self enterSuccess];
}

- (void)onCmdRequestFailed:(RFCmdBaseRequest *)aRequest
{
	[self enterFailed];
}

- (void)onCmdRequestUploading:(RFCmdBaseRequest *)aRequest
{
	[self uploadingNotify];
}

- (void)onCmdRequestDownloading:(RFCmdBaseRequest *)aRequest
{
	[self downloadingNotify];
}

@end
