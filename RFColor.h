//
//  RFColor.h
//  RF
//
//  Created by gouzhehua on 14-6-25.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct tagRFColorDef
{
	float r;
	float g;
	float b;
	float a;
	float ox;
	float oy;
}
RFColorDef;

#define RGBA2COLOR(r,g,b,a)	\
	[RFColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]

#define HEX2COLOR(rgbValue,a)	\
	[RFColor colorWithRed:((rgbValue & 0xFF0000) >> 16) green:((rgbValue & 0xFF00) >> 8) blue:(rgbValue & 0xFF) alpha:(a)]

#define DEF2COLOR(def)	\
	[RFColor colorWithDef:(def)]

#define COLOR_DEF(NAME, R, G, B, A, OX, OY) \
	static RFColorDef (CCD##NAME) = {(R),(G),(B),(A),(OX),(OY)};	\
	static RFColorDef * const (NAME) = &(CCD##NAME);

#define COLOR_HEX_DEF(NAME, rgbValue, A, OX, OY) \
    static RFColorDef (CCD##NAME) = {(((float)((rgbValue & 0xFF0000) >> 16))),(((float)((rgbValue & 0xFF00) >> 8))),(((float)(rgbValue & 0xFF))),(A),(OX),(OY)};	\
    static RFColorDef * const (NAME) = &(CCD##NAME);

// 预定义颜色
static RFColorDef * const kColorDefNull = NULL;						// 空
COLOR_DEF(kColorDefClear,			0,0,0,0,				0,0)	// 透明

#pragma mark RFColor

@interface RFColor : NSObject

+ (UIColor *)colorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
+ (UIColor *)colorWithDef:(const RFColorDef *)colorDef;

@end

#pragma mark UIButton (RFColor)

@interface UIButton (RFColor)
- (void)setTitleColorWithDef:(const RFColorDef *)colorDef forState:(UIControlState)state;
- (void)setTitleColorWithDef:(const RFColorDef *)titleDef shadowDef:(const RFColorDef *)shadowDef forState:(UIControlState)state;
@end

#pragma mark UILabel (RFColor)

@interface UILabel (RFColor)

- (void)setColorWithDef:(const RFColorDef *)colorDef;
- (void)setShadowColorWithDef:(const RFColorDef *)colorDef;

@end

#pragma mark UIView (RFColor)

@interface UIView (RFColor)

- (void)setBackgroundColorWithDef:(const RFColorDef *)colorDef;
- (void)setBorderWithDef:(const RFColorDef *)colorDef width:(CGFloat)width;

@end

#pragma mark UIPageControl (RFColor)

@interface UIPageControl (RFColor)

- (void)setColorWithNormalDef:(const RFColorDef *)normalDef hightedDef:(const RFColorDef *)hightedDef;

@end