//
//  RFModel.m
//  RF
//
//  Created by gouzhehua on 14-12-5.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFModel.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, RFModelPropertyType)
{
	RFModelPropertyTypeNone = 0,
	RFModelPropertyTypeInt16,
	RFModelPropertyTypeInt32,
	RFModelPropertyTypeInt64,
	RFModelPropertyTypeFloat,
	RFModelPropertyTypeDouble,
	RFModelPropertyTypeString,
	RFModelPropertyTypeArray,
	RFModelPropertyTypeDictionary,
};

static char* s_RFModelPropertyTypeName[] =
{
	"RFModelPropertyTypeNone",
	"RFModelPropertyTypeInt16",
	"RFModelPropertyTypeInt32",
	"RFModelPropertyTypeInt64",
	"RFModelPropertyTypeFloat",
	"RFModelPropertyTypeDouble",
	"RFModelPropertyTypeString",
	"RFModelPropertyTypeArray",
	"RFModelPropertyTypeDictionary"
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

- (NSString *)description
{
	NSMutableString *buffer = [NSMutableString string];
	
	Class current = [self class];
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
				// JProperty
				id value = [self valueForKey:pi.name];
				[buffer appendFormat:@"JP name:%@ value:%@ type:%s map:%@\n", pi.name, value, s_RFModelPropertyTypeName[pi.type], pi.mapName];
			}
			else
			{
				// no JProperty
				NSString *name = [NSString stringWithUTF8String:property_getName(property)];
				id value = [self valueForKey:name];
				[buffer appendFormat:@" P name:%@ value:%@ \n", name, value];
			}
		}
		free(properties);
		
		current = [current superclass];
	}
	
	return buffer;
}

