//
//  UIImageView+RFImageWork.h
//  RFApp
//
//  Created by gouzhehua on 14-7-11.
//  Copyright (c) 2014年 skyinfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RFImageWork.h"

@interface UIImageView (RFImageWork)

- (void)setImageWithURL:(NSString *)url;

- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholderImage;

- (void)setImageWithURLRequest:(NSString *)url
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(RFImageWork *aWork))success
                       failure:(void (^)(RFImageWork *aWork))failure
				   downloading:(void (^)(RFImageWork *aWork))downloading;


- (RFImageWork *)imageWork;
- (void)setImageWork:(RFImageWork *)imageWork;
- (void)cancelImageWork;

@end
