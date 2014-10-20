//
//  RFUICountDownButton.h
//  RF
//
//  Created by gouzhehua on 14-4-18.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFUICountDownButton.h"
#import "ARCMacros.h"
#import "RFKit.h"

@interface RFUICountDownButton()
{
}
@property (nonatomic, assign) NSInteger progress;
@property (nonatomic, strong) NSTimer *timer;

- (void)timerProc:(NSTimer *)aTime;

@end

@implementation RFUICountDownButton
@synthesize progress;
@synthesize timer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
	if (timer != nil)
	{
		[timer invalidate];
		SAFE_ARC_RELEASE(timer);
		timer = nil;
	}
	
	SAFE_ARC_SUPER_DEALLOC();
}

- (void)setEnabled:(BOOL)enabled
{
	[super setEnabled:enabled];
	
	if (enabled)
	{
		self.alpha = 1.0f;
	}
	else
	{
		self.alpha = 0.7f;
	}
}

- (void)setEnabled:(BOOL)enabled wait:(NSInteger)full
{
	self.enabled = enabled;
	
	if (timer != nil)
	{
		[timer invalidate];
		SAFE_ARC_RELEASE(timer);
		timer = nil;
	}
	
	if (enabled)
	{
		
	}
	else
	{
		progress = full;
		[self setTitle:[NSString stringWithInteger:progress] forState:UIControlStateDisabled];
		self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerProc:) userInfo:nil repeats:YES];
	}
}

- (void)timerProc:(NSTimer *)aTime
{
	progress--;
	if (progress <= 0)
	{
		if (timer != nil)
		{
			[timer invalidate];
			SAFE_ARC_RELEASE(timer);
			timer = nil;
		}
		[self setEnabled:YES];
	}
	else
	{
		[self setTitle:[NSString stringWithInteger:progress] forState:UIControlStateDisabled];
	}
}

@end
