//
//  RFUIPickerView.m
//  RF
//
//  Created by gouzhehua on 15-1-27.
//  Copyright (c) 2015年 RF. All rights reserved.
//

#import "RFUIPickerControl.h"
#import "RFColor.h"
#import "RFUIWindow.h"
#import "RFUIKit.h"

static UIWindow *s_inter_window = nil;

@interface RFUIPickerControl ()
{
	
}
@property (nonatomic, strong) RFUIWindow *window;

- (void)configUI;
- (void)onOptionClick:(id)sender;
- (void)selectIdx:(NSInteger)anIdx;

@end

@implementation RFUIPickerControl

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		[self configUI];
	}
	return self;
}

- (void)awakeFromNib
{
	[self configUI];
}

- (void)configUI
{
	self.backgroundColor = [UIColor clearColor];
	self.lbTitle = [[UILabel alloc] initWithFrame:self.bounds];
	self.lbTitle.backgroundColor = [UIColor clearColor];
	self.lbTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.userInteractionEnabled = YES;
	[self setTapActionWithTarget:self selector:@selector(onOptionClick:)];
	[self addSubview:self.lbTitle];
}

- (void)updateWithTitle:(NSString *)title
			  keyValues:(RFKeyValues *)keyValues
			   selected:(NSInteger)idx
			 onSelected:(RFUIPickerDidSelectedBlock)block
{
	[self dismiss];
	
	self.defaultTitle = title;
	self.keyValues = keyValues;
	self.selectedIdx = idx;
	self.currentIdx = (self.selectedIdx < 0) ? 0 : self.selectedIdx;
	self.didSelectedBlock = block;
	
	[self selectIdx:self.selectedIdx];
}

- (void)showSheet
{
	[self dismiss];
	
	self.window = [[RFUIWindow alloc] init];
	UIView *bgViewInWindow = [self.window bgView];
	bgViewInWindow.backgroundColor = RGBA2COLOR(20, 20, 20, 0.8);
	RFUIPickerControl *selfRef = self;
	self.window.bgClickBlock = ^(){
		[selfRef dismiss];
	};
	
	CGRect bgFrame = bgViewInWindow.frame;
	CGFloat viewBgHeight = 250;
	CGFloat viewBgWidth = bgFrame.size.width;
	
	UIView *viewBg = [[UIView alloc] init];
	viewBg.backgroundColor = [UIColor whiteColor];
	viewBg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	[bgViewInWindow addSubview:viewBg];
	
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
	if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
	{
		viewBgHeight = 200;
	}
	viewBg.bounds = CGRectMake(0, 0, viewBgWidth, viewBgHeight);
	[viewBg setFrameOrigin:0 top:bgFrame.size.height-viewBgHeight];
	
	CGFloat top = 5;
	CGFloat gap = 0;
	if (IS_IOS7)
	{
		gap = 0;
	}
	else
	{
		gap = 5;
		viewBg.backgroundColor = RGBA2COLOR(86, 88, 99, 1);
		UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewBgWidth, 1)];
		line.backgroundColor = RGBA2COLOR(30, 30, 30, 1);
		[viewBg addSubview:line];
	}
	
	UISegmentedControl *btnClose = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
	btnClose.autoresizingMask = UIViewAutoresizingNone;
	btnClose.momentary = YES;
	btnClose.frame = CGRectMake(10.0f, top, 50.0f, 30.0f);
	if (!IS_IOS8)
	{
		btnClose.segmentedControlStyle = UISegmentedControlStyleBar;
	}
	[btnClose addTarget:self action:@selector(btnClose_Click:) forControlEvents:UIControlEventValueChanged];
	[viewBg addSubview:btnClose];
	
	UISegmentedControl *btnSave = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
	btnSave.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	btnSave.momentary = YES;
	btnSave.frame = CGRectMake(viewBgWidth - 60, top, 50.0f, 30.0f);
	if (!IS_IOS8)
	{
		btnSave.segmentedControlStyle = UISegmentedControlStyleBar;
	}
	[btnSave addTarget:self action:@selector(btnFinish_Click:) forControlEvents:UIControlEventValueChanged];
	[viewBg addSubview:btnSave];
	
	CGRect pickerFrame = CGRectMake(0, 30+top+gap, 0, 0);
	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	pickerView.showsSelectionIndicator = YES;
	pickerView.dataSource = self;
	pickerView.delegate = self;
	[viewBg addSubview:pickerView];
	
	if (self.selectedIdx > 0)
	{
		[pickerView selectRow:self.selectedIdx inComponent:0 animated:NO];
	}
	
	[self.window show];
}

- (void)dismiss
{
	if (self.window != nil)
	{
		[self.window dismiss];
	}
	self.window = nil;
}

- (void)onOptionClick:(id)sender
{
	[self showSheet];
}

- (void)btnClose_Click:(id)sender
{
	[self dismiss];
}

- (void)btnFinish_Click:(id)sender
{
	self.selectedIdx = self.currentIdx;
	[self selectIdx:self.currentIdx];
	
	if (self.didSelectedBlock != nil)
	{
		self.didSelectedBlock(self, self.selectedIdx);
	}
	[self dismiss];
}

- (void)selectIdx:(NSInteger)anIdx
{
	if (anIdx < 0)
	{
		self.lbTitle.text = self.defaultTitle;
	}
	else
	{
		RFKeyValue *kv = [self.keyValues objectAtIndex:anIdx];
		self.lbTitle.text = KV_KEY(kv);
	}
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
	if (self.keyValues != nil)
	{
		return self.keyValues.count;
	}
	return 0;
}

#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (self.keyValues != nil)
	{
		RFKeyValue *kv = [self.keyValues objectAtIndex:row];
		return KV_KEY(kv);
	}
	return @"";
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	self.currentIdx = row;
}

@end
