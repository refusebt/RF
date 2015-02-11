//
//  RFUICountDownButton.h
//  RF
//
//  Created by gouzhehua on 14-4-18.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RFUICountDownButton : UIButton
{
}

- (void)setEnabled:(BOOL)enabled;
- (void)setEnabled:(BOOL)enabled wait:(NSInteger)full;

@end
