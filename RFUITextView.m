//
//  RFUITextView.m
//  XiaoXunTong
//
//  Created by gouzhehua on 14-8-9.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFUITextView.h"

@interface RFUITextView ()
<
	UITextViewDelegate
>

@end

@implementation RFUITextView
@synthesize tvInput = _tvInput;
@synthesize blockShouldBeginEditing = _blockShouldBeginEditing;
@synthesize blockShouldReturn = _blockShouldReturn;
@synthesize paddingLeft = _paddingLeft;
@synthesize paddingTop = _paddingTop;
@synthesize isReturnToResign = _isReturnToResign;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
		self.tvInput = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectZero];
		_paddingLeft = 5;
		_paddingTop = 5;
		
		[self configUI];
    }
    return self;
}

- (void)dealloc
{
	_tvInput.delegate = nil;
	SAFE_ARC_RELEASE(_tfInput);
	self.blockShouldBeginEditing = nil;
	self.blockShouldReturn = nil;
	
	SAFE_ARC_SUPER_DEALLOC();
}

- (void)awakeFromNib
{
	self.tvInput = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectZero];
	_paddingLeft = 5;
	_paddingTop = 5;
	
	[self configUI];
}

- (void)configUI
{
	CGFloat offsetY = 0;
	if (IS_IOS7) offsetY = 0;
	
	CGRect vRect = self.frame;
	CGRect tvRect = self.frame;
	tvRect.origin.x = _paddingLeft;
	tvRect.origin.y = _paddingTop;
	tvRect.size.width = MAX((vRect.size.width - _paddingLeft*2), 0);
	tvRect.size.height = MAX((vRect.size.height - _paddingTop*2), 0);
	_tvInput.frame = tvRect;
	
	self.backgroundColor = [UIColor whiteColor];
	[self addSubview:_tvInput];
	
	_tvInput.backgroundColor = [UIColor clearColor];
	_tvInput.textColor = [UIColor blackColor];
	_tvInput.font = [UIFont systemFontOfSize:16];
	_tvInput.delegate = self;
	_tvInput.scrollIndicatorInsets = UIEdgeInsetsZero;
	_tvInput.contentInset = UIEdgeInsetsZero;
	
	if (_isReturnToResign)
	{
		_tvInput.returnKeyType = UIReturnKeyDone;
	}
}

- (BOOL)resignFirstResponder
{
	return [_tvInput resignFirstResponder];
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	if (self.blockShouldBeginEditing != nil)
	{
		return self.blockShouldBeginEditing(self);
	}
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	BOOL bRet = YES;
	
	if (self.blockShouldReturn != nil)
	{
		bRet = self.blockShouldReturn(self);
	}
	
	if (bRet)
	{
		[textView resignFirstResponder];
	}
	
	return bRet;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if (_isReturnToResign)
	{
		if (1 == range.length)
		{
			//按下退格键
			return YES;
		}
		
		if ([text isEqualToString:@"\n"])
		{
			//按下return键
			//这里隐藏键盘，不做任何处理
			[textView resignFirstResponder];
			return NO;
		}
		else
		{
			return YES;
		}
		return NO;
	}
	
	return YES;
}

@end
