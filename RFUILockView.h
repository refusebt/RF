//
//  RFUILockView.h
//  RF
//
//  Created by GZH on 14-4-17.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFUILockView : NSObject
{
}

+ (RFUILockView *)shared;

- (void)lockWholeView;
- (void)unlockWholeView;

@end