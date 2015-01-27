//
//  RFUIWindow.h
//  RF
//
//  Created by gouzhehua on 15-1-27.
//  Copyright (c) 2015年 RF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFUIWindowController : UIViewController

@end

@interface RFUIWindow : UIWindow
@property (nonatomic, strong) void(^bgClickBlock)();

- (id)init;

- (void)show;
- (void)dismiss;

- (UIView *)bgView;
- (void)onBgClick:(id)sender;

@end
