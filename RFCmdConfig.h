//
//  RFCmdConfig.h
//  RFApp
//
//  Created by gouzhehua on 14-7-11.
//  Copyright (c) 2014年 skyinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCMacros.h"

@class RFCmdBaseRequest;

#define kRFCmdMsgNoNet			NSLocalizedString(@"暂无网络", @"")
#define kRFCmdMsgConnecting		NSLocalizedString(@"正在获取数据...", @"")

@interface RFCmdConfig : NSObject
{

}
@property (nonatomic, SAFE_ARC_STRONG) NSString *boundary;
@property (nonatomic, assign) BOOL isShowLoading;

- (NSString *)cachePathWithUrl:(NSString *)anUrl args:(NSDictionary *)anArgs;
- (NSString *)cacheKeyWithUrl:(NSString *)anUrl args:(NSDictionary *)anArgs;

- (void)modifyArgsWithCmdRequest:(RFCmdBaseRequest *)aCmdRequest;
- (void)modifyUrlRequestWithCmdRequest:(RFCmdBaseRequest *)aCmdRequest;

- (void)showLoading:(NSString *)aMsg cmdRequest:(RFCmdBaseRequest *)aCmdRequest;
- (void)showMessage:(NSString *)aMsg cmdRequest:(RFCmdBaseRequest *)aCmdRequest;
- (void)showError:(NSString *)aMsg cmdRequest:(RFCmdBaseRequest *)aCmdRequest;
- (void)hideLoading:(RFCmdBaseRequest *)aCmdRequest;

+ (RFCmdConfig *)defaultConfig;

@end
