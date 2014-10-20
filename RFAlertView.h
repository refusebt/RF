//
//  RFAlertView.h
//  RF
//
//  Created by gouzhehua on 14-6-27.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RFAlertView;

typedef void(^RFAlertViewClickBlock)(RFAlertView *anAlertView, NSInteger aButtonIndex);

@interface RFAlertView : UIAlertView
<
	UIAlertViewDelegate
>
{
	
}

- (id)initWithTitle:(NSString *)aTitle
			message:(NSString *)aMessage
	   buttonTitles:(NSArray *)aButtonTitles
		 clickBlock:(RFAlertViewClickBlock)aClickBlock;

- (void)setParam1:(id)aParam1 param2:(id)aParam2 param3:(id)aParam3;
- (id)param1;
- (id)param2;
- (id)param3;

+ (void)show:(NSString *)content;

@end
