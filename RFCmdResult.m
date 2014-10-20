//
//  RFCmdResult.m
//  RFApp
//
//  Created by gouzhehua on 14-7-11.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFCmdResult.h"

@implementation RFCmdResult
@synthesize cmdName = _cmdName;
@synthesize finalURL = _finalURL;
@synthesize buffer = _buffer;
@synthesize isCached = _isCached;
@synthesize isFinish = _isFinish;
@synthesize cachePath = _cachePath;
@synthesize statusCode = _statusCode;
@synthesize contentType = _contentType;
@synthesize contentLength = _contentLength;
@synthesize lastModified = _lastModified;
@synthesize acceptRanges = _acceptRanges;
@synthesize contentRange = _contentRange;
@synthesize contentRangeFirstBytePos = _contentRangeFirstBytePos;
@synthesize contentRangeLastBytePos = _contentRangeLastBytePos;
@synthesize contentRangeInstanceLength = _contentRangeInstanceLength;
@synthesize eTag = _eTag;
@synthesize resultCode = _resultCode;
@synthesize resultMsg = _resultMsg;
@synthesize resultDesc = _resultDesc;

- (id)init
{
	self = [super init];
    if (self)
    {
		self.cmdName = @"";
		self.finalURL = nil;
		self.buffer = [NSMutableData data];
		self.isCached = NO;
		self.isFinish = NO;
		self.cachePath = nil;
		self.statusCode = 0;
		self.contentType = nil;
		self.contentLength = 0;
		self.lastModified = nil;
		self.acceptRanges = RF_HTTP_ACCEPT_RANGES_NONE;
		self.contentRange = nil;
		self.contentRangeFirstBytePos = RF_HTTP_CONTENT_RANGE_INVALID_VALUE;
		self.contentRangeLastBytePos = RF_HTTP_CONTENT_RANGE_INVALID_VALUE;
		self.contentRangeInstanceLength = RF_HTTP_CONTENT_RANGE_INVALID_VALUE;
		self.eTag = nil;
    }
    return self;
}

- (void)dealloc
{
	SAFE_ARC_RELEASE(_cmdName);
	SAFE_ARC_RELEASE(_finalURL);
	SAFE_ARC_RELEASE(_buffer);
	SAFE_ARC_RELEASE(_cacheKey);
	SAFE_ARC_RELEASE(_contentType);
	SAFE_ARC_RELEASE(_lastModified);
	SAFE_ARC_RELEASE(_contentRange);
	SAFE_ARC_RELEASE(_eTag);
	SAFE_ARC_RELEASE(_resultMsg);
	SAFE_ARC_RELEASE(_resultDesc);
	
	SAFE_ARC_SUPER_DEALLOC();
}

- (BOOL)isStatusCodeRedirect
{
	// 重定向 300-399
	if ((_statusCode >= 300) && (_statusCode < 400))
	{
		return YES;
	}
	return NO;
}

- (BOOL)isStatusCodeSuccess
{
	// 200-299
	if ((_statusCode >= 200) && (_statusCode < 400))
	{
		return YES;
	}
	return NO;
}

- (BOOL)isSupportRangeHeader
{
	// 断点续传检查
	if (_acceptRanges == RF_HTTP_ACCEPT_RANGES_BYTES)
	{
		return YES;
	}
	return NO;
}

- (void)proccessHTTPResponseHeaders:(NSHTTPURLResponse*)response
{
	SAFE_ARC_AUTORELEASE_POOL_START();
	{
		NSString* value = nil;
		
		// Content-Type
		value = [response.allHeaderFields objectForKey:@"Content-Type"];
		if (value != nil)
		{
			self.contentType = value;
		}
		
		// Content-Length
		value = [response.allHeaderFields objectForKey:@"Content-Length"];
		if (value != nil)
		{
			self.contentLength = [value longLongValue];
		}
		
		// Last-Modified
		value = [response.allHeaderFields objectForKey:@"Last-Modified"];
		if (value != nil)
		{
			NSDateFormatter* formatter = SAFE_ARC_AUTORELEASE([[NSDateFormatter alloc] init]);
			[formatter setDateFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZZ"];
			self.lastModified = [formatter dateFromString:value];
		}
		
		// Accept-Ranges
		value = [response.allHeaderFields objectForKey:@"Accept-Ranges"];
		if ((value != nil) & [value isEqualToString:@"bytes"])
			self.acceptRanges = RF_HTTP_ACCEPT_RANGES_BYTES;
		else
			self.acceptRanges = RF_HTTP_ACCEPT_RANGES_NONE;
		
		// Content-Range 类似 "bytes 0-499/1234" 或 "bytes 0-/1234" 或 "bytes 0-/*"
		value = [response.allHeaderFields objectForKey:@"Content-Range"];
		if (value != nil)
		{
			self.contentRange = value;
			
			// 继续解析
			NSScanner* scanner = [NSScanner scannerWithString:_contentRange];
			int64_t numValue = 0;
			
			[scanner setCaseSensitive:NO];
			// scanner:bytes
			if ([scanner scanString:@"bytes" intoString:nil])
			{
				// scanner:first pos
				if ([scanner scanLongLong:&numValue])
				{
					self.contentRangeFirstBytePos = numValue;
					// scanner:-
					if ([scanner scanString:@"-" intoString:nil])
					{
						// scanner:last pos
						if ([scanner scanLongLong:&numValue])
							self.contentRangeLastBytePos = numValue;
						
						// scanner:/
						if ([scanner scanString:@"/" intoString:nil])
						{
							// scanner:instance length
							if ([scanner scanLongLong:&numValue])
							{
								self.contentRangeInstanceLength = numValue;
								
								// 修正无last pos的情况 "bytes 0-/1234"
								if (_contentRangeLastBytePos == RF_HTTP_CONTENT_RANGE_INVALID_VALUE)
								{
									self.contentRangeLastBytePos = _contentRangeInstanceLength - 1;
								}
							}
						}
					}
				}
			}
		}
		
		// ETag
		value = [response.allHeaderFields objectForKey:@"ETag"];
		if (value != nil)
		{
			self.eTag = value;
		}
	}
	SAFE_ARC_AUTORELEASE_POOL_END();
}

- (NSDictionary *)jsonDict
{
	if (_buffer != nil && _buffer.length > 0)
	{
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_buffer options:NSJSONReadingMutableContainers error:nil];
		NSLog(@"CMD:%@ Result:\n%@", _cmdName, json);
		return json;
	}
	return nil;
}

- (NSString *)responseString
{
	NSString *result = [[NSString alloc] initWithBytes:[_buffer bytes] length:[_buffer length] encoding:NSUTF8StringEncoding];
	NSLog(@"CMD:%@\nResult:\n%@", _cmdName, result);
	return SAFE_ARC_AUTORELEASE(result);
}

@end
