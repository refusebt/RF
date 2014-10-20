//
//  RFCmdBaseRequest.m
//  RFApp
//
//  Created by gouzhehua on 14-7-17.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFCmdBaseRequest.h"
#import "RFKit.h"
#import "RFStorageKit.h"
#import "RFNetworkKit.h"

#define kDictKeyContentKey			@"kDictKeyContentKey"
#define kDictKeyContentFileName		@"kDictKeyContentFileName"
#define kDictKeyContentType			@"kDictKeyContentType"
#define kDictKeyContentData			@"kDictKeyContentData"

@interface RFCmdBaseRequest ()
{

}
@property (nonatomic, strong) NSTimer *timeOut;

@end

@implementation RFCmdBaseRequest
@synthesize cmdName = _cmdName;
@synthesize urlString = _urlString;
@synthesize arguments = _arguments;
@synthesize fileDatas = _fileDatas;
@synthesize cmdConfig = _cmdConfig;
@synthesize delegate = _delegate;
//@synthesize finishBlock = _finishBlock;
//@synthesize failedBlock = _failedBlock;
//@synthesize startBlock = _startBlock;
//@synthesize cancelBlock = _cancelBlock;
//@synthesize uploadingBlock = _uploadingBlock;
//@synthesize downloadingBlock = _downloadingBlock;
@synthesize cmdResult = _cmdResult;
@synthesize requestType = _requestType;
@synthesize cacheType = _cacheType;
@synthesize urlRequest = _urlRequest;
@synthesize sendBytes = _sendBytes;
@synthesize totalSendBytes = _totalSendBytes;
@synthesize receiveBytes = _receiveBytes;
@synthesize totalReceiveBytes = _totalReceiveBytes;
@synthesize timeOut = _timeOut;

- (id)initWithCmd:(NSString *)aCmd url:(NSString *)anUrl args:(NSDictionary *)anArgs delegate:(id<RFCmdRequestDelegate>)aDelegate config:(RFCmdConfig *)aConfig
{
	self = [super init];
    if (self)
    {
		self.cmdName = aCmd;
		self.urlString = anUrl;
		self.arguments = (anArgs == nil) ? [NSMutableDictionary dictionary] : anArgs;
		self.fileDatas = [NSMutableArray array];
		self.delegate = aDelegate;
		self.cmdConfig = (aConfig == nil) ? [RFCmdConfig defaultConfig] : aConfig;
		self.cmdResult = SAFE_ARC_AUTORELEASE([[RFCmdResult alloc] init]);
		self.cmdResult.cmdName = aCmd;
		self.cacheType = RFCmdRequestCacheTypeNone;
    }
    return self;
}

- (void)dealloc
{
	SAFE_ARC_RELEASE(_cmdName);
	SAFE_ARC_RELEASE(_urlString);
	SAFE_ARC_RELEASE(_arguments);
	SAFE_ARC_RELEASE(_fileDatas);
	SAFE_ARC_RELEASE(_cmdConfig);
	SAFE_ARC_RELEASE(_cmdResult);
	SAFE_ARC_RELEASE(_urlRequest);
	if (_timeOut != nil)
	{
		[_timeOut invalidate];
		SAFE_ARC_RELEASE(_timeOut);
		_timeOut = nil;
	}
	
//	self.finishBlock = nil;
//	self.failedBlock = nil;
//	self.startBlock = nil;
//	self.cancelBlock = nil;
//	self.uploadingBlock = nil;
//	self.downloadingBlock = nil;

	SAFE_ARC_SUPER_DEALLOC();
}

- (void)addKey:(NSString *)aKey data:(NSData *)aData fileName:(NSString *)aFileName contentType:(NSString *)aContentType
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	if (aKey != nil)
		[dict setObject:aKey forKey:kDictKeyContentKey];
	else
		[dict setObject:@"" forKey:kDictKeyContentKey];
	
	if (aFileName != nil)
		[dict setObject:aFileName forKey:kDictKeyContentFileName];
	else
		[dict setObject:@"" forKey:kDictKeyContentFileName];
	
	if (![NSString isEmpty:aContentType])
		[dict setObject:aContentType forKey:kDictKeyContentType];
	else
		[dict setObject:@"application/octet-stream" forKey:kDictKeyContentType];
	
	if (aData != nil)
		[dict setObject:aData forKey:kDictKeyContentData];
	else
		[dict setObject:[NSData data] forKey:kDictKeyContentData];
	
	[_fileDatas addObject:dict];
}

