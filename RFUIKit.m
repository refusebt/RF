//
//  RFUIKit.m
//  RFApp
//
//  Created by gouzhehua on 14-6-25.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFUIKit.h"
#import "RFKit.h"
#import "ARCMacros.h"

static CGFloat s_screenHeight = -1;

@implementation RFUIKit

+ (CGFloat)screenHeight
{
	if (s_screenHeight > 0)
		return s_screenHeight;
	
	CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat height = bounds.size.height;
	s_screenHeight = height;
	return s_screenHeight;
}

+ (CGRect)screenAvailableWindowFrame
{
	return [[UIScreen mainScreen] bounds];
}

+ (CGFloat)screenAvailableHeightIOS7
{
	return [RFUIKit screenHeight];
}

+ (CGRect)screenAvailableFrameIOS7
{
	if (IS_IOS7)
	{
		return [RFUIKit screenAvailableWindowFrame];
	}
	else
	{
		CGRect frame = [[UIScreen mainScreen] bounds];
		if (![UIApplication sharedApplication].statusBarHidden)
		{
			frame.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height;
			frame.origin.y += [UIApplication sharedApplication].statusBarFrame.size.height;
		}
		return frame;
	}
}

+ (CGFloat)screenAvailableHeightIOS6
{
	CGFloat height = [RFUIKit screenHeight];
	if (![UIApplication sharedApplication].statusBarHidden)
	{
		height -= [UIApplication sharedApplication].statusBarFrame.size.height;
	}
	return height;
}

+ (CGRect)screenAvailableFrameIOS6
{
	if (IS_IOS7)
	{
		CGRect frame = [[UIScreen mainScreen] bounds];
		if (![UIApplication sharedApplication].statusBarHidden)
		{
			frame.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height;
			frame.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height;
		}
		return frame;
	}
	else
	{
		CGRect frame = [[UIScreen mainScreen] bounds];
		if (![UIApplication sharedApplication].statusBarHidden)
		{
			frame.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height;
			frame.origin.y = 0;
		}
		return frame;
	}
}

+ (void)iosNoticeCountStyle:(UIView *)view shadowColor:(UIColor *)shadowColor
{
	float height = view.frame.size.height;
	float width = view.frame.size.width;
	float r = MIN(height, width) / 2;
	[view roundedViewWithRadius:r];
	[view.layer setBorderColor:[UIColor whiteColor].CGColor];
	[view.layer setBorderWidth:1];
	view.layer.shadowRadius = 3;
	view.layer.shadowColor = shadowColor.CGColor;
	view.layer.shadowOffset = CGSizeMake(0, 0);
	view.layer.shadowOpacity = 0.8;
	view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.bounds] CGPath];
}

+ (id)loadObjectFromNibName:(NSString *)aNibName class:(Class)aClass
{
	NSArray* objects = [[NSBundle mainBundle] loadNibNamed:aNibName owner:nil options:nil];
    for (id object in objects)
	{
        if ([object isKindOfClass:aClass])
		{
            return object;
        }
    }
	return nil;
}

+ (NSMutableDictionary *)textAttributesWithFont:(UIFont *)aFont
									   colorDef:(const RFColorDef *)aColorDef
									  shadowDef:(const RFColorDef *)aShadowDef
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	if (aFont != nil)
	{
		if (IS_IOS7)
		{
			[dict setObject:aFont forKey:NSFontAttributeName];
		}
		else
		{
			[dict setObject:aFont forKey:UITextAttributeFont];
		}
	}
	
	if (aColorDef != kColorDefNull)
	{
		if (IS_IOS7)
		{
			[dict setObject:DEF2COLOR(aColorDef) forKey:NSForegroundColorAttributeName];
		}
		else
		{
			[dict setObject:DEF2COLOR(aColorDef) forKey:UITextAttributeTextColor];
		}
	}
	
	if (aShadowDef != kColorDefNull)
	{
		if (IS_IOS7)
		{
			NSShadow *shadow = SAFE_ARC_AUTORELEASE([[NSShadow alloc] init]);
			shadow.shadowColor = DEF2COLOR(aShadowDef);
			shadow.shadowOffset = CGSizeMake(aShadowDef->ox, aShadowDef->oy);
			[dict setObject:shadow forKey:NSShadowAttributeName];
		}
		else
		{
			[dict setObject:DEF2COLOR(aShadowDef) forKey:UITextAttributeTextShadowColor];
			[dict setObject:[NSValue valueWithUIOffset:UIOffsetMake(aShadowDef->ox, aShadowDef->oy)] forKey:UITextAttributeTextShadowOffset];
		}
	}
	
	return dict;
}

@end

#pragma mark UIButton (RFUIKit)

@implementation UIButton (RFUIKit)

- (void)setTitleForAllState:(NSString *)title
{
	[self setTitle:title forState:UIControlStateNormal];
	[self setTitle:title forState:UIControlStateSelected];
	[self setTitle:title forState:UIControlStateHighlighted];
	[self setTitle:title forState:UIControlStateDisabled];
}

