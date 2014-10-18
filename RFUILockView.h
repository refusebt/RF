//
//  RFUILockView.h
//  RF
//
//  Created by 9sky on 14-4-17.
//  Copyright (c) 2014年 9sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFUILockView : NSObject
{
}

+ (RFUILockView *)shared;

- (void)lockWholeView;
- (void)unlockWholeView;

@end