//
//  UIImageView+RFImageWork.m
//  RFApp
//
//  Created by gouzhehua on 14-7-11.
//  Copyright (c) 2014年 skyinfo. All rights reserved.
//

#import "UIImageView+RFImageWork.h"
#import "RFCmdConfig.h"
#import "RFKit.h"
#import "RFStorageKit.h"
#import <objc/runtime.h>

static void * kRFUIImageViewImageWorkKey = "kRFUIImageViewImageWorkKey";

@implementation UIImageView (RFImageWork)

- (void)setImageWithURL:(NSString *)url
{
	[self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage
{
    [self setImageWithURLRequest:url placeholderImage:placeholderImage success:nil failure:nil downloading:nil];
}

- (void)setImageWithURLRequest:(NSString *)url
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(RFImageWork *aWork))success
                       failure:(void (^)(RFImageWork *aWork))failure
				   downloading:(void (^)(RFImageWork *aWork))downloading
{
	[self cancelImageWork];
	
	if ([NSString isEmpty:url])
	{
		self.image = placeholderImage;
		return;
	}
	else
	{
		RFCmdConfig *config = [RFCmdConfig defaultConfig];
		NSString *cachePath = [config cachePathWithUrl:url args:nil];
		if ([RFStorageKit isExist:cachePath])
		{
			self.image = SAFE_ARC_AUTORELEASE([[UIImage alloc] initWithContentsOfFile:cachePath]);
			return;
		}
		else
		{
			self.image = placeholderImage;
		}
	}
	
	__weak UIImageView *selfRef = self;
	RFImageWork *work = [[RFImageWork alloc] initWithUrl:url];
	work.successBlock = ^(RFImageWork *aWork)
	{
		selfRef.image = aWork.image;
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
	RFImageWork *work = [self imageWork];
	if (work != nil)
	{
		[work cancel];
		[self setImageWork:nil];
	}
}

@end
