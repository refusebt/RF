//
//  RFUITextView.h
//  XiaoXunTong
//
//  Created by gouzhehua on 14-8-9.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARCMacros.h"
#import "UIPlaceHolderTextView.h"

@interface RFUITextView : UIView
{

}
@property (nonatomic, SAFE_ARC_STRONG) UIPlaceHolderTextView *tvInput;
@property (nonatomic, copy) BOOL (^blockShouldBeginEditing)(RFUITextView *);
@property (nonatomic, copy) BOOL (^blockShouldReturn)(RFUITextView *);
@property (nonatomic, assign) CGFloat paddingLeft;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, assign) BOOL isReturnToResign;

- (void)configUI;

@end
