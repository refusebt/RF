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
	lockView.clickBlock = clickBlock;
	lockView.userInteractionEnabled = YES;
	lockView.backgroundColor = RGBA2COLOR(0, 0, 0, 0);
	[lockView setTapActionWithTarget:lockView selector:@selector(onLockViewClick:)];
	[view addSubview:lockView];
	
	if (!isTransparent)
	{
		[UIView animateWithDuration:0.2
						 animations:^(){
							 lockView.backgroundColor = RGBA2COLOR(0, 0, 0, 0.4);
						 }
						 completion:^(BOOL isFinish){
							 
						 }];
	}
}

+ (void)unlockView:(UIView *)view
{
	for (UIView *lockView in view.subviews)
	{
		if ([lockView isKindOfClass:[RFUILockView class]])
		{
			[UIView animateWithDuration:0.2
							 animations:^(){
								 lockView.backgroundColor = RGBA2COLOR(0, 0, 0, 0.0);
							 }
							 completion:^(BOOL isFinish){
								 [lockView removeFromSuperview];
							 }];
		}
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
