//
//  RFCmdRequest.m
//  RFApp
//
//  Created by gouzhehua on 14-7-17.
//  Copyright (c) 2014年 skyinfo. All rights reserved.
//

#import "RFCmdRequest.h"

//static NSRunLoop *s_runLoop = nil;
//static NSString *s_runLoopMode = nil;

@interface RFCmdRequest ()
<
	NSURLConnectionDataDelegate
>
{

}

@end

@implementation RFCmdRequest
@synthesize urlConnection = _urlConnection;

//+ (void)load
//{
//	[NSThread detachNewThreadSelector:@selector(runLoopMainProc) toTarget:[RFCmdRequest class] withObject:nil];
//}
//
//+ (void)runLoopMainProc
//{
//	s_runLoop = [NSRunLoop currentRunLoop];
//	s_runLoopMode = NSDefaultRunLoopMode;
//	
//	@autoreleasepool
//	{
//		do
//		{
//			BOOL bRun = [s_runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantPast]];
//			if (!bRun)
//			{
//				[NSThread sleepForTimeInterval:0.01];
//			}
//		}
//		while (1);
//	}
//}

- (void)dealloc
{
	[self cancelConnection];
	
	SAFE_ARC_SUPER_DEALLOC();
}

- (BOOL)startConnection
{
	self.urlConnection = [[NSURLConnection alloc] initWithRequest:self.urlRequest delegate:self startImmediately:NO];
//	[_urlConnection scheduleInRunLoop:s_runLoop forMode:s_runLoopMode];
	[_urlConnection scheduleInRunLoop:kRFRunLoop forMode:kRFRunLoopMode];
	[_urlConnection start];
	[self startTimeOut];
	return YES;
}

- (void)cancelConnection
{
	[self stopTimeOut];
	if (_urlConnection != nil)
	{
//		[_urlConnection unscheduleFromRunLoop:s_runLoop forMode:s_runLoopMode];
		[_urlConnection unscheduleFromRunLoop:kRFRunLoop forMode:kRFRunLoopMode];
		[_urlConnection cancel];
		self.urlConnection = nil;
	}
}

#pragma mark async net

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	[self resetTimeOut];
	self.sendBytes = totalBytesWritten;
	self.totalSendBytes = totalBytesExpectedToWrite;
	[self callbackUploading];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self resetTimeOut];
	[self.cmdResult.buffer appendData:data];
	self.receiveBytes += data.length;
	self.totalReceiveBytes = self.cmdResult.contentLength;
	[self callbackDownloading];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self stopTimeOut];
	
    NSLog(@"cmd:%@\nerror:%@", self.cmdName, error);
	
	[self callbackFailed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[self stopTimeOut];
	
	// 写入缓存
	[self writeToCache:self.cmdResult.buffer];
	
	// 回调
	self.cmdResult.isFinish = YES;
	[self callbackFinish];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[self resetTimeOut];
	
	if ([response isKindOfClass:[NSHTTPURLResponse class]])
	{
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		
		// StatusCode
		self.cmdResult.statusCode = httpResponse.statusCode;
		
		// 重定向，忽略
		if ([self.cmdResult isStatusCodeRedirect])
		{
			return;
		}
		
		// 非成功，服务器错误
		if (![self.cmdResult isStatusCodeSuccess])
		{
			[connection cancel];
			
			NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Server returned status code %ld", (long)(self.cmdResult.statusCode)] forKey:NSLocalizedDescriptionKey];
			NSError *statusError = [NSError errorWithDomain:@"Error" code:self.cmdResult.statusCode userInfo:errorInfo];
			[self connection:connection didFailWithError:statusError];
			return;
		}
		
		// 处理其他header值
		[self.cmdResult proccessHTTPResponseHeaders:httpResponse];
		
		// 检查缓存有效性
		if ([self canUseCache])
		{
			[connection cancel];
			[self stopTimeOut];
			
			[self callbackFinishWithCache];
			return;
		}
	}
}

- (NSURLRequest*)connection:(NSURLConnection*)connection willSendRequest:(NSURLRequest*)request redirectResponse:(NSURLResponse*)response
{
	[self resetTimeOut];
	
	// 更新当前的URL
	self.cmdResult.finalURL = request.URL;
	
	// 检查重定向Request的header(重定向时可能发生header丢失)
	NSURLRequest* nextRequest = request;
	BOOL isResetHeader = NO;
	for (NSString* header in [self.urlRequest allHTTPHeaderFields])
	{
		NSString* value = [[request allHTTPHeaderFields] objectForKey:header];
		if (value == nil)
		{
			isResetHeader = YES;
			break;
		}
	}
	
	// header丢失
	if (isResetHeader)
	{
		NSMutableURLRequest* tmpRequest = [nextRequest mutableCopy];
		for (NSString* header in [self.urlRequest allHTTPHeaderFields])
		{
			NSString* value = [[self.urlRequest allHTTPHeaderFields] objectForKey:header];
			if (value != nil)
			{
				[tmpRequest setValue:value forHTTPHeaderField:header];
			}
		}
		nextRequest = SAFE_ARC_AUTORELEASE(tmpRequest);
	}
	
	return nextRequest;
}

@end
