//
//  RFUITextField.m
//  XiaoXunTong
//
//  Created by gouzhehua on 14-8-1.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFUITextField.h"
#import "RFUIKit.h"

@interface RFUITextField ()
<
	UITextFieldDelegate
>
{
	
}

- (void)configUI;

@end

@implementation RFUITextField
@synthesize tfInput = _tfInput;
@synthesize blockShouldBeginEditing = _blockShouldBeginEditing;
@synthesize blockShouldReturn = _blockShouldReturn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
		self.tfInput = [[UITextField alloc] initWithFrame:CGRectZero];
		[self configUI];
    }
    return self;
}

- (void)dealloc
{
	_tfInput.delegate = nil;
	SAFE_ARC_RELEASE(_tfInput);
	self.blockShouldBeginEditing = nil;
	self.blockShouldReturn = nil;
	
	SAFE_ARC_SUPER_DEALLOC();
}

- (void)awakeFromNib
{
	self.tfInput = [[UITextField alloc] initWithFrame:Frame2Bounds(self.frame)];
	[self configUI];
}

- (void)configUI
{
	CGFloat offsetY = 0;
//	if (IS_IOS7) offsetY = 0;
	
	CGRect vRect = self.frame;
	CGRect tfRect = self.frame;
	tfRect.origin.x = 10;
	tfRect.origin.y = MAX((vRect.size.height - 30) / 2 + offsetY, 0);
	tfRect.size.width = MAX((vRect.size.width - 20), 0);
	tfRect.size.height = 30;
	_tfInput.frame = tfRect;
	
	self.backgroundColor = [UIColor whiteColor];
	[self addSubview:_tfInput];
	
	_tfInput.backgroundColor = [UIColor clearColor];
	_tfInput.textColor = [UIColor blackColor];
	_tfInput.font = [UIFont systemFontOfSize:16];
	_tfInput.borderStyle = UITextBorderStyleNone;
	_tfInput.returnKeyType = UIReturnKeyDone;
	_tfInput.delegate = self;
}

- (BOOL)resignFirstResponder
{
	return [_tfInput resignFirstResponder];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if (self.blockShouldBeginEditing != nil)
	{
		return self.blockShouldBeginEditing(self);
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	BOOL bRet = YES;
	
	if (self.blockShouldReturn != nil)
	{
		bRet = self.blockShouldReturn(self);
	}
	
	if (bRet)
	{
		[textField resignFirstResponder];
	}
	
	return bRet;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL bRet = YES;
	
	if (self.blockShouldChangeCharactersInRange != nil)
	{
		bRet = self.blockShouldChangeCharactersInRange(self, range, string);
	}
	
	return bRet;
}
@end
