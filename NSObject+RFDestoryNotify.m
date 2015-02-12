//
//  NSObject+RFDestoryNotify.m
//  RF
//
//  Created by gouzhehua on 15-2-12.
//  Copyright (c) 2015年 RF. All rights reserved.
//

#import "NSObject+RFDestoryNotify.h"
#import <objc/runtime.h>

@interface RFDestoryNotify ()
- (NSMutableDictionary *)blocks;
- (NSMutableDictionary *)userInfos;
@end

@implementation RFDestoryNotify
@synthesize name = _name;

- (void)dealloc
{
	RFDestoryNotifyBlock block = [self block];
	if (block != nil)
	{
		block(self);
	}
	
	[self setBlock:nil];
	[self setUserInfo:nil];
	_name = nil;
}

- (NSMutableDictionary *)blocks
{
	static NSMutableDictionary *s_instance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		s_instance = [[NSMutableDictionary alloc] init];
	});
	
	return s_instance;
}

- (NSMutableDictionary *)userInfos
{
	static NSMutableDictionary *s_instance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		s_instance = [[NSMutableDictionary alloc] init];
	});
	
	return s_instance;
}

- (NSDictionary *)userInfo
{
	return [[self userInfos] objectForKey:_name];
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
	if (userInfo != nil)
	{
		[[self userInfos] setObject:userInfo forKey:_name];
	}
	else
	{
		[[self userInfos] removeObjectForKey:_name];
	}
}

- (RFDestoryNotifyBlock)block
{
	return [[self blocks] objectForKey:_name];
}

- (void)setBlock:(RFDestoryNotifyBlock)block
{
	if (block != nil)
	{
		[[self blocks] setObject:block forKey:_name];
	}
	else
	{
		[[self blocks] removeObjectForKey:_name];
	}
}

@end

@implementation NSObject (RFDestoryNotify)

- (NSMutableDictionary *)rfDestoryNotifyDictionary
{
	static void * kStorageKey = "kDestoryNotifyDictionary";
	NSMutableDictionary *dict = (NSMutableDictionary *)objc_getAssociatedObject(self, kStorageKey);
	if (dict == nil)
	{
		dict = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(self, kStorageKey, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return dict;
}

- (void)rfDestoryNotifySetName:(NSString *)name block:(RFDestoryNotifyBlock)block
{
	[self rfDestoryNotifySetName:name userInfo:nil block:block];
}

- (void)rfDestoryNotifySetName:(NSString *)name userInfo:(NSDictionary *)userInfo block:(RFDestoryNotifyBlock)block
{
	[self rfDestoryNotifyRemoveWithName:name];
	
	RFDestoryNotify *dn = [[RFDestoryNotify alloc] init];
	dn.name = name;
	[dn setBlock:block];
	[dn setUserInfo:userInfo];
	[[self rfDestoryNotifyDictionary] setObject:dn forKey:name];
}

- (void)rfDestoryNotifyRemoveWithName:(NSString *)name
{
	NSMutableDictionary *dict = [self rfDestoryNotifyDictionary];
	RFDestoryNotify *dn = [dict objectForKey:name];
	if (dn != nil)
	{
		[dn setBlock:nil];
		[dn setUserInfo:nil];
		[dict removeObjectForKey:name];
		dn = nil;
	}
}

@end
