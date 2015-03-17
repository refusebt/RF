//
//  RFUIAngleView.m
//  KeDao
//
//  Created by gouzhehua on 15-3-4.
//  Copyright (c) 2015年 skyInfo. All rights reserved.
//

#import "RFUIAngleView.h"

@implementation RFUIAngleView
@synthesize imgBG = _imgBG;
@synthesize progress = _progress;
@synthesize clockwise = _clockwise;
@synthesize coverColor = _coverColor;
@synthesize isMask = _isMask;

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		_imgBG = nil;
		_progress = 1.0;
		_clockwise = 0;
		_coverColor = RGBA2COLOR(0, 0, 0, 1);
		_isMask = YES;
	}
	return self;
}

- (void)awakeFromNib
{
	_imgBG = nil;
	_progress = 1.0;
	_clockwise = 0;
	_coverColor = RGBA2COLOR(0, 0, 0, 1);
	_isMask = YES;
}

- (void)drawRect:(CGRect)rect
{
	_progress = 0.7;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGPoint center = self.center;
	CGFloat minSide = MIN(self.bounds.size.height, self.bounds.size.width);
	CGFloat radius = minSide / 2;
	CGFloat startAngle = -1*M_PI_2;
	CGFloat endAngle = -1*M_PI_2 + (2*M_PI * _progress);
	
	// 背景色
	CGContextSaveGState(context);
	CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
	CGContextFillRect(context, rect);
	CGContextRestoreGState(context);
	
	// 背景图
	if (_imgBG != nil)
	{
		CGContextSaveGState(context);
		CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
		CGContextTranslateCTM(context, 0, rect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
		CGContextDrawImage(context, rect, [_imgBG CGImage]);
		CGContextRestoreGState(context);
	}
	
	// 角度
	{
		CGContextSaveGState(context);
		CGContextSetFillColorWithColor(context, _coverColor.CGColor);
		CGContextMoveToPoint(context, center.x, center.y);
		CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, _clockwise);
		CGContextClosePath(context);
		if (_isMask)
			CGContextSetBlendMode(context, kCGBlendModeXOR);
		else
			CGContextSetBlendMode(context, kCGBlendModeCopy);
		CGContextDrawPath(context, kCGPathFill);
		CGContextRestoreGState(context);
	}
}

@end
