//
//  RFModel.m
//  PhotoThin
//
//  Created by gouzhehua on 14-12-5.
//  Copyright (c) 2014年 RefuseBT. All rights reserved.
//

#import "RFModel.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, RFModelPropertyType)
{
	RFModelPropertyTypeNone = 0,
	RFModelPropertyTypeInteger,
	RFModelPropertyTypeInt64,
	RFModelPropertyTypeShort,
	RFModelPropertyTypeFloat,
	RFModelPropertyTypeDouble,
	RFModelPropertyTypeString,
	RFModelPropertyTypeArray,
	RFModelPropertyTypeDictionary,
};

@interface RFModelPropertyInfo : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *mapName;
@property (nonatomic, strong) NSString *var;
@property (nonatomic, assign) RFModelPropertyType type;

+ (NSMutableDictionary *)mapPropertyInfosWithClass:(Class)cls;
+ (RFModelPropertyInfo *)propertyInfoWithProperty:(objc_property_t *)property;

@end

@interface RFModel ()
+ (NSMutableDictionary *)modelInfos;
@end

#pragma mark - RFModel

@implementation RFModel

+ (void)initialize
{
	if ([self class] != [RFModel class])
	{
		NSMutableDictionary *mapPropertyInfos = [RFModelPropertyInfo mapPropertyInfosWithClass:[self class]];
		const char *className = object_getClassName([self class]);
		[[RFModel modelInfos] setObject:mapPropertyInfos forKey:[NSValue valueWithPointer:className]];
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

- (void)fillWithJsonDict:(NSDictionary *)jsonDict
{
	for (NSString *key in jsonDict)
	{
		RFModelPropertyInfo *info = [[RFModel modelInfos] objectForKey:key];
		if (info != nil)
		{
			switch (info.type)
			{
				case RFModelPropertyTypeInteger:
					[self setValue:J2NumInteger(jsonDict[key]) forKey:info.name];
					break;
				case RFModelPropertyTypeInt64:
					[self setValue:J2NumInt64(jsonDict[key]) forKey:info.name];
					break;
				case RFModelPropertyTypeShort:
					[self setValue:J2NumShort(jsonDict[key]) forKey:info.name];
					break;
				case RFModelPropertyTypeFloat:
					[self setValue:J2NumFloat(jsonDict[key]) forKey:info.name];
					break;
				case RFModelPropertyTypeDouble:
					[self setValue:J2NumDouble(jsonDict[key]) forKey:info.name];
					break;
				case RFModelPropertyTypeString:
					[self setValue:J2Str(jsonDict[key]) forKey:info.name];
					break;
				case RFModelPropertyTypeArray:
					[self setValue:J2Array(jsonDict[key]) forKey:info.name];
					break;
				case RFModelPropertyTypeDictionary:
					[self setValue:J2Dict(jsonDict[key]) forKey:info.name];
					break;
				default:
					break;
			}
		}
	}
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

#pragma mark - RFModelPropertyInfo

@implementation RFModelPropertyInfo

+ (NSMutableDictionary *)mapPropertyInfosWithClass:(Class)cls
{
	NSMutableDictionary *mapProperInfos = [NSMutableDictionary dictionary];
	
	if ([cls isSubclassOfClass:[RFModel class]])
	{
		Class current = cls;
		while (current != [RFModel class])
		{
			unsigned count = 0;
			objc_property_t *properties = class_copyPropertyList(current, &count);
			for (unsigned i = 0; i < count; i++)
			{
				objc_property_t property = properties[i];
				RFModelPropertyInfo *pi = [RFModelPropertyInfo propertyInfoWithProperty:&property];
				if (pi != nil)
				{
					[mapProperInfos setObject:pi forKey:pi.mapName];
				}
			}
			free(properties);
			
			current = [current superclass];
		}
	}
	
	return mapProperInfos;
}

+ (RFModelPropertyInfo *)propertyInfoWithProperty:(objc_property_t *)property
{
	RFModelPropertyInfo *info = [[RFModelPropertyInfo alloc] init];
	info.name = [NSString stringWithUTF8String:property_getName(*property)];
	
	NSString *propertyAttrString = [NSString stringWithUTF8String:property_getAttributes(*property)];
	NSArray *propertyAttrArray = [propertyAttrString componentsSeparatedByString:@","];
	for (NSString *attrib in propertyAttrArray)
	{
		if ([attrib hasPrefix:@"T"] && attrib.length > 1)
		{
			if ([attrib hasPrefix:@"Ti"] || [attrib hasPrefix:@"TI"])
			{
				info.type = RFModelPropertyTypeInteger;
			}
			else if ([attrib hasPrefix:@"Tq"] || [attrib hasPrefix:@"TQ"])
			{
				info.type = RFModelPropertyTypeInt64;
			}
			else if ([attrib hasPrefix:@"Ts"] || [attrib hasPrefix:@"TS"])
			{
				info.type = RFModelPropertyTypeShort;
			}
			else if ([attrib hasPrefix:@"Tf"] || [attrib hasPrefix:@"TF"])
			{
				info.type = RFModelPropertyTypeFloat;
			}
			else if ([attrib hasPrefix:@"Td"] || [attrib hasPrefix:@"TD"])
			{
				info.type = RFModelPropertyTypeDouble;
			}
			else if ([attrib hasPrefix:@"T@\"NSString\""])
			{
				info.type = RFModelPropertyTypeString;
			}
			else if ([attrib hasPrefix:@"T@\"NSArray\""])
			{
				info.type = RFModelPropertyTypeArray;
			}
			else if ([attrib hasPrefix:@"T@\"NSDictionary\""])
			{
				info.type = RFModelPropertyTypeDictionary;
			}
			else
			{
				NSException *e = [NSException exceptionWithName:@"Unsupport RFModel Type"
														 reason:[NSString stringWithFormat:@"Unsupport RFModel Type (%@, %@)", info.name, attrib]
													   userInfo:nil];
				@throw e;
			}
		}
		else if ([attrib hasPrefix:@"S"] && attrib.length > 7)
		{
			// S_rfm_mapName:
			info.mapName = [attrib substringWithRange:NSMakeRange(6, attrib.length-7)];
		}
		else if ([attrib hasPrefix:@"V"] && attrib.length > 1)
		{
			// V_name
			info.var = [attrib substringWithRange:NSMakeRange(1, attrib.length-1)];
		}
	}
	
	if (![NSString isEmpty:info.mapName] && info.type != RFModelPropertyTypeNone)
	{
		return info;
	}
	
	return nil;
}

@end

////////////////////

@implementation TmpModel

- (id)init
{
	self = [super init];
	if (self)
	{
		
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
