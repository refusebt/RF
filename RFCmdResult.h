//
//  RFCmdResult.h
//  RFApp
//
//  Created by gouzhehua on 14-7-11.
//  Copyright (c) 2014年 skyinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCMacros.h"

#define RF_HTTP_ACCEPT_RANGES_NONE						0
#define RF_HTTP_ACCEPT_RANGES_BYTES						1
#define RF_HTTP_CONTENT_RANGE_INVALID_VALUE				-1

@interface RFCmdResult : NSObject
{
}
@property (nonatomic, SAFE_ARC_STRONG) NSString *cmdName;
@property (nonatomic, SAFE_ARC_STRONG) NSURL *finalURL;
@property (nonatomic, SAFE_ARC_STRONG) NSMutableData *buffer;
@property (nonatomic, assign) BOOL isCached;
@property (nonatomic, assign) BOOL isFinish;
@property (nonatomic, SAFE_ARC_STRONG) NSString *cachePath;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, assign) int64_t contentLength;
@property (nonatomic, copy) NSDate *lastModified;
@property (nonatomic, assign) NSInteger acceptRanges;
@property (nonatomic, copy) NSString *contentRange;
@property (nonatomic, assign) int64_t contentRangeFirstBytePos;
@property (nonatomic, assign) int64_t contentRangeLastBytePos;
@property (nonatomic, assign) int64_t contentRangeInstanceLength;
@property (nonatomic, copy) NSString *eTag;
@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, SAFE_ARC_STRONG) NSString *resultMsg;
@property (nonatomic, SAFE_ARC_STRONG) NSString *resultDesc;

- (BOOL)isStatusCodeRedirect;
- (BOOL)isStatusCodeSuccess;
- (BOOL)isSupportRangeHeader;
- (void)proccessHTTPResponseHeaders:(NSHTTPURLResponse*)response;

- (NSDictionary *)jsonDict;
- (NSString *)responseString;

@end
