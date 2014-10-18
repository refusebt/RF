//
//  RFTelephone.m
//  RF
//
//  Created by gouzhehua on 14-6-26.
//  Copyright (c) 2014年 skyinfo. All rights reserved.
//

#import "RFTelephone.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <MessageUI/MessageUI.h>
#import "ARCMacros.h"
#import "RFKit.h"

@interface RFTelephone ()
<
	MFMessageComposeViewControllerDelegate
>
{
	
}
@property (nonatomic, SAFE_ARC_STRONG) MFMessageComposeViewController *msgCtrl;

@end

@implementation RFTelephone
@synthesize msgCtrl = _msgCtrl;

+ (RFTelephone *)shared
{
	static RFTelephone *s_instance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		s_instance = [[RFTelephone alloc] init];
	});
	
	return s_instance;
}

- (NSString *)carrierName
{
	NSString *ret = nil;
	
	CTTelephonyNetworkInfo *cn = [[CTTelephonyNetworkInfo alloc] init];
	if (cn.subscriberCellularProvider != nil)
	{
		NSString *tmp = cn.subscriberCellularProvider.carrierName;
		if (![NSString isEmpty:tmp])
		{
			ret = [tmp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		}
	}
	SAFE_ARC_RELEASE(cn);
	
	return ret;
}

- (NSString *)carrierCode
{
	NSString *ret = nil;
	
	CTTelephonyNetworkInfo *cn = [[CTTelephonyNetworkInfo alloc] init];
	if (cn.subscriberCellularProvider != nil)
	{
		NSString *mobileCountryCode = cn.subscriberCellularProvider.mobileCountryCode;
		NSString *mobileNetworkCode = cn.subscriberCellularProvider.mobileNetworkCode;
		NSMutableString *buffer = [NSMutableString stringWithString:@""];
		if (![NSString isEmpty:mobileCountryCode])
		{
			[buffer appendString:mobileCountryCode];
		}
		if (![NSString isEmpty:mobileNetworkCode])
		{
			[buffer appendString:mobileNetworkCode];
		}
		if (![NSString isEmpty:buffer])
		{
			ret = buffer;
		}
	}
	SAFE_ARC_RELEASE(cn);
	
	return ret;
}

- (BOOL)callWithPhone:(NSString *)aPhone
{
	if (![NSString isEmpty:aPhone])
	{
		NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@", aPhone]];
		NSLog(@"Call, URL=%@", phoneNumberURL);
		return [[UIApplication sharedApplication] openURL:phoneNumberURL];
	}
	return NO;
}

- (BOOL)sendSMSWithPhone:(NSString *)aPhone content:(NSString *)aContent
{
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	if (messageClass == nil || ![messageClass canSendText])
	{
		return NO;
	}
	
	if (_msgCtrl != nil)
	{
		[_msgCtrl dismissMe];
		SAFE_ARC_AUTORELEASE(_msgCtrl);
		_msgCtrl = nil;
	}
	
	self.msgCtrl = SAFE_ARC_AUTORELEASE([[MFMessageComposeViewController alloc] init]);
	[_msgCtrl setMessageComposeDelegate:self];
	[_msgCtrl setBody:aContent];
	[_msgCtrl setRecipients:[NSArray arrayWithObject:aPhone]];
	
	UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	if (window.rootViewController != nil)
	{
		[window.rootViewController presentViewController:_msgCtrl animated:YES];
	}
	
	return YES;
}

#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result)
	{
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultSent:
			break;
		case MessageComposeResultFailed:
			break;
		default:
			break;
	}
	
	[controller dismissMe];
}

@end
