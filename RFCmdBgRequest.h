//
//  RFCmdBgRequest.h
//  RFApp
//
//  Created by gouzhehua on 14-7-10.
//  Copyright (c) 2014年 skyinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFCmdBaseRequest.h"

@interface RFCmdBgRequest : RFCmdBaseRequest
{

}
@property (nonatomic, SAFE_ARC_STRONG) NSURLSession *urlSession;
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) NSString *tmpFilePath;

+ (void)setCompletionHandler:(void (^)())completionHandler forIdentifier:(NSString *)identifier;
+ (void (^)())completionHandlerWithIdentifier:(NSString *)identifier;
+ (void)removeCompletionHandlerWithIdentifier:(NSString *)identifier;

@end
