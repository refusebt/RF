//
//  RFUILoadingView.h
//  RF
//
//  Created by 9sky on 14-4-17.
//  Copyright (c) 2014年 9sky. All rights reserved.
//

#import "RFUILoadingView.h"
#import "ARCMacros.h"

#pragma mark RFUILoadingViewParam

@interface RFUILoadingViewParam : NSObject
{
}
@property (nonatomic, SAFE_ARC_STRONG) NSString *category;
@property (nonatomic, assign) BOOL isShowActivity;
@property (nonatomic, SAFE_ARC_STRONG) NSString *title;
@property (nonatomic, assign) BOOL isAutoHide;

@end

@implementation RFUILoadingViewParam
@synthesize category;
@synthesize isShowActivity;
@synthesize title;
@synthesize isAutoHide;

- (id)init
{
	self = [super init];
    if (self)
    {
		
    }
    return self;
}

- (void)dealloc
{
	SAFE_ARC_RELEASE(category);
	SAFE_ARC_RELEASE(title);
	
	SAFE_ARC_SUPER_DEALLOC();
}

@end

#pragma mark RFUILoadingView

@interface RFUILoadingView ()
{
}
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, SAFE_ARC_STRONG) NSMutableDictionary *categorys;
@property (nonatomic, SAFE_ARC_STRONG) UIView *viewLoading;
@property (nonatomic, SAFE_ARC_STRONG) UILabel *lbTitle;
@property (nonatomic, SAFE_ARC_STRONG) UIActivityIndicatorView *activityView;

- (void)showLoadingInner:(RFUILoadingViewParam *)aParam;
- (void)hideInner;
- (void)forceHideInner;
- (void)showLoadingInnerWithCategoryParam:(RFUILoadingViewParam *)aParam;
- (void)hideInnerWithCategory:(NSString *)aCategory;
- (void)forceHideInnerWithCategory:(NSString *)aCategory;
- (void)displayLoadingView:(RFUILoadingViewParam *)aParam;
- (void)hideLoadingView;

@end

@implementation RFUILoadingView
@synthesize count;
@synthesize categorys;
@synthesize viewLoading;
@synthesize lbTitle;
@synthesize activityView;

- (id)init
{
	self = [super init];
    if (self)
    {
		count = 0;
		categorys = [[NSMutableDictionary alloc] init];
		
		viewLoading = [[UIView alloc] init];
		viewLoading.backgroundColor = RGBA2COLOR(51, 51, 51, 0.8);
		viewLoading.layer.cornerRadius = 6;
		viewLoading.userInteractionEnabled = NO;
		viewLoading.multipleTouchEnabled = NO;
		
		lbTitle = [[UILabel alloc] init];
		[lbTitle setFont:[UIFont systemFontOfSize:13]];
		lbTitle.textColor = [UIColor whiteColor];
		lbTitle.backgroundColor = [UIColor clearColor];
		lbTitle.textAlignment = NSTextAlignmentLeft;
		[viewLoading addSubview:lbTitle];
		
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activityView.frame = CGRectMake(5.0f, 8.0f, 20.0f, 20.0f);
		[viewLoading addSubview:activityView];
    }
    return self;
}

- (void)dealloc
{
	SAFE_ARC_RELEASE(categorys);
	SAFE_ARC_RELEASE(viewLoading);
	SAFE_ARC_RELEASE(lbTitle);
	SAFE_ARC_RELEASE(activityView);
	
    SAFE_ARC_SUPER_DEALLOC();
}

+ (RFUILoadingView *)shared
{
	static RFUILoadingView *s_loadingView = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		s_loadingView = [[RFUILoadingView alloc] init];
	});
	
	return s_loadingView;
}

+ (void)showLoading:(BOOL)bShowActivity title:(NSString *)aTitle autoHide:(BOOL)bAutoHide
{
	RFUILoadingViewParam *param = SAFE_ARC_AUTORELEASE([[RFUILoadingViewParam alloc] init]);
	param.category = @"";
	param.isShowActivity = bShowActivity;
	param.title = aTitle;
	param.isAutoHide = bAutoHide;
	
	RFUILoadingView *lv = [RFUILoadingView shared];
	[lv performSelectorOnMainThread:@selector(showLoadingInner:) withObject:param waitUntilDone:NO];
}

+ (void)hide
{
	RFUILoadingView *lv = [RFUILoadingView shared];
	[lv performSelectorOnMainThread:@selector(hideInner) withObject:nil waitUntilDone:NO];
}

+ (void)forceHide
{
	RFUILoadingView *lv = [RFUILoadingView shared];
	[lv performSelectorOnMainThread:@selector(forceHideInner) withObject:nil waitUntilDone:NO];
}

+ (void)showLoadingWithCategory:(NSString *)aCategory showActivity:(BOOL)bShowActivity title:(NSString *)aTitle autoHide:(BOOL)bAutoHide
{
	RFUILoadingViewParam *param = SAFE_ARC_AUTORELEASE([[RFUILoadingViewParam alloc] init]);
	param.category = aCategory;
	param.isShowActivity = bShowActivity;
	param.title = aTitle;
	param.isAutoHide = bAutoHide;
	
	RFUILoadingView *lv = [RFUILoadingView shared];
	
	[lv performSelectorOnMainThread:@selector(showLoadingInnerWithCategoryParam:) withObject:param waitUntilDone:NO];
}

+ (void)hideWithCategory:(NSString *)aCategory
{
	RFUILoadingView *lv = [RFUILoadingView shared];
	[lv performSelectorOnMainThread:@selector(hideInnerWithCategory:) withObject:aCategory waitUntilDone:NO];
}

