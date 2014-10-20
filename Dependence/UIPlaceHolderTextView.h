//
//  UIPlaceHolderTextView.h
//  GZH
//
//  Created by shenyuexin on 11-11-18.
//  Copyright (c) 2011年 GZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCMacros.h"

@interface UIPlaceHolderTextView : UITextView
{
    NSString *placeholder;
    UIColor *placeholderColor;
@private
    UILabel *placeHolderLabel;
}
@property (nonatomic, SAFE_ARC_STRONG) UILabel *placeHolderLabel;
@property (nonatomic, SAFE_ARC_STRONG) NSString *placeholder;
@property (nonatomic, SAFE_ARC_STRONG) UIColor *placeholderColor;

- (void)textChanged:(NSNotification*)notification;

@end
