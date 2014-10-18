//
//  UIButton+RFImageWork.m
//  XiaoXunTong
//
//  Created by gouzhehua on 14-8-11.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "UIButton+RFImageWork.h"
#import <objc/runtime.h>
#import "RFKit.h"
#import "RFStorageKit.h"

static void * kRFUIImageViewImageWorkKey = "kRFUIImageViewImageWorkKey";
static void * kRFUIImageViewBackgroundImageWorkKey = "kRFUIImageViewBackgroundImageWorkKey";

@implementation UIButton (RFImageWork)

- (void)setImageForState:(UIControlState)state
                 withURL:(NSString *)url
{
	[self setImageForState:state withURL:url placeholderImage:nil];
}

- (void)setImageForState:(UIControlState)state
                 withURL:(NSString *)url
        placeholderImage:(UIImage *)placeholderImage
{
	[self setImageForState:state
				   withURL:url
		  placeholderImage:placeholderImage
				   success:nil
				   failure:nil
			   downloading:nil];
}

- (void)setImageForState:(UIControlState)state
				 withURL:(NSString *)url
		placeholderImage:(UIImage *)placeholderImage
				 success:(void (^)(RFImageWork *aWork))success
				 failure:(void (^)(RFImageWork *aWork))failure
			 downloading:(void (^)(RFImageWork *aWork))downloading
{
	[self cancelImageWork];
	
	if ([NSString isEmpty:url])
	{
		[self setImage:placeholderImage forState:state];
		return;
	}
	else
	{
		RFCmdConfig *config = [RFCmdConfig defaultConfig];
		NSString *cachePath = [config cachePathWithUrl:url args:nil];
		if ([RFStorageKit isExist:cachePath])
		{
			[self setImage:SAFE_ARC_AUTORELEASE([[UIImage alloc] initWithContentsOfFile:cachePath]) forState:state];
			return;
		}
		else
		{
			[self setImage:placeholderImage forState:state];
		}
	}
	
	__weak UIButton *selfRef = self;
	RFImageWork *work = [[RFImageWork alloc] initWithUrl:url];
	work.successBlock = ^(RFImageWork *aWork)
	{
		[selfRef setImage:aWork.image forState:state];
		[self setImageWork:nil];
		if (success != nil)
		{
			success(aWork);
		}
	};
	work.failedBlock = ^(RFImageWork *aWork)
	{
		[self setImageWork:nil];
		if (failure != nil)
		{
			failure(aWork);
		}
	};
	work.downloadingBlock = ^(RFImageWork *aWork)
	{
		if (downloading != nil)
		{
			downloading(aWork);
		}
	};
	[self setImageWork:work];
	[work startRelyOn:nil];
}

- (void)setBackgroundImageForState:(UIControlState)state
                           withURL:(NSString *)url
{
	[self setBackgroundImageForState:state withURL:url placeholderImage:nil];
}

- (void)setBackgroundImageForState:(UIControlState)state
                           withURL:(NSString *)url
                  placeholderImage:(UIImage *)placeholderImage
{
	[self setBackgroundImageForState:state
							 withURL:url
					placeholderImage:placeholderImage
							 success:nil
							 failure:nil
						 downloading:nil];
}

- (void)setBackgroundImageForState:(UIControlState)state
						   withURL:(NSString *)url
				  placeholderImage:(UIImage *)placeholderImage
						   success:(void (^)(RFImageWork *aWork))success
						   failure:(void (^)(RFImageWork *aWork))failure
					   downloading:(void (^)(RFImageWork *aWork))downloading
{
	[self cancelBackgroundImageWork];
	
	if ([NSString isEmpty:url])
	{
		[self setBackgroundImage:placeholderImage forState:state];
		return;
	}
	else
	{
		RFCmdConfig *config = [RFCmdConfig defaultConfig];
		NSString *cachePath = [config cachePathWithUrl:url args:nil];
		if ([RFStorageKit isExist:cachePath])
		{
			[self setBackgroundImage:SAFE_ARC_AUTORELEASE([[UIImage alloc] initWithContentsOfFile:cachePath]) forState:state];
			return;
		}
		else
		{
			[self setBackgroundImage:placeholderImage forState:state];
		}
	}
	
	__weak UIButton *selfRef = self;
	RFImageWork *work = [[RFImageWork alloc] initWithUrl:url];
	work.successBlock = ^(RFImageWork *aWork)
	{
		[selfRef setBackgroundImage:aWork.image forState:state];
		[self setBackgroundImageWork:nil];
		if (success != nil)
		{
			success(aWork);
		}
	};
	work.failedBlock = ^(RFImageWork *aWork)
	{
		[self setBackgroundImageWork:nil];
		if (failure != nil)
		{
			failure(aWork);
		}
	};
	work.downloadingBlock = ^(RFImageWork *aWork)
	{
		if (downloading != nil)
		{
			downloading(aWork);
		}
	};
	[self setImageWork:work];
	[work startRelyOn:nil];
}

- (RFImageWork *)imageWork
{
	return (RFImageWork *)objc_getAssociatedObject(self, kRFUIImageViewImageWorkKey);
}

- (void)setImageWork:(RFImageWork *)imageWork
{
	objc_setAssociatedObject(self, kRFUIImageViewImageWorkKey, imageWork, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cancelImageWork
{
	[[self imageWork] cancel];
	[self setImageWork:nil];
}

- (RFImageWork *)backgroundImageWork
{
	return (RFImageWork *)objc_getAssociatedObject(self, kRFUIImageViewBackgroundImageWorkKey);
}

- (void)setBackgroundImageWork:(RFImageWork *)imageWork
{
	objc_setAssociatedObject(self, kRFUIImageViewBackgroundImageWorkKey, imageWork, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cancelBackgroundImageWork
{
	[[self backgroundImageWork] cancel];
	[self setBackgroundImageWork:nil];
}

- (void)cancelAllImageWork
{
	RFImageWork *work = [self imageWork];
	if (work != nil)
	{
		[work cancel];
		[self setImageWork:nil];
	}
	
	work = [self backgroundImageWork];
	if (work != nil)
	{
		[work cancel];
		[self setBackgroundImageWork:nil];
	}
}

@end
