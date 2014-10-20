//
//  RFAlertView.m
//  RF
//
//  Created by gouzhehua on 14-6-27.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFAlertView.h"
#import "ARCMacros.h"

#pragma mark RFAlertView

@interface RFAlertView ()
{
	
}
@property (nonatomic, SAFE_ARC_STRONG) RFAlertViewClickBlock clickBlock;
@property (nonatomic, SAFE_ARC_STRONG) id param1;
@property (nonatomic, SAFE_ARC_STRONG) id param2;
@property (nonatomic, SAFE_ARC_STRONG) id param3;

@end

@implementation RFAlertView
@synthesize clickBlock = _clickBlock;
@synthesize param1 = _param1;
@synthesize param2 = _param2;
@synthesize param3 = _param3;

- (id)initWithTitle:(NSString *)aTitle
			message:(NSString *)aMessage
	   buttonTitles:(NSArray *)aButtonTitles
		 clickBlock:(RFAlertViewClickBlock)aClickBlock
{
	self = [super initWithTitle:aTitle message:aMessage delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    if (self)
    {
		for (NSInteger i = 0; i < aButtonTitles.count; i++)
		{
			NSString *title = [aButtonTitles objectAtIndex:i];
			[self addButtonWithTitle:title];
		}
		self.clickBlock = aClickBlock;
    }
    return self;
}

- (void)setParam1:(id)aParam1 param2:(id)aParam2 param3:(id)aParam3
{
	self.param1 = aParam1;
	self.param2 = aParam2;
	self.param3 = aParam3;
}

- (id)param1
{
	return _param1;
}

- (id)param2
{
	return _param2;
}

- (id)param3
{
	return _param3;
}

- (void)dealloc
{
	self.clickBlock = nil;
	SAFE_ARC_RELEASE(_param1);
	SAFE_ARC_RELEASE(_param2);
	SAFE_ARC_RELEASE(_param3);
	
	SAFE_ARC_SUPER_DEALLOC();
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (_clickBlock != nil)
	{
		_clickBlock(self, buttonIndex);
	}
}

+ (void)show:(NSString *)content
{
	RFAlertView *alert = [[RFAlertView alloc] initWithTitle:@"Note" message:content buttonTitles:@[@"OK"] clickBlock:nil];
	[alert show];
	SAFE_ARC_AUTORELEASE(alert);
}

@end
