//
//  RFModel.h
//  PhotoThin
//
//  Created by gouzhehua on 14-12-5.
//  Copyright (c) 2014年 RefuseBT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JProperty(Property, MapName)	\
	@property (nonatomic, setter=_rfm_##MapName:) Property

#define J2Str(value)	\
	[RFModel toStringWithJsonValue:value]

#define J2Integer(value)	\
	[RFModel toIntegerWithJsonValue:value]

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
JProperty(NSUInteger value_NSUInteger, mapValue_NSUInteger);
JProperty(short value_short, mapValue_short);
JProperty(long long value_long_long, mapValue_long_long);
JProperty(unsigned long long value_long_long_u, mapValue_long_long_u);
JProperty(NSDictionary *value_NSDictionary, mapValue_NSDictionary);

@end