- (void)fillWithJsonDict:(NSDictionary *)jsonDict
{
	const char *className = object_getClassName([self class]);
	NSDictionary *mapPropertyInfos = [[RFModel modelInfos] objectForKey:[NSValue valueWithPointer:className]];
	for (NSString *key in jsonDict)
	{
		RFModelPropertyInfo *info = mapPropertyInfos[key];
		if (info != nil)
		{
			switch (info.type)
			{
				case RFModelPropertyTypeInt16:
					[self setValue:J2NumInt16(jsonDict[key]) forKey:info.name];
					break;
				case RFModelPropertyTypeInt32:
					[self setValue:J2NumInt32(jsonDict[key]) forKey:info.name];
					break;
				case RFModelPropertyTypeInt64:
					[self setValue:J2NumInt64(jsonDict[key]) forKey:info.name];
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

+ (NSString *)toStringWithJsonValue:(id)value
{
	if (value == nil || value == [NSNull null])
	{
		return @"";
	}
	
	if ([value isKindOfClass:[NSString class]])
	{
		return value;
	}
	
	if ([value isKindOfClass:[NSNumber class]])
	{
		return  [value stringValue];
	}
	
	return @"";
}

+ (NSInteger)toIntegerWithJsonValue:(id)value
{
	if (value == nil || value == [NSNull null])
	{
		return 0;
	}
	
	if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
	{
		return [value integerValue];
	}
	
	return 0;
}

+ (int16_t)toInt16WithJsonValue:(id)value
{
	if (value == nil || value == [NSNull null])
	{
		return 0;
	}
	
	if ([value isKindOfClass:[NSNumber class]])
	{
		return [value shortValue];
	}
	
	if ([value isKindOfClass:[NSString class]])
	{
		return [value intValue];
	}
	
	return 0;
}

+ (int32_t)toInt32WithJsonValue:(id)value
{
	if (value == nil || value == [NSNull null])
	{
		return 0;
	}
	
	if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
	{
		return [value intValue];
	}
	
	return 0;
}

+ (int64_t)toInt64WithJsonValue:(id)value
{
	if (value == nil || value == [NSNull null])
	{
		return 0;
	}
	
	if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
	{
		return [value longLongValue];
	}
	
	return 0;
}

+ (short)toShortWithJsonValue:(id)value
{
	if (value == nil || value == [NSNull null])
	{
		return 0;
	}
	
	if ([value isKindOfClass:[NSNumber class]])
	{
		return [value shortValue];
	}
	
	if ([value isKindOfClass:[NSString class]])
	{
		return [value intValue];
	}
	
	return 0;
}

+ (float)toFloatWithJsonValue:(id)value
{
	if (value == nil || value == [NSNull null])
	{
		return 0;
	}
	
	if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
	{
		return [value floatValue];
	}
	
	return 0;
}

+ (double)toDoubleWithJsonValue:(id)value
{
	if (value == nil || value == [NSNull null])
	{
		return 0;
	}
	
	if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
	{
		return [value doubleValue];
	}
	
	return 0;
}

+ (id)toArrayWithJsonValue:(id)value
{
	if (value == nil || value == [NSNull null])
	{
		return nil;
	}
	
	if ([value isKindOfClass:[NSArray class]])
	{
		return value;
	}
	
	return nil;
}

+ (id)toDictionaryWithJsonValue:(id)value
{
	if (value == nil || value == [NSNull null])
	{
		return nil;
	}
	
	if ([value isKindOfClass:[NSDictionary class]])
	{
		return value;
	}
	
	return nil;
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
	NSString *typeAttrib = @"";
	for (NSString *attrib in propertyAttrArray)
	{
		if ([attrib hasPrefix:@"T"] && attrib.length > 1)
		{
			typeAttrib = attrib;
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
	
	if (![NSString isEmpty:info.mapName] && ![NSString isEmpty:typeAttrib])
	{
		if ([typeAttrib hasPrefix:@"Ti"] || [typeAttrib hasPrefix:@"TI"])
		{
			info.type = RFModelPropertyTypeInt32;
		}
		else if ([typeAttrib hasPrefix:@"Tl"] || [typeAttrib hasPrefix:@"TL"])
		{
			info.type = RFModelPropertyTypeInt32;
		}
		else if ([typeAttrib hasPrefix:@"Tq"] || [typeAttrib hasPrefix:@"TQ"])
		{
			info.type = RFModelPropertyTypeInt64;
		}
		else if ([typeAttrib hasPrefix:@"Ts"] || [typeAttrib hasPrefix:@"TS"])
		{
			info.type = RFModelPropertyTypeInt16;
		}
		else if ([typeAttrib hasPrefix:@"Tf"] || [typeAttrib hasPrefix:@"TF"])
		{
			info.type = RFModelPropertyTypeFloat;
		}
		else if ([typeAttrib hasPrefix:@"Td"] || [typeAttrib hasPrefix:@"TD"])
		{
			info.type = RFModelPropertyTypeDouble;
		}
		else if ([typeAttrib hasPrefix:@"T@\"NSString\""])
		{
			info.type = RFModelPropertyTypeString;
		}
		else if ([typeAttrib hasPrefix:@"T@\"NSArray\""])
		{
			info.type = RFModelPropertyTypeArray;
		}
		else if ([typeAttrib hasPrefix:@"T@\"NSDictionary\""])
		{
			info.type = RFModelPropertyTypeDictionary;
		}
		else
		{
			NSException *e = [NSException exceptionWithName:@"Unsupport RFModel Type"
													 reason:[NSString stringWithFormat:@"Unsupport RFModel Type (%@, %@)", info.name, typeAttrib]
												   userInfo:nil];
			@throw e;
		}
		
		if (info.type != RFModelPropertyTypeNone)
		{
			return info;
		}
	}
	
	return nil;
}

@end

#pragma mark NSString (RFModel)

@implementation NSString (RFModel)

+ (BOOL)isEmpty:(NSString *)value
{
	if ((value == nil) || value == (NSString *)[NSNull null] || (value.length == 0))
	{
		return YES;
	}
	return NO;
}

+ (NSString *)ifNilToStr:(NSString *)value
{
	if ((value == nil) || (value == (NSString *)[NSNull null]))
	{
		return @"";
	}
	return value;
}

+ (NSString *)stringWithInteger:(NSInteger)value
{
	NSNumber *number = [NSNumber numberWithInteger:value];
	return [number stringValue];
}

+ (NSString *)stringWithLong:(long)value
{
	return [NSString stringWithFormat:@"%ld", value];
}

+ (NSString *)stringWithLongLong:(int64_t)value
{
	return [NSString stringWithFormat:@"%lld", value];
}

+ (NSString *)stringWithFloat:(float)value
{
	return [NSString stringWithFormat:@"%f", value];
}

+ (NSString *)stringWithDouble:(double)value
{
	return [NSString stringWithFormat:@"%lf", value];
}

@end
