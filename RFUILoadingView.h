//
//  RFUILoadingView.h
//  RF
//
//  Created by 9sky on 14-4-17.
//  Copyright (c) 2014年 9sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFUILoadingView : NSObject

+ (RFUILoadingView *)shared;

+ (void)showLoading:(BOOL)bShowActivity title:(NSString *)aTitle autoHide:(BOOL)bAutoHide;
+ (void)hide;
+ (void)forceHide;

// 类别共用一个引数，用于频繁调用且无法成对隐藏的情况，比如播放器
+ (void)showLoadingWithCategory:(NSString *)aCategory showActivity:(BOOL)bShowActivity title:(NSString *)aTitle autoHide:(BOOL)bAutoHide;
+ (void)hideWithCategory:(NSString *)aCategory;
+ (void)forceHideWithCategory:(NSString *)aCategory;

@end

