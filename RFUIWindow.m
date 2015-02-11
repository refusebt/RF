//
//  RFUIWindow.m
//  RF
//
//  Created by gouzhehua on 15-1-27.
//  Copyright (c) 2015年 RF. All rights reserved.
//

#import "RFUIWindow.h"
#import "RFUIKit.h"

@interface RFUIWindowController ()

@end

@interface RFUIWindow ()

@end

@implementation RFUIWindowController

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return [[UIApplication sharedApplication] statusBarStyle];
}

- (BOOL)shouldAutorotate
{
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationPortrait)
		return UIInterfaceOrientationMaskPortrait;
	else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
		return UIInterfaceOrientationMaskPortraitUpsideDown;
	else if (orientation == UIInterfaceOrientationLandscapeLeft)
		return UIInterfaceOrientationMaskLandscapeLeft;
	else if (orientation == UIInterfaceOrientationLandscapeRight)
		return UIInterfaceOrientationMaskLandscapeRight;
	return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	return orientation;
}

- (BOOL)prefersStatusBarHidden
{
	return [UIApplication sharedApplication].statusBarHidden;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
}

@end

@implementation RFUIWindow

- (id)init
{
	self = [super initWithFrame:[UIScreen mainScreen].bounds];
	if (self)
	{
		self.rootViewController = [[RFUIWindowController alloc] init];
		[self.rootViewController.view setTapActionWithTarget:self selector:@selector(onBgClick:)];
		self.rootViewController.view.userInteractionEnabled = YES;
	}
	return self;
}

- (void)show
{
	self.frame = [UIScreen mainScreen].bounds;
	self.rootViewController.view.frame = self.bounds;
	self.windowLevel = UIWindowLevelStatusBar + 2;
	self.hidden = NO;
	[self makeKeyAndVisible];
}

- (void)dismiss
{
	self.hidden = YES;
	[self resignKeyWindow];
	self.rootViewController = nil;
}

- (UIView *)bgView
{
	return self.rootViewController.view;
}

- (void)onBgClick:(id)sender
{
	if (self.bgClickBlock != nil)
	{
		self.bgClickBlock();
	}
}

@end