- (BOOL)startWithType:(RFCmdRequestType)aType
{
	NSMutableString *url = [NSMutableString stringWithString:_urlString];
		
	// 生成缓存地址
	_cmdResult.cachePath = [_cmdConfig cachePathWithUrl:_urlString args:_arguments];
	
	// 是否缓存优先
	if (_cacheType == RFCmdRequestCacheTypeCacheFirst)
	{
		if ([self callbackFinishWithCache])
		{
			return YES;
		}
	}
	
	// 无连接，读取缓存
	if (![[RFNetworkKit shared] isConnect])
	{
		[_cmdConfig showMessage:kRFCmdMsgNoNet cmdRequest:self];
		return [self callbackFinishWithCache];
	}
	
	// 修改参数（共同参数、时间戳、加密）
	[_cmdConfig modifyArgsWithCmdRequest:self];
	
	switch (aType)
	{
		case RFCmdRequestTypeGet:
			{
				NSString *argString = [self stringWithArgs:_arguments];
				if (argString.length > 0)
				{
					[url appendString:@"?"];
					[url appendString:argString];
				}
				
				_cmdResult.finalURL = [NSURL URLWithString:url];
				self.urlRequest = [NSMutableURLRequest requestWithURL:_cmdResult.finalURL];
				[_cmdConfig modifyUrlRequestWithCmdRequest:self];
				
				NSLog(@"Cmd:%@\nUrl:%@", _cmdName, url);
			}
			break;
		case RFCmdRequestTypePostParams:
			{
				NSString *argString = [self stringWithArgs:_arguments];
				NSData *postData = [argString dataUsingEncoding:NSUTF8StringEncoding];
				
				_cmdResult.finalURL = [NSURL URLWithString:url];
				self.urlRequest = [NSMutableURLRequest requestWithURL:_cmdResult.finalURL];
				[_urlRequest setHTTPMethod:@"POST"];
				[_urlRequest setHTTPBody:postData];
				[_urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
				[_urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
				[_cmdConfig modifyUrlRequestWithCmdRequest:self];
				
				NSLog(@"Cmd:%@\nUrl:%@\nPost:%@", _cmdName, url, argString);
			}
			break;
		case RFCmdRequestTypePostForm:
			{
				NSData *postData = [self formDataWithArgs:_arguments datas:_fileDatas];
				
				_cmdResult.finalURL = [NSURL URLWithString:url];
				self.urlRequest = [NSMutableURLRequest requestWithURL:_cmdResult.finalURL];
				[_urlRequest setHTTPMethod:@"POST"];
				[_urlRequest setHTTPBody:postData];
				[_urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
				[_urlRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", _cmdConfig.boundary] forHTTPHeaderField:@"Content-Type"];
				[_cmdConfig modifyUrlRequestWithCmdRequest:self];
				
				NSLog(@"Cmd:%@\nUrl:%@\nPost:%@", _cmdName, url, _arguments);
			}
			break;
		case RFCmdRequestTypePostFormOnlyFile:
			{
				NSData *postData = [self formDataWithArgs:nil datas:_fileDatas];
				NSString *argString = [self stringWithArgs:_arguments];
				if (argString.length > 0)
				{
					[url appendString:@"?"];
					[url appendString:argString];
				}
				
				_cmdResult.finalURL = [NSURL URLWithString:url];
				self.urlRequest = [NSMutableURLRequest requestWithURL:_cmdResult.finalURL];
				[_urlRequest setHTTPMethod:@"POST"];
				[_urlRequest setHTTPBody:postData];
				[_urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
				[_urlRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", _cmdConfig.boundary] forHTTPHeaderField:@"Content-Type"];
				[_cmdConfig modifyUrlRequestWithCmdRequest:self];
				
				NSLog(@"Cmd:%@\nUrl:%@Post:FileDatas", _cmdName, url);
			}
			break;
		case RFCmdRequestTypePostJson:
			{
				NSString *jsonString = [self jsonWithArgs:_arguments];
				NSData *postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
				
				_cmdResult.finalURL = [NSURL URLWithString:url];
				self.urlRequest = [NSMutableURLRequest requestWithURL:_cmdResult.finalURL];
				[_urlRequest setHTTPMethod:@"POST"];
				[_urlRequest setHTTPBody:postData];
				[_urlRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
				[_urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
				[_cmdConfig modifyUrlRequestWithCmdRequest:self];
				
				NSLog(@"Cmd:%@\nUrl:%@\nPost:%@", _cmdName, url, jsonString);
			}
			break;
		default:
			return NO;
	}
	
	// 连接
	if ([self startConnection])
	{
		[self callbackStart];
		return YES;
	}
	
	return NO;
}

- (void)cancel
{
	[self cancelConnection];
	[self callbackCancel];
}

- (BOOL)startConnection
{
	return YES;
}

- (void)cancelConnection
{
	
}

- (void)startTimeOut
{
	self.timeOut = [NSTimer scheduledTimerWithTimeInterval:20.0f target:self selector:@selector(timeOutProcess) userInfo:nil repeats:NO];
}

- (void)stopTimeOut
{
	if (_timeOut != nil)
	{
		[_timeOut invalidate];
		SAFE_ARC_RELEASE(_timeOut);
		_timeOut = nil;
	}
}

- (void)resetTimeOut
{
	[self stopTimeOut];
	[self startTimeOut];
}

- (void)timeOutProcess
{
	NSLog(@"timeOut cmd:%@", _cmdName);
	
	[self cancelConnection];
	[self callbackFailed];
}

- (void)callbackStart
{
	[_cmdConfig showLoading:kRFCmdMsgConnecting cmdRequest:self];
	
	if (_delegate != nil && [_delegate respondsToSelector:@selector(onCmdRequestStart:)])
	{
		[_delegate onCmdRequestStart:self];
	}
	
//	if (_startBlock != nil)
//	{
//		_startBlock(self);
//	}
}

- (void)callbackFinish
{
	[_cmdConfig hideLoading:self];
	
	if (_delegate != nil && [_delegate respondsToSelector:@selector(onCmdRequestFinish:)])
	{
		[_delegate onCmdRequestFinish:self];
	}
	
//	if (_finishBlock != nil)
//	{
//		_finishBlock(self);
//	}
}

- (void)callbackFailed
{
	[_cmdConfig hideLoading:self];
	
	if (_delegate != nil && [_delegate respondsToSelector:@selector(onCmdRequestFailed:)])
	{
		[_delegate onCmdRequestFailed:self];
	}
	
//	if (_failedBlock != nil)
//	{
//		_failedBlock(self);
//	}
}

- (void)callbackCancel
{
	[_cmdConfig hideLoading:self];
	
	if (_delegate != nil && [_delegate respondsToSelector:@selector(onCmdRequestCancel:)])
	{
		[_delegate onCmdRequestCancel:self];
	}
	
//	if (_cancelBlock != nil)
//	{
//		_cancelBlock(self);
//	}
}

- (void)callbackUploading
{
	if (_delegate != nil && [_delegate respondsToSelector:@selector(onCmdRequestUploading:)])
	{
		[_delegate onCmdRequestUploading:self];
	}
	
//	if (_uploadingBlock != nil)
//	{
//		_uploadingBlock(self);
//	}
}

- (void)callbackDownloading
{
	if (_delegate != nil && [_delegate respondsToSelector:@selector(onCmdRequestDownloading:)])
	{
		[_delegate onCmdRequestDownloading:self];
	}
	
//	if (_downloadingBlock != nil)
//	{
//		_downloadingBlock(self);
//	}
}

- (NSString *)stringWithArgs:(NSDictionary *)anArgs
{
	if (anArgs != nil && anArgs.count > 0)
	{
		NSMutableString *buffer = [[NSMutableString alloc] init];
		for (NSString *key in anArgs)
		{
			NSString *value = [anArgs objectForKey:key];
			[buffer appendFormat:@"%@=%@&", key, [value stringByURLEncoding]];
		}
		[buffer removeLastChar];
		
		return buffer;
	}
	return @"";
}

- (NSString *)jsonWithArgs:(NSDictionary *)anArgs
{
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:anArgs options:NSJSONWritingPrettyPrinted error:nil];
	NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	return jsonStr;
}

- (NSData *)formDataWithArgs:(NSDictionary *)anArgs datas:(NSArray *)aDatas
{
	NSString *tmp = nil;
	NSInteger i = 0;
	NSMutableData *buffer = [NSMutableData data];
	NSString *stringBoundary = _cmdConfig.boundary;
	NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary];
	
	{
		tmp = [NSString stringWithFormat:@"--%@\r\n", stringBoundary];
		[buffer appendData:[tmp dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	i = 0;
	if (anArgs != nil && anArgs.count > 0)
	{
		for (NSDictionary *key in anArgs)
		{
			NSString *value = [anArgs objectForKey:key];
			tmp = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
			[buffer appendData:[tmp dataUsingEncoding:NSUTF8StringEncoding]];
			[buffer appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
			i += 1;
			if (i != anArgs.count || aDatas.count > 0)
			{
				[buffer appendData:[endItemBoundary dataUsingEncoding:NSUTF8StringEncoding]];
			}
		}
	}
	
	i = 0;
	for (NSDictionary *dict in aDatas)
	{
		NSString *key = [dict objectForKey:kDictKeyContentKey];
		NSString *fileName = [dict objectForKey:kDictKeyContentFileName];
		NSString *contentType = [dict objectForKey:kDictKeyContentType];
		NSData *data = [dict objectForKey:kDictKeyContentData];
		
		tmp = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, fileName];
		[buffer appendData:[tmp dataUsingEncoding:NSUTF8StringEncoding]];
		tmp = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", contentType];
		[buffer appendData:[tmp dataUsingEncoding:NSUTF8StringEncoding]];
		[buffer appendData:data];
		i += 1;
		if (i != aDatas.count)
		{
			[buffer appendData:[endItemBoundary dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}

	{
		tmp = [NSString stringWithFormat:@"\r\n--%@--\r\n", stringBoundary];
		[buffer appendData:[tmp dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	return buffer;
}

- (void)writeToCache:(NSMutableData *)buf
{
	switch (_cacheType)
	{
		case RFCmdRequestCacheTypeRequestFirst:
		case RFCmdRequestCacheTypeCacheFirst:
			{
				NSString *cachePath = _cmdResult.cachePath;
				if (![NSString isEmpty:cachePath])
				{
					if (buf != nil && buf.length > 0)
					{
						[buf writeToFile:cachePath atomically:YES];
						if (_cmdResult.lastModified != nil)
						{
							// 修改时间
							[RFStorageKit changeModificationDate:cachePath date:_cmdResult.lastModified];
						}
					}
				}
			}
			break;
		default:
			break;
	}
}

- (BOOL)callbackFinishWithCache
{
	NSString *cachePath = _cmdResult.cachePath;
	if ([RFStorageKit isExist:cachePath])
	{
//		NSLog(@"Cmd:%@\nCacheFile:%@", _cmdName, cachePath);
		_cmdResult.buffer = [NSMutableData dataWithContentsOfFile:cachePath];
		_cmdResult.isCached = YES;
		_cmdResult.isFinish = YES;
		[self callbackFinish];
		return YES;
	}
	return NO;
}

- (BOOL)canUseCache
{
	NSString *cachePath = _cmdResult.cachePath;
	switch (_cacheType)
	{
		case RFCmdRequestCacheTypeRequestFirst:
			{
				if (![NSString isEmpty:cachePath])
				{
					// 日期检查
					NSDate *fileDate = [RFStorageKit modificationDateWithPath:cachePath];
					if (fileDate != nil && _cmdResult.lastModified != nil)
					{
						if (![fileDate isEqualToDate:_cmdResult.lastModified])
						{
							break;
						}
					}
					
					// 长度检查
					int64_t fileSize = [RFStorageKit fileSize:cachePath];
					if (fileSize != _cmdResult.contentLength)
					{
						break;
					}
					
					return YES;
				}
			}
			break;
		case RFCmdRequestCacheTypeCacheFirst:
			{
				if (![NSString isEmpty:cachePath])
				{
					// 长度检查
					int64_t fileSize = [RFStorageKit fileSize:cachePath];
					if (fileSize > 0)
					{
						return YES;
					}
				}
			}
			break;
		default:
			break;
	}
	return NO;
}

@end
