//
//  NSObject+RFEvent.h
//  RF
//
//  Created by gouzhehua on 14-6-23.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 RFEvent说明：
 1、注册事件适合在viewDidAppear，取消事件适合在viewWillDisappear，减少BUG产生。
 2、集中注册事件时，简单事件处理适合使用block, 复杂事件处理适合selector
 3、事件回调与界面无关，且耗时的不要使用主线程回调(mainAction, mainBlock)
 4、事件注销不是必要操作，对象被释放时自动注销
 */

typedef void (^RFEventBlock) (NSNotification *aNote);

@interface NSObject (RFEvent)

- (NSMutableDictionary *)rfEvents;

- (void)rfWatchObject:(id)anObject event:(NSString *)anEvent action:(SEL)anAction;
- (void)rfWatchObject:(id)anObject event:(NSString *)anEvent mainAction:(SEL)anAction;
- (void)rfWatchObject:(id)anObject event:(NSString *)anEvent block:(RFEventBlock)aBlock;
- (void)rfWatchObject:(id)anObject event:(NSString *)anEvent mainBlock:(RFEventBlock)aBlock;

- (void)rfUnwatchEvents;
- (void)rfUnwatchObject:(id)anObject;
- (void)rfUnwatchObject:(id)anObject event:(NSString *)anEvent;

- (void)rfPostEvent:(NSString *)anEvent userInfo:(NSDictionary *)anUserInfo;

- (void)rfHandleRFEventBlockCallback:(NSNotification *)aNote;

@end
