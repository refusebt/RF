//
//  RFUIKit.h
//  RFApp
//
//  Created by gouzhehua on 14-6-25.
//  Copyright (c) 2014年 skyinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Frame2Bounds(frame)	\
	CGRectMake(0, 0, (frame).size.width, (frame).size.height)

@interface RFUIKit : NSObject

+ (CGFloat)screenHeight;				// 屏幕高度
+ (CGRect)screenAvailableWindowFrame;

+ (CGFloat)screenAvailableHeightIOS7;
+ (CGRect)screenAvailableFrameIOS7;
+ (CGFloat)screenAvailableHeightIOS6;
+ (CGRect)screenAvailableFrameIOS6;

+ (void)iosNoticeCountStyle:(UIView *)view shadowColor:(UIColor *)shadowColor;

+ (id)loadObjectFromNibName:(NSString *)aNibName class:(Class)aClass;

+ (NSMutableDictionary *)textAttributesWithFont:(UIFont *)aFont
									   colorDef:(const RFColorDef *)aColorDef
									  shadowDef:(const RFColorDef *)aShadowDef;

@end

#pragma mark UIButton (RFUIKit)

@interface UIButton (RFUIKit)

- (void)setTitleForAllState:(NSString *)title;
- (void)setBgImg:(UIImage *)bgImg clImg:(UIImage *)clImg;
- (void)setBgImg:(UIImage *)bgImg clImg:(UIImage *)clImg slImg:(UIImage *)slImg;
- (void)setBgImgWithName:(NSString *)bgImg clImg:(NSString *)clImg stretchLeft:(NSInteger)left stretchTop:(NSInteger)top;
- (void)setBgImgWithName:(NSString *)bgImg clImg:(NSString *)clImg slImg:(NSString *)slImg stretchLeft:(NSInteger)left stretchTop:(NSInteger)top;

@end

#pragma mark UIView (RFUIKit)

@interface UIView (RFUIKit)

- (void)roundedViewWithRadius:(CGFloat)radius;
- (UIImage *)toImage;

- (void)setFrameLeft:(CGFloat)left;
- (void)setFrameTop:(CGFloat)top;
- (void)setFrameOrigin:(CGFloat)left top:(CGFloat)top;
- (void)setFrameHeight:(CGFloat)height;
- (void)setFrameWidth:(CGFloat)width;
- (void)setFrameSize:(CGFloat)height width:(CGFloat)width;
- (void)setFrameSize:(CGSize)size;

- (void)fillSuperView;

- (void)setTapActionWithTarget:(id)target selector:(SEL)selector;

// 调试用
- (void)borderRed;
- (void)borderOrange;
- (void)borderYellow;
- (void)borderGreen;
- (void)borderCyan;
- (void)borderBlue;
- (void)borderPurple;
- (void)borderBlack;
- (void)borderWhite;
- (void)borderGray;

@end

#pragma mark UIImage (RFUIKit)
@interface UIImage (RFUIKit)
- (UIImage *)imageScaleToSize:(CGSize)size;
- (UIImage *)captureWithSize:(CGSize)size;
- (UIImage *)originImg;
- (UIImage *)imageWithNoOrientation;

+ (UIImage *)imageStretchWithName:(NSString *)name left:(NSInteger)left top:(NSInteger)top;
+ (UIImage *)colorImage:(UIColor *)aColor;
+ (UIImage *)colorImageWithDef:(const RFColorDef *)colorDef;

@end

#pragma mark UIViewController (ESUIKit)

@interface UIViewController (ESUIKit)

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)bAnimated;
- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)bAnimated statusBarStyle:(UIStatusBarStyle)statusBarStyle;
- (void)dismissViewController;	// 关闭自己打开的模式框
- (void)dismissMe;				// 关闭作为模式框的自己

- (void)popBackMe;

@end

#pragma mark UITableView (ESUIKit)

@interface UITableView (ESUIKit)
- (void)noHeader;
- (void)noFooter;
@end

#pragma mark UITableViewCell (ESUIKit)

@interface UITableViewCell (ESUIKit)
- (void)noneSelectedStyle;
- (void)separatorLeft:(CGFloat)left right:(CGFloat)right;
@end
