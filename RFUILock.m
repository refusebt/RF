//
//  RFUILock.m
//  KeDao
//
//  Created by gouzhehua on 15-2-26.
//  Copyright (c) 2015年 skyInfo. All rights reserved.
//

#import "RFUILock.h"
#import "RFColor.h"
#import "RFUIKit.h"

@interface RFUILockView ()
{
	
}

@end

@interface RFUILockWindow ()

@end

@implementation RFUILockView

+ (void)lockView:(UIView *)view transparent:(BOOL)isTransparent click:(void(^)(void))clickBlock
{
	[RFUILockView unlockView:view];
	RFUILockView *lockView = [[RFUILockView alloc] initWithFrame:view.bounds];
	lockView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	if (isTransparent)
		lockView.backgroundColor = RGBA2COLOR(0, 0, 0, 0);
	else
		lockView.backgroundColor = RGBA2COLOR(0, 0, 0, 0.6);
	lockView.clickBlock = clickBlock;
	lockView.userInteractionEnabled = YES;
	[lockView setTapActionWithTarget:lockView selector:@selector(onLockViewClick:)];
	[view addSubview:lockView];
}

+ (void)unlockView:(UIView *)view
{
	NSArray *lockViews = [view getAllViewsWithClass:[RFUILockView class]];
	for (RFUILockView *lockView in lockViews)
	{
		[lockView removeFromSuperview];
	}
}

- (void)onLockViewClick:(id)sender
{
	if (self.clickBlock != nil)
	{
		self.clickBlock();
	}
}

@end

@implementation RFUILockWindow

+ (RFUILockWindow *)shared
{
	static RFUILockWindow *s_instance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		s_instance = [[RFUILockWindow alloc] init];
	});
	
	return s_instance;
}

- (void)lockWithTransparent:(BOOL)isTransparent click:(void(^)(void))clickBlock
{
	if (self.window != nil)
	{
		[self unlock];
	}
	
	self.window = [[RFUIWindow alloc] init];
	self.window.backgroundColor = [UIColor clearColor];
	if (isTransparent)
		self.window.bgView.backgroundColor = RGBA2COLOR(0, 0, 0, 0);
	else
		self.window.bgView.backgroundColor = RGBA2COLOR(0, 0, 0, 0.6);
	self.window.bgClickBlock = clickBlock;
	
	[self.window show];
}

- (void)unlock
{
	if (self.window != nil)
	{
		[self.window dismiss];
	}
	self.window = nil;
}

@end
