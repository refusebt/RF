//
//  UIButton+RFImageWork.h
//  XiaoXunTong
//
//  Created by gouzhehua on 14-8-11.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFWork.h"

@interface UIButton (RFImageWork)

- (void)setImageForState:(UIControlState)state
                 withURL:(NSString *)url;

- (void)setImageForState:(UIControlState)state
                 withURL:(NSString *)url
        placeholderImage:(UIImage *)placeholderImage;

- (void)setImageForState:(UIControlState)state
				 withURL:(NSString *)url
		placeholderImage:(UIImage *)placeholderImage
				 success:(void (^)(RFImageWork *aWork))success
				 failure:(void (^)(RFImageWork *aWork))failure
			 downloading:(void (^)(RFImageWork *aWork))downloading;

- (void)setBackgroundImageForState:(UIControlState)state
                           withURL:(NSString *)url;

- (void)setBackgroundImageForState:(UIControlState)state
                           withURL:(NSString *)url
                  placeholderImage:(UIImage *)placeholderImage;

- (void)setBackgroundImageForState:(UIControlState)state
						   withURL:(NSString *)url
				  placeholderImage:(UIImage *)placeholderImage
						   success:(void (^)(RFImageWork *aWork))success
						   failure:(void (^)(RFImageWork *aWork))failure
					   downloading:(void (^)(RFImageWork *aWork))downloading;

- (RFImageWork *)imageWork;
- (void)setImageWork:(RFImageWork *)imageWork;
- (void)cancelImageWork;

- (RFImageWork *)backgroundImageWork;
- (void)setBackgroundImageWork:(RFImageWork *)imageWork;
- (void)cancelBackgroundImageWork;

- (void)cancelAllImageWork;

@end
