//
//  RFColor.m
//  RF
//
//  Created by gouzhehua on 14-6-25.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFColor.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ARCMacros.h"
#import "RFKit.h"

#pragma mark RFColor

@implementation RFColor

+ (UIColor *)colorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha
{
	return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

+ (UIColor *)colorWithDef:(const RFColorDef *)colorDef
{
	if (colorDef == kColorDefNull)
		return nil;
	
	return RGBA2COLOR(colorDef->r, colorDef->g, colorDef->b, colorDef->a);
}

@end

#pragma mark UIButton (RFColor)

@implementation UIButton (RFColor)
- (void)setTitleColorWithDef:(const RFColorDef *)colorDef forState:(UIControlState)state
{
	if (colorDef == kColorDefNull) colorDef = kColorDefClear;
	
	[self setTitleColor:DEF2COLOR(colorDef) forState:state];
}

- (void)setTitleColorWithDef:(const RFColorDef *)titleDef shadowDef:(const RFColorDef *)shadowDef forState:(UIControlState)state
{
	if (titleDef == kColorDefNull) titleDef = kColorDefClear;
	if (shadowDef == kColorDefNull) shadowDef = kColorDefClear;
	
	[self setTitleColor:DEF2COLOR(titleDef) forState:state];
	[self setTitleShadowColor:DEF2COLOR(shadowDef) forState:state];
	self.titleLabel.shadowOffset = CGSizeMake(shadowDef->ox, shadowDef->oy);
}
@end

#pragma mark UILabel (RFColor)

@implementation UILabel (RFColor)

- (void)setColorWithDef:(const RFColorDef *)colorDef
{
	if (colorDef == kColorDefNull) colorDef = kColorDefClear;
	
	self.textColor = DEF2COLOR(colorDef);
	self.highlightedTextColor = DEF2COLOR(colorDef);
}

- (void)setShadowColorWithDef:(const RFColorDef *)colorDef
{
	if (colorDef == kColorDefNull) colorDef = kColorDefClear;
	
	self.shadowColor = DEF2COLOR(colorDef);
	self.shadowOffset = CGSizeMake(colorDef->ox, colorDef->oy);
}

@end

#pragma mark UIView (RFColor)

@implementation UIView (RFColor)

- (void)setBackgroundColorWithDef:(const RFColorDef *)colorDef
{
	if (colorDef == kColorDefNull) colorDef = kColorDefClear;
	
	self.backgroundColor = DEF2COLOR(colorDef);
}

- (void)setBorderWithDef:(const RFColorDef *)colorDef width:(CGFloat)width
{
	if (colorDef == kColorDefNull) colorDef = kColorDefClear;
	
	[self.layer setBorderColor:DEF2COLOR(colorDef).CGColor];
	[self.layer setBorderWidth:width];
}

@end

#pragma mark UIPageControl (RFColor)

@implementation UIPageControl (RFColor)

- (void)setColorWithNormalDef:(const RFColorDef *)normalDef hightedDef:(const RFColorDef *)hightedDef
{
	if (normalDef == kColorDefNull) normalDef = kColorDefClear;
	if (hightedDef == kColorDefNull) hightedDef = kColorDefClear;
	
	if (IS_IOS6)
	{
		self.currentPageIndicatorTintColor = DEF2COLOR(hightedDef);
		self.pageIndicatorTintColor = DEF2COLOR(normalDef);
	}
}

@end