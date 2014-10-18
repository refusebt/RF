//
//  RFActionSheet.m
//  XiaoXunTong
//
//  Created by gouzhehua on 14-8-8.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFActionSheet.h"
#import "RF.h"

@interface RFActionSheet ()
{
	
}
@property (nonatomic, SAFE_ARC_STRONG) RFActionSheetBlock clickBlock;
@property (nonatomic, SAFE_ARC_STRONG) id param1;
@property (nonatomic, SAFE_ARC_STRONG) id param2;
@property (nonatomic, SAFE_ARC_STRONG) id param3;

@end

@implementation RFActionSheet
@synthesize clickBlock = _clickBlock;
@synthesize param1 = _param1;
@synthesize param2 = _param2;
@synthesize param3 = _param3;

//- (id)initWithTitle:(NSString *)aTitle
//  cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle
//	   buttonTitles:(NSArray *)aButtonTitles
//		 clickBlock:(RFActionSheetBlock)aClickBlock
//{
//	self = [super initWithTitle:aTitle delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
//    if (self)
//    {
//		for (NSInteger i = 0; i < aButtonTitles.count; i++)
//		{
//			NSString *title = [aButtonTitles objectAtIndex:i];
//			[self addButtonWithTitle:title];
//		}
//		self.clickBlock = aClickBlock;
//    }
//    return self;
//}

- (void)setActionSheetBlock:(RFActionSheetBlock)aBlock
{
	self.clickBlock = aBlock;
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (_clickBlock != nil)
	{
		_clickBlock(self, buttonIndex);
	}
}

@end
