//
//  RFUIAngleView.h
//  KeDao
//
//  Created by gouzhehua on 15-3-4.
//  Copyright (c) 2015年 skyInfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RFUIAngleView : UIView
{

}
@property (nonatomic, strong) UIImage *imgBG;		// 背景图，如无用背景色填充
@property (nonatomic, assign) CGFloat progress;		// 0-1
@property (nonatomic, assign) CGFloat clockwise;	// 0顺时针
@property (nonatomic, strong) UIColor *coverColor;	// 角度覆盖的颜色
@property (nonatomic, assign) BOOL isMask;			// 遮罩模式

@end
