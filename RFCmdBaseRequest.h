//
//  RFCmdBaseRequest.h
//  RFApp
//
//  Created by gouzhehua on 14-7-17.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCMacros.h"
#import "RFCmdResult.h"
#import "RFCmdConfig.h"

@class RFCmdBaseRequest;

// mainRunLoop or currentRunLoop
#define kRFRunLoop					[NSRunLoop currentRunLoop]

// NSRunLoopCommonModes or NSDefaultRunLoopMode
#define kRFRunLoopMode				NSDefaultRunLoopMode

typedef NS_ENUM(NSUInteger, RFCmdRequestType)
{
	RFCmdRequestTypeGet = 0,
	RFCmdRequestTypePostParams,
	RFCmdRequestTypePostForm,
	RFCmdRequestTypePostFormOnlyFile,
	RFCmdRequestTypePostJson,
};

typedef NS_ENUM(NSUInteger, RFCmdRequestCacheType)
{
	RFCmdRequestCacheTypeNone = 0,							// 不使用缓存，默认处理
	RFCmdRequestCacheTypeRequestFirst = 1,					// 请求优先，有缓存。失败或未过期时使用缓存
	RFCmdRequestCacheTypeCacheFirst = 2,					// 优先缓存
};

@protocol RFCmdRequestDelegate <NSObject>
@required
- (void)onCmdRequestFinish:(id)aRequest;
- (void)onCmdRequestFailed:(id)aRequest;
@optional
- (void)onCmdRequestStart:(id)aRequest;
- (void)onCmdRequestCancel:(id)aRequest;
- (void)onCmdRequestUploading:(id)aRequest;
- (void)onCmdRequestDownloading:(id)aRequest;
@end

@interface RFCmdBaseRequest : NSObject
{
	
}
@property (nonatomic, SAFE_ARC_STRONG) NSString *cmdName;
@property (nonatomic, SAFE_ARC_STRONG) NSString *urlString;
@property (nonatomic, SAFE_ARC_STRONG) NSDictionary *arguments;
@property (nonatomic, SAFE_ARC_STRONG) NSMutableArray *fileDatas;
@property (nonatomic, SAFE_ARC_STRONG) RFCmdConfig *cmdConfig;
@property (nonatomic, SAFE_ARC_WEAK) id<RFCmdRequestDelegate> delegate;
//@property (nonatomic, SAFE_ARC_STRONG) void(^finishBlock)(id aRequest);
//@property (nonatomic, SAFE_ARC_STRONG) void(^failedBlock)(id aRequest);
//@property (nonatomic, SAFE_ARC_STRONG) void(^startBlock)(id aRequest);
//@property (nonatomic, SAFE_ARC_STRONG) void(^cancelBlock)(id aRequest);
//@property (nonatomic, SAFE_ARC_STRONG) void(^uploadingBlock)(id aRequest);
//@property (nonatomic, SAFE_ARC_STRONG) void(^downloadingBlock)(id aRequest);
@property (nonatomic, SAFE_ARC_STRONG) RFCmdResult *cmdResult;
@property (nonatomic, assign) RFCmdRequestType requestType;
@property (nonatomic, assign) RFCmdRequestCacheType cacheType;
@property (nonatomic, SAFE_ARC_STRONG) NSMutableURLRequest *urlRequest;
@property (nonatomic, assign) int64_t sendBytes;
@property (nonatomic, assign) int64_t totalSendBytes;
@property (nonatomic, assign) int64_t receiveBytes;
@property (nonatomic, assign) int64_t totalReceiveBytes;

- (id)initWithCmd:(NSString *)aCmd url:(NSString *)anUrl args:(NSDictionary *)anArgs delegate:(id<RFCmdRequestDelegate>)aDelegate config:(RFCmdConfig *)aConfig;

- (void)addKey:(NSString *)aKey data:(NSData *)aData fileName:(NSString *)aFileName contentType:(NSString *)aContentType;

- (BOOL)startWithType:(RFCmdRequestType)aType;
- (void)cancel;

- (BOOL)startConnection;
- (void)cancelConnection;

- (void)startTimeOut;
- (void)stopTimeOut;
- (void)resetTimeOut;
- (void)timeOutProcess;

- (void)callbackStart;
- (void)callbackFinish;
- (void)callbackFailed;
- (void)callbackCancel;
- (void)callbackUploading;
- (void)callbackDownloading;

- (NSString *)stringWithArgs:(NSDictionary *)anArgs;
- (NSString *)jsonWithArgs:(NSDictionary *)anArgs;
- (NSData *)formDataWithArgs:(NSDictionary *)anArgs datas:(NSArray *)aDatas;
- (void)writeToCache:(NSMutableData *)buf;
- (BOOL)callbackFinishWithCache;
- (BOOL)canUseCache;

@end