- (void)setBgImg:(UIImage *)bgImg clImg:(UIImage *)clImg
{
	if (bgImg != nil)
	{
		[self setBackgroundImage:bgImg forState:UIControlStateNormal];
	}
	if (clImg != nil)
	{
		[self setBackgroundImage:clImg forState:UIControlStateHighlighted];
	}
}

- (void)setBgImg:(UIImage *)bgImg clImg:(UIImage *)clImg slImg:(UIImage *)slImg
{
	if (bgImg != nil)
	{
		[self setBackgroundImage:bgImg forState:UIControlStateNormal];
	}
	if (clImg != nil)
	{
		[self setBackgroundImage:clImg forState:UIControlStateHighlighted];
	}
	if (slImg != nil)
	{
		[self setBackgroundImage:slImg forState:UIControlStateSelected];
	}
}

- (void)setBgImgWithName:(NSString *)bgImg clImg:(NSString *)clImg stretchLeft:(NSInteger)left stretchTop:(NSInteger)top
{
	UIImage *bg = nil;
	UIImage *bgCl = nil;
	if (![NSString isEmpty:bgImg])
		bg = [UIImage imageStretchWithName:bgImg left:left top:top];
	if (![NSString isEmpty:clImg])
		bgCl = [UIImage imageStretchWithName:clImg left:left top:top];
	[self setBgImg:bg clImg:bgCl];
}

- (void)setBgImgWithName:(NSString *)bgImg clImg:(NSString *)clImg slImg:(NSString *)slImg stretchLeft:(NSInteger)left stretchTop:(NSInteger)top
{
	UIImage *bg = nil;
	UIImage *bgCl = nil;
	UIImage *bgSl = nil;
	if (![NSString isEmpty:bgImg])
		bg = [UIImage imageStretchWithName:bgImg left:left top:top];
	if (![NSString isEmpty:clImg])
		bgCl = [UIImage imageStretchWithName:clImg left:left top:top];
	if (![NSString isEmpty:slImg])
		bgSl = [UIImage imageStretchWithName:slImg left:left top:top];
	[self setBgImg:bg clImg:bgCl slImg:bgSl];
}

@end

#pragma mark UIView (RFUIKit)

@implementation UIView (RFUIKit)

- (void)roundedViewWithRadius:(CGFloat)radius
{
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius = radius;
}

- (UIImage *)toImage
{
	float scale = [[UIScreen mainScreen] scale];
	CGSize size = self.bounds.size;
	UIGraphicsBeginImageContextWithOptions(size, YES, scale);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (void)setFrameLeft:(CGFloat)left
{
	CGRect frame = self.frame;
	frame.origin.x = left;
	self.frame = frame;
}

- (void)setFrameTop:(CGFloat)top
{
	CGRect frame = self.frame;
	frame.origin.y = top;
	self.frame = frame;
}

- (void)setFrameOrigin:(CGFloat)left top:(CGFloat)top
{
	CGRect frame = self.frame;
	frame.origin.x = left;
	frame.origin.y = top;
	self.frame = frame;
}

- (void)setFrameHeight:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (void)setFrameWidth:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (void)setFrameSize:(CGFloat)height width:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.height = height;
	frame.size.width = width;
	self.frame = frame;
}

