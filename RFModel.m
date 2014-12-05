//
//  RFModel.m
//  PhotoThin
//
//  Created by gouzhehua on 14-12-5.
//  Copyright (c) 2014年 RefuseBT. All rights reserved.
//

#import "RFModel.h"
#import <objc/runtime.h>

@interface RFModel ()

+ (NSMutableDictionary *)modelInfos;

@end

#pragma mark - RFModelClassInfo

@interface RFModelClassInfo : NSObject
@property (nonatomic, strong) NSMutableDictionary *keyToProperty;
@property (nonatomic, strong) NSMutableDictionary *selToProperty;
@property (nonatomic, strong) NSMutableDictionary *selToType;
- (id)initWithModelClass:(Class)modelClass;
@end

@implementation RFModelClassInfo
@synthesize keyToProperty = _keyToProperty;
@synthesize selToProperty = _selToProperty;
@synthesize selToType = _selToType;

- (id)initWithModelClass:(Class)modelClass
{
	self = [super init];
	if (self)
	{
		_keyToProperty = [NSMutableDictionary dictionary];
		_selToProperty = [NSMutableDictionary dictionary];
		_selToType = [NSMutableDictionary dictionary];
		
		Class current = modelClass;
		while (current != [RFModel class])
		{
			unsigned count;
			objc_property_t *properties = class_copyPropertyList(current, &count);
			for (unsigned i = 0; i < count; i++)
			{
				objc_property_t property = properties[i];
				const char *propertyNameC = property_getName(property);
				NSString *propertyName = [NSString stringWithUTF8String:propertyNameC];
				const char* propertyAttrC = property_getAttributes(property);
				NSString* propertyAttrS = [NSString stringWithUTF8String:propertyAttrC];
				NSArray* propertyAttr = [propertyAttrS componentsSeparatedByString:@","];
				
				/*
				 <__NSArrayM 0x7fd85b930fc0>(
				 T@"NSString",
				 &,
				 N,
				 G_rf_get_nameValue_name,
				 S_rf_set_nameValue_name:,
				 V_name
				 )
				 */
				
				NSLog(@"%@ has property %@", NSStringFromClass(current), propertyName);
			}
			free(properties);
			
			current = [current superclass];
		}
	}
	return self;
}

@end

#pragma mark - RFModel

@implementation RFModel

+ (void)initialize
{
	if ([self class] != [RFModel class])
	{
		RFModelClassInfo *info = [[RFModelClassInfo alloc] initWithModelClass:[self class]];
		const char *className = object_getClassName([self class]);
		[[RFModel modelInfos] setObject:info forKey:[NSValue valueWithPointer:className]];
	}
}

- (id)init
{
	self = [super init];
	if (self)
	{
		
	}
	return self;
}

+ (NSMutableDictionary *)modelInfos
{
	static NSMutableDictionary *s_instance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		s_instance = [[NSMutableDictionary alloc] init];
	});
	
	return s_instance;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
	return YES;
}

@end

////////////////////

@implementation TmpModel

- (id)init
{
	self = [super init];
	if (self)
	{
//		_name = @"test";
		self.name = @"test1";
	}
	return self;
}

//- (void)setName:(NSString *)value
//{
//	
//}

//- (void)_rf_set_nameValue_name:(NSString *)value
//{
//	_name = value;
//}

@end

@implementation TmpOtherModel

@end
