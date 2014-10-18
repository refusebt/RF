//
//  RFUILockView.m
//  RF
//
//  Created by 9sky on 14-4-17.
//  Copyright (c) 2014年 9sky. All rights reserved.
//

#import "RFUILockView.h"
#import "ARCMacros.h"

@interface RFUILockView ()
@property (nonatomic, SAFE_ARC_STRONG) UIView *viewLock;
@end

@implementation RFUILockView
@synthesize viewLock;

- (id)init
{
	self = [super init];
    if (self)
    {
		viewLock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		viewLock.backgroundColor = RGBA2COLOR(0, 0, 0, 0.6);
		viewLock.userInteractionEnabled = YES;
    }
    return self;
}

- (void)dealloc
{
	SAFE_ARC_RELEASE(viewLock);
	
	SAFE_ARC_SUPER_DEALLOC();
}

+ (RFUILockView *)shared
{
	static RFUILockView *s_lockView = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		s_lockView = [[RFUILockView alloc] init];
	});
	
	return s_lockView;
}

- (void)lockWholeView
{
	[viewLock removeFromSuperview];
	UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	[window addSubview:viewLock];
	CGRect frame = [window frame];
	frame.origin.x = 0;
	frame.origin.y = 0;
	viewLock.frame = frame;
}

- (void)unlockWholeView
{
	[viewLock removeFromSuperview];
}

@end