- (void)setFrameSize:(CGSize)size
{
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

- (void)fillSuperView
{
	UIView *sv = self.superview;
	if (sv != nil)
	{
		CGRect rect = CGRectZero;
		rect.size = sv.frame.size;
		self.frame = rect;
	}
}

- (void)setTapActionWithTarget:(id)target selector:(SEL)selector
{
	self.userInteractionEnabled = YES;
	UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
	[self addGestureRecognizer:gr];
}

- (void)borderRed
{
	[self.layer setBorderColor:[UIColor redColor].CGColor];
	[self.layer setBorderWidth:1];
}

- (void)borderOrange
{
	[self.layer setBorderColor:[UIColor orangeColor].CGColor];
	[self.layer setBorderWidth:1];
}

- (void)borderYellow
{
	[self.layer setBorderColor:[UIColor yellowColor].CGColor];
	[self.layer setBorderWidth:1];
}

- (void)borderGreen
{
	[self.layer setBorderColor:[UIColor greenColor].CGColor];
	[self.layer setBorderWidth:1];
}

- (void)borderCyan
{
	[self.layer setBorderColor:[UIColor cyanColor].CGColor];
	[self.layer setBorderWidth:1];
}

- (void)borderBlue
{
	[self.layer setBorderColor:[UIColor blueColor].CGColor];
	[self.layer setBorderWidth:1];
}

- (void)borderPurple
{
	[self.layer setBorderColor:[UIColor purpleColor].CGColor];
	[self.layer setBorderWidth:1];
}

- (void)borderBlack
{
	[self.layer setBorderColor:[UIColor blackColor].CGColor];
	[self.layer setBorderWidth:1];
}

- (void)borderWhite
{
	[self.layer setBorderColor:[UIColor whiteColor].CGColor];
	[self.layer setBorderWidth:1];
}

- (void)borderGray
{
	[self.layer setBorderColor:[UIColor grayColor].CGColor];
	[self.layer setBorderWidth:1];
}

@end

#pragma mark UIImage (RFUIKit)
@implementation UIImage (RFUIKit)

- (UIImage *)imageScaleToSize:(CGSize)size
{
	UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)captureWithSize:(CGSize)size
{
	CGFloat imgWidth = CGImageGetWidth(self.CGImage);
	CGFloat imgHeight = CGImageGetHeight(self.CGImage);
	CGFloat width = size.width;
	CGFloat height = size.height;
    CGFloat adjustImgWidth = 0;
	CGFloat adjustImgHeight = 0;
    UIImage *img_capture = nil;
	
	// 截取
    if ((imgHeight/height)>(imgWidth/width))
    {
        adjustImgWidth = imgWidth;
        adjustImgHeight = (imgWidth/width)*height;
        CGRect rect = CGRectMake(0, (imgHeight-adjustImgHeight)/2, adjustImgWidth, adjustImgHeight);
		CGImageRef imgRef = CGImageCreateWithImageInRect(self.CGImage, rect);
        img_capture=[UIImage imageWithCGImage:imgRef];
		CGImageRelease(imgRef);
    }
    else
    {
        adjustImgHeight = imgHeight;
        adjustImgWidth = (imgHeight/height)*width;
        CGRect rect = CGRectMake((imgWidth-adjustImgWidth)/2, 0, adjustImgWidth, adjustImgHeight);
		CGImageRef imgRef = CGImageCreateWithImageInRect(self.CGImage, rect);
        img_capture = [UIImage imageWithCGImage:imgRef];
		CGImageRelease(imgRef);
    }
	
	// 缩放
	UIImage* ret = [img_capture imageScaleToSize:CGSizeMake(width, height)];
	return [UIImage imageWithCGImage:ret.CGImage scale:1 orientation:self.imageOrientation];
}

- (UIImage *)originImg
{
	if (IS_IOS7)
	{
		return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	}
	else
	{
		return self;
	}
}

- (UIImage *)imageWithNoOrientation
{
	UIImage *aImage = self;
	
	// No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
	
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
	
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
			
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
			
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
	
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
			
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
	
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
			
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
	
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)imageStretchWithName:(NSString *)name left:(NSInteger)left top:(NSInteger)top
{
	return [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, top, left) resizingMode:UIImageResizingModeStretch];
}

+ (UIImage *)colorImage:(UIColor *)aColor
{
	CGSize imageSize = CGSizeMake(10, 10);
	UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
	[aColor set];
	UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
	UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return [pressedColorImg resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
}

+ (UIImage *)colorImageWithDef:(const RFColorDef *)colorDef
{
	CGSize imageSize = CGSizeMake(10, 10);
	UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
	[[UIColor colorWithRed:colorDef->r/255.0 green:colorDef->g/255.0 blue:colorDef->b/255.0 alpha:colorDef->a] set];
	UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
	UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return [pressedColorImg resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
}

@end

#pragma mark UIViewController (ESUIKit)

@implementation UIViewController (ESUIKit)

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)bAnimated
{
	[self presentViewController:viewController animated:bAnimated completion:^(){}];
}

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)bAnimated statusBarStyle:(UIStatusBarStyle)statusBarStyle
{
	[UIApplication sharedApplication].statusBarHidden = NO;
	[UIApplication sharedApplication].statusBarStyle = statusBarStyle;
	[self presentViewController:viewController animated:bAnimated completion:^(){}];
}

- (void)dismissViewController
{
	[self dismissViewControllerAnimated:YES completion:^(){
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
	}];
}

- (void)dismissMe
{
	[self.presentingViewController dismissViewControllerAnimated:YES completion:^(){
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
	}];
}

- (void)popBackMe
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end

#pragma mark UITableView (ESUIKit)

@implementation UITableView (ESUIKit)

- (void)noHeader
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	view.backgroundColor = [UIColor clearColor];
	self.tableHeaderView = view;
}

- (void)noFooter
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	view.backgroundColor = [UIColor clearColor];
	self.tableFooterView = view;
}
@end

#pragma mark UITableViewCell (ESUIKit)

@implementation UITableViewCell (ESUIKit)

- (void)noneSelectedStyle
{
	UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
	selectedBackgroundView.backgroundColor = [UIColor clearColor];
	self.selectedBackgroundView = selectedBackgroundView;
}

- (void)separatorLeft:(CGFloat)left right:(CGFloat)right
{
	if (IS_IOS7)
	{
		self.separatorInset = UIEdgeInsetsMake(0, left, 0, right);
	}
}

@end
