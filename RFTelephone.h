//
//  RFTelephone.h
//  RF
//
//  Created by gouzhehua on 14-6-26.
//  Copyright (c) 2014年 skyinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

// 需要
//	CoreTelephony.framework
//	MessageUI.framework

@interface RFTelephone : NSObject
{

}

+ (RFTelephone *)shared;

- (NSString *)carrierName;
- (NSString *)carrierCode;

- (BOOL)callWithPhone:(NSString *)aPhone;
- (BOOL)sendSMSWithPhone:(NSString *)aPhone content:(NSString *)aContent;

@end
