//
//  RFActionSheet.h
//  XiaoXunTong
//
//  Created by gouzhehua on 14-8-8.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RFActionSheet;

typedef void(^RFActionSheetBlock)(RFActionSheet *anActionSheet, NSInteger aButtonIndex);

@interface RFActionSheet : UIActionSheet
<
	UIActionSheetDelegate
>
{
	
}

//- (id)initWithTitle:(NSString *)aTitle
//  cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle
//	   buttonTitles:(NSArray *)aButtonTitles
//		 clickBlock:(RFActionSheetBlock)aClickBlock;

- (void)setActionSheetBlock:(RFActionSheetBlock)aBlock;
- (void)setParam1:(id)aParam1 param2:(id)aParam2 param3:(id)aParam3;
- (id)param1;
- (id)param2;
- (id)param3;

@end
