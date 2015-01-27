//
//  RFUIPickerView.h
//  RF
//
//  Created by gouzhehua on 15-1-27.
//  Copyright (c) 2015年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFKit.h"

@class RFUIPickerControl;

typedef void(^RFUIPickerDidSelectedBlock)(RFUIPickerControl *picker, NSInteger selected);

@interface RFUIPickerControl : UIView
<
	UIPickerViewDataSource
	, UIPickerViewDelegate
>
{
	
}
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) RFKeyValues *keyValues;
@property (nonatomic, assign) NSInteger selectedIdx;
@property (nonatomic, assign) NSInteger currentIdx;
@property (nonatomic, strong) RFUIPickerDidSelectedBlock didSelectedBlock;
@property (nonatomic, strong) NSString *defaultTitle;

- (void)updateWithTitle:(NSString *)title
		  keyValues:(RFKeyValues *)keyValues
				 selected:(NSInteger)idx
			   onSelected:(RFUIPickerDidSelectedBlock)block;

- (void)showSheet;
- (void)dismiss;

@end
