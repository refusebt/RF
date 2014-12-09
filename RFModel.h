//
//  RFModel.h
//  RF
//
//  Created by gouzhehua on 14-12-5.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JProperty(MapName, Property)	\
	@property (nonatomic, setter=_rfm_##MapName:) Property

#define J2Str(value)	\
	[RFModel toStringWithJsonValue:value]

#define J2Integer(value)	\
	[RFModel toIntegerWithJsonValue:value]

#define J2Int16(value)	\
	[RFModel toInt16WithJsonValue:value]

#define J2Int32(value)	\
	[RFModel toInt32WithJsonValue:value]

#define J2Int64(value)	\
	[RFModel toInt64WithJsonValue:value]

#define J2Short(value)	\
	[RFModel toShortWithJsonValue:value]

#define J2Float(value)	\
	[RFModel toFloatWithJsonValue:value]

#define J2Double(value)	\
	[RFModel toDoubleWithJsonValue:value]

#define J2Array(value)	\
	[RFModel toArrayWithJsonValue:value]

#define J2Dict(value)	\
	[RFModel toDictionaryWithJsonValue:value]

#define J2NumInteger(value)	\
	[NSNumber numberWithInteger:[RFModel toIntegerWithJsonValue:value]]

#define J2NumInt16(value)	\
	[NSNumber numberWithShort:[RFModel toInt16WithJsonValue:value]]

#define J2NumInt32(value)	\
	[NSNumber numberWithInt:[RFModel toInt32WithJsonValue:value]]

#define J2NumInt64(value)	\
	[NSNumber numberWithLongLong:[RFModel toInt64WithJsonValue:value]]

#define J2NumShort(value)	\
	[NSNumber numberWithShort:[RFModel toShortWithJsonValue:value]]

#define J2NumFloat(value)	\
	[NSNumber numberWithFloat:[RFModel toFloatWithJsonValue:value]]

#define J2NumDouble(value)	\
	[NSNumber numberWithDouble:[RFModel toDoubleWithJsonValue:value]]

#define V2Str(value)	\
	[NSString ifNilToStr:(value)]

#define V2NumInteger(value)	\
	[NSNumber numberWithInteger:(value)]

#define V2NumInt16(value)	\
	[NSNumber numberWithShort:(value)]

#define V2NumInt32(value)	\
	[NSNumber numberWithInt:(value)]

#define V2NumInt64(value)	\
	[NSNumber numberWithLongLong:(value)]

#define V2NumShort(value)	\
	[NSNumber numberWithShort:(value)]

@interface RFModel : NSObject
{
	
}

- (void)fillWithJsonDict:(NSDictionary *)jsonDict;

+ (NSString *)toStringWithJsonValue:(id)value;
+ (NSInteger)toIntegerWithJsonValue:(id)value;
+ (int16_t)toInt16WithJsonValue:(id)value;
+ (int32_t)toInt32WithJsonValue:(id)value;
+ (int64_t)toInt64WithJsonValue:(id)value;
+ (short)toShortWithJsonValue:(id)value;
+ (float)toFloatWithJsonValue:(id)value;
+ (double)toDoubleWithJsonValue:(id)value;
+ (id)toArrayWithJsonValue:(id)value;
+ (id)toDictionaryWithJsonValue:(id)value;

@end

#pragma mark NSString (RFModel)

@interface NSString (RFModel)

+ (BOOL)isEmpty:(NSString *)value;
+ (NSString *)ifNilToStr:(NSString *)value;

+ (NSString *)stringWithInteger:(NSInteger)value;
+ (NSString *)stringWithLong:(long)value;
+ (NSString *)stringWithLongLong:(int64_t)value;
+ (NSString *)stringWithFloat:(float)value;
+ (NSString *)stringWithDouble:(double)value;

@end

@interface TmpModel	: RFModel
{
	
}
//JProperty(mapValue_NSInteger, NSInteger value_NSInteger);
//JProperty(mapValue_NSUInteger, NSUInteger value_NSUInteger);
//JProperty(mapValue_short, short value_short);
//JProperty(mapValue_ushort, unsigned short value_ushort);
//JProperty(mapValue_int, int value_int);
//JProperty(mapValue_uint, unsigned int value_uint);
//JProperty(mapValue_long, long value_long);
//JProperty(mapValue_long_u, unsigned long value_long_u);
//JProperty(mapValue_long_long, long long value_long_long);
//JProperty(mapValue_long_long_u, unsigned long long value_long_long_u);
//JProperty(mapValue_int32, int32_t value_int32);
//JProperty(mapValue_uint32, uint32_t value_uint32);
//JProperty(mapValue_int16, int16_t value_int16);
//JProperty(mapValue_uint16, uint16_t value_uint16);
//JProperty(mapValue_int64, int64_t value_int64);
//JProperty(mapValue_uint64, uint64_t value_uint64);
//JProperty(mapValue_NSString, NSString *value_NSString);
//JProperty(mapValue_NSArray, NSArray *value_NSArray);
//JProperty(mapValue_NSDictionary, NSDictionary *value_NSDictionary);

JProperty(name, NSString *name);
JProperty(sex, short sex);
JProperty(age, int age);
JProperty(address, NSString *address);
JProperty(uid, int64_t uid);
JProperty(unset, NSInteger unset);
JProperty(list, NSArray *list);
JProperty(dict, NSDictionary *dict);

@end