+ (void)forceHideWithCategory:(NSString *)aCategory
{
	RFUILoadingView *lv = [RFUILoadingView shared];
	[lv performSelectorOnMainThread:@selector(forceHideInnerWithCategory:) withObject:aCategory waitUntilDone:NO];
}

- (void)showLoadingInner:(RFUILoadingViewParam *)aParam
{
	[self displayLoadingView:aParam];
	count++;
	
	if (aParam.isAutoHide)
	{
		[self performSelector:@selector(hideInner) withObject:nil afterDelay:3];
	}
	
	NSLog(@"loading count(showLoading):%ld", (long)(count));
}

- (void)hideInner
{
	// 减去计数
	count--;
	if (count <= 0)
	{
		[self hideLoadingView];
		count = 0;
	}
	
	NSLog(@"loading count(hide):%ld", (long)(count));
}

- (void)forceHideInner
{
	count = 0;
	[categorys removeAllObjects];
	[self hideLoadingView];
	
	NSLog(@"loading count(forceHide):%ld", (long)(count));
}

- (void)showLoadingInnerWithCategoryParam:(RFUILoadingViewParam *)aParam
{
	[self displayLoadingView:aParam];
	
	NSInteger categoryCount = [[categorys objectForKey:aParam.category] integerValue];
	if (categoryCount == 0)
	{
		// 首次调用，只加一次
		count++;
	}
	categoryCount++;
	[categorys setObject:[NSNumber numberWithInteger:categoryCount] forKey:aParam.category];
	
	if (aParam.isAutoHide)
	{
		[self performSelector:@selector(hideInnerWithCategory:) withObject:aParam.category afterDelay:3];
	}
	
	NSLog(@"loading count(showLoadingWithCategory):%ld", (long)(count));
}

- (void)hideInnerWithCategory:(NSString *)aCategory
{
	NSInteger categoryCount = [[categorys objectForKey:aCategory] integerValue];
	if (categoryCount > 0)
	{
		categoryCount--;
		if (categoryCount <= 0)
		{
			// 此类别计数为0，总计数只减一次
			count--;
			categoryCount = 0;
		}
	}
	else
	{
		categoryCount = 0;
	}
	[categorys setObject:[NSNumber numberWithInteger:categoryCount] forKey:aCategory];
	
	if (count <= 0)
	{
		[self hideLoadingView];
		count = 0;
	}
	
	NSLog(@"loading count(hideWithCategory):%ld", (long)(count));
}

- (void)forceHideInnerWithCategory:(NSString *)aCategory
{
	NSInteger categoryCount = [[categorys objectForKey:aCategory] integerValue];
	if (categoryCount > 0)
	{
		// 此类别计数为0，总计数只减一次
		count--;
	}
	categoryCount = 0;
	[categorys setObject:[NSNumber numberWithInteger:categoryCount] forKey:aCategory];
	
	if (count <= 0)
	{
		[self hideLoadingView];
		count = 0;
	}
	
	NSLog(@"loading count(forceHideWithCategory):%ld", (long)(count));
}

- (void)displayLoadingView:(RFUILoadingViewParam *)aParam
{
	NSLog(@"displayLoadingView");
	
	float _top_onKeyBoard = 50.0f;
	
	if ([NSString isEmpty:aParam.title])
	{
		if (count <= 0)
		{
			// 第一次使用默认标题
			aParam.title = NSLocalizedString(@"Loading...", nil);
		}
		else
		{
			// 如果已经存在一个标题，使用原有的
			aParam.title = lbTitle.text;
		}
	}
	
	float h = 36.0f;
	float w = 0;
    
	CGFloat titleWidth = [aParam.title widthWithFont:[UIFont systemFontOfSize:13]];
	
	// view
	if (aParam.isShowActivity)
	{
		w = titleWidth + 35 + 15;
		
		activityView.frame = CGRectMake(5.0f, 8.0f, 20.0f, 20.0f);
		activityView.hidden = NO;
		if (![activityView isAnimating])
		{
			[activityView startAnimating];
		}
	}
	else
	{
		w = titleWidth + 20;
		
		if ([activityView isAnimating])
		{
			[activityView stopAnimating];
		}
		activityView.hidden = YES;
	}
	[viewLoading removeFromSuperview];
	UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	[window addSubview:viewLoading];
	[viewLoading.layer removeAllAnimations];
	
	//==================================================
    //支持换行
    int row = (int)w / 300 + ((((int)w / 300) > 0)?1:0);
    if (w > 300)
        w = 300;
    if (row > 1)
    {
        lbTitle.numberOfLines = 0;
        h = 20 * row;
    }
    CGRect frmActivity = activityView.frame;
    frmActivity.origin.y = (h - frmActivity.size.height)/2;
    [activityView setFrame:frmActivity];
	//==================================================
    
    [viewLoading setFrame:CGRectMake((320.0f-w)/2, (480.0f-_top_onKeyBoard-h)/2, w, h)];
	[lbTitle setFrame:CGRectMake(aParam.isShowActivity?35.0f:10.0f, 0.0f, w-(aParam.isShowActivity?35.0f:10.0f), h)];
    lbTitle.text = aParam.title;
    
	viewLoading.hidden = NO;
}

- (void)hideLoadingView
{
	CATransition *animation = [CATransition animation];
	animation.duration = 1.0f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.removedOnCompletion = YES;
	animation.type = kCATransitionFade;
	viewLoading.hidden = YES;
	[viewLoading.layer removeAllAnimations];
	[viewLoading.layer addAnimation:animation forKey:@"hideLoadingView"];
}

@end
