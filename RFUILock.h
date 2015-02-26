//
//  RFUILock.h
//  KeDao
//
//  Created by gouzhehua on 15-2-26.
//  Copyright (c) 2015年 skyInfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFUIWindow.h"

@interface RFUILockView : UIView
{

}
@property (nonatomic, strong) void(^clickBlock)();

+ (void)lockView:(UIView *)view transparent:(BOOL)isTransparent click:(void(^)(void))clickBlock;
+ (void)unlockView:(UIView *)view;

@end

@interface RFUILockWindow : NSObject
{

}
@property (nonatomic, strong) RFUIWindow *window;

+ (RFUILockWindow *)shared;

- (void)lockWithTransparent:(BOOL)isTransparent click:(void(^)(void))clickBlock;
- (void)unlock;

@end
