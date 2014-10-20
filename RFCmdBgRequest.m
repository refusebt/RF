//
//  RFCmdBgRequest.m
//  RFApp
//
//  Created by gouzhehua on 14-7-10.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFCmdBgRequest.h"
#import "RFKit.h"
#import "RFStorageKit.h"

@interface RFCmdBgRequest ()
<
	NSURLSessionTaskDelegate
	, NSURLSessionDownloadDelegate
	, NSURLSessionDataDelegate
>
{

}

- (NSString *)generateIdentifier;

@end

@implementation RFCmdBgRequest
@synthesize urlSession = _urlSession;
@synthesize task = _task;
@synthesize tmpFilePath = _tmpFilePath;

- (void)dealloc
{
	[self cancelConnection];
	SAFE_ARC_RELEASE(_tmpFilePath);
	
	SAFE_ARC_SUPER_DEALLOC();
}

- (BOOL)startConnection
{
	NSString *identifier = [self generateIdentifier];
	NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration backgroundSessionConfiguration:identifier];
	self.urlSession = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:nil];
	if (self.fileDatas.count == 0)
	{
		self.task = [_urlSession downloadTaskWithRequest:self.urlRequest];
	}
	else
	{
		self.tmpFilePath = [RFStorageKit tmpPathWithDirectory:nil file:identifier];
		[self.urlRequest.HTTPBody writeToFile:_tmpFilePath atomically:YES];
		self.task = [_urlSession uploadTaskWithRequest:self.urlRequest fromFile:[NSURL fileURLWithPath:_tmpFilePath]];
	}
	[_task resume];
	
	[self startTimeOut];
	return YES;
}

- (void)cancelConnection
{
	[self stopTimeOut];
	if (_task != nil)
	{
		[_task cancel];
		self.task = nil;
	}
	self.urlSession = nil;
}

#pragma mark - inner

- (NSString *)generateIdentifier
{
	return [NSString stringWithFormat:@"%@_%lf", [RFKit bundleIdentifier], [NSDate timeIntervalSinceReferenceDate]];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
	NSLog(@"URLSession didBecomeInvalidWithError:%@", error);
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
	NSString *identifier = session.configuration.identifier;
	NSLog(@"URLSessionDidFinishEventsForBackgroundURLSession:%@", identifier);
	void (^completionHandler)() = [RFCmdBgRequest completionHandlerWithIdentifier:identifier];
	completionHandler();
	[RFCmdBgRequest removeCompletionHandlerWithIdentifier:identifier];
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
			  task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent
	totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
	[self resetTimeOut];
	self.sendBytes = totalBytesSent;
	self.totalSendBytes = totalBytesExpectedToSend;
	[self callbackUploading];
}

- (void)URLSession:(NSURLSession *)session
			  task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
	// 上传下载，成功失败都会进入
	[self stopTimeOut];
	
	if ([task.response isKindOfClass:[NSHTTPURLResponse class]])
	{
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)task.response;
		self.cmdResult.statusCode = httpResponse.statusCode;
		[self.cmdResult proccessHTTPResponseHeaders:httpResponse];
	}
	
	if (error == nil && [self.cmdResult isStatusCodeSuccess])
	{
		NSLog(@"URLSession didComplete");
		
		self.cmdResult.isFinish = YES;
		[self callbackFinish];
	}
	else
	{
		if ([RFKit isDebugMode])
		{
			NSLog(@"URLSession didCompleteWithError:%@\n%@", error, [self.cmdResult responseString]);
		}
		
		[self callbackFailed];
	}
	
	if (![NSString isEmpty:_tmpFilePath])
	{
		[RFStorageKit removeWithPath:_tmpFilePath];
	}
}

#pragma makr - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
	  downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
	[self resetTimeOut];
	
	if ([downloadTask.response isKindOfClass:[NSHTTPURLResponse class]])
	{
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)downloadTask.response;
		self.cmdResult.statusCode = httpResponse.statusCode;
	}
	
	// 只有下载
	// 写入缓存
	if (location != nil)
	{
		self.cmdResult.buffer = [NSMutableData dataWithContentsOfURL:location];
		if ([self.cmdResult isStatusCodeSuccess])
		{
			[self writeToCache:self.cmdResult.buffer];
		}
	}
}

- (void)URLSession:(NSURLSession *)session
	  downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
	[self resetTimeOut];
	self.receiveBytes = totalBytesWritten;
	self.totalReceiveBytes = totalBytesExpectedToWrite;
	[self callbackDownloading];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
	NSLog(@"URLSession didResumeAtOffset");
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
	didReceiveData:(NSData *)data
{
	// 只有上传，然后接收
	[self resetTimeOut];
	[self.cmdResult.buffer appendData:data];
}

#pragma identifierToCompletionHandlerDict;

static NSMutableDictionary *identifierToCompletionHandlerDict = nil;

+ (void)setCompletionHandler:(void (^)())completionHandler forIdentifier:(NSString *)identifier
{
	if (identifierToCompletionHandlerDict == nil)
	{
		identifierToCompletionHandlerDict = [[NSMutableDictionary alloc] init];
	}
	
	if (completionHandler != nil && ![NSString isEmpty:identifier])
	{
		[identifierToCompletionHandlerDict setObject:completionHandler forKey:identifier];
	}
}

+ (void (^)())completionHandlerWithIdentifier:(NSString *)identifier
{
	if (identifierToCompletionHandlerDict != nil)
	{
		return [identifierToCompletionHandlerDict objectForKey:identifier];
	}
	return nil;
}

+ (void)removeCompletionHandlerWithIdentifier:(NSString *)identifier
{
	if (identifierToCompletionHandlerDict != nil)
	{
		[identifierToCompletionHandlerDict removeObjectForKey:identifier];
	}
}

@end
