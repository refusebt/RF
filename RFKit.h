//
//  RFKit.h
//  RF
//
//  Created by gouzhehua on 14-6-25.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
	typedef long NSInteger;
	typedef unsigned long NSUInteger;
#else
	typedef int NSInteger;
	typedef unsigned int NSUInteger;
#endif

#define DECREASE_COUNT(v)	\
	((v)>0 ? (--(v)) : 0)

#define VER(a,b,c)	\
	((a) * 1000000 + (b) * 1000 + (c))

#define DICT_ADD_STR(dict, key, value)	\
	[(dict) setObject:[NSString ifNilToStr:(value)] forKey:(key)]
#define DICT_ADD_INT_STR(dict, key, value)	\
	[(dict) setObject:[NSString stringWithLongLong:(value)] forKey:(key)]
#define DICT_ADD_FLOAT_STR(dict, key, value)	\
	[(dict) setObject:[NSString stringWithDouble:(value)] forKey:(key)]

#define J2Str(value)	\
	[RFKit toStringWithJsonValue:value]

#define J2Integer(value)	\
	[RFKit toIntegerWithJsonValue:value]

#define J2Int64(value)	\
	[RFKit toInt64WithJsonValue:value]

#define J2Short(value)	\
	[RFKit toShortWithJsonValue:value]

#define J2Float(value)	\
	[RFKit toFloatWithJsonValue:value]

#define J2Double(value)	\
	[RFKit toDoubleWithJsonValue:value]

#define J2Array(value)	\
	[RFKit toArrayWithJsonValue:value]

#define J2Dict(value)	\
	[RFKit toDictionaryWithJsonValue:value]

#define J2NumInteger(value)	\
	[NSNumber numberWithInteger:[RFKit toIntegerWithJsonValue:value]]

#define J2NumInt64(value)	\
	[NSNumber numberWithLongLong:[RFKit toInt64WithJsonValue:value]]

#define J2NumShort(value)	\
	[NSNumber numberWithShort:[RFKit toShortWithJsonValue:value]]

#define J2NumFloat(value)	\
	[NSNumber numberWithFloat:[RFKit toFloatWithJsonValue:value]]

#define J2NumDouble(value)	\
	[NSNumber numberWithDouble:[RFKit toDoubleWithJsonValue:value]]

#define V2Str(value)	\
	[NSString ifNilToStr:(value)]

#define V2NumInteger(value)	\
	[NSNumber numberWithInteger:(value)]

#define V2NumInt64(value)	\
	[NSNumber numberWithLongLong:(value)]

#define V2NumShort(value)	\
	[NSNumber numberWithShort:(value)]

#ifndef IS_IOS6
	#define IS_IOS6	([RFKit iosVer] >= VER(6, 0, 0))
#endif

#ifndef IS_IOS7
	#define IS_IOS7 ([RFKit iosVer] >= VER(7, 0, 0))
#endif

#ifndef IS_IOS8
    #define IS_IOS8 ([RFKit iosVer] >= VER(8, 0, 0))
#endif

#ifndef IS_IPHONE5
	#define IS_IPHONE5 ([RFKit isIPhone5Type])
#endif

#pragma mark RFKit

@interface RFKit : NSObject

+ (BOOL)isDebugMode;
+ (NSString *)preferredLanguage;
+ (BOOL)isEnLanguage;
+ (BOOL)isCnLanguage;
+ (NSInteger)verStrToInt:(NSString *)strVer;
+ (NSInteger)iosVer;		// XXX.XXX.XXX => XXXXXXXXX 例1.0.1 => 1000001
+ (NSInteger)appVer;		// XXX.XXX.XXX => XXXXXXXXX 例1.0.1 => 1000001
+ (BOOL)isIPhone5Type;

+ (void)clearApplicationIconBadgeNumber;

+ (BOOL)isNil:(id)value;
+ (id<NSCoding>)objectWithSerializedObject:(id<NSCoding>)aSerializedObject;
+ (id)loadObjectFromNibName:(NSString *)aNibName class:(Class)aClass;

+ (NSString *)fullVersion;
+ (NSString *)bundleVersion;
+ (NSString *)bundleBuild;
+ (NSString *)bundleIdentifier;
+ (NSString *)bundleDisplayName;
+ (NSString *)bundleName;

+ (NSString *)className:(Class)cls;
+ (NSString *)selectorName:(SEL)aSelector;

+ (NSString *)toStringWithJsonValue:(id)value;
+ (NSInteger)toIntegerWithJsonValue:(id)value;
+ (int64_t)toInt64WithJsonValue:(id)value;
+ (short)toShortWithJsonValue:(id)value;
+ (float)toFloatWithJsonValue:(id)value;
+ (double)toDoubleWithJsonValue:(id)value;
+ (id)toArrayWithJsonValue:(id)value;
+ (id)toDictionaryWithJsonValue:(id)value;

+ (id)deepMutableCopyWithJson:(id)json;

+ (NSString *)getUUID;
+ (NSString *)getUUIDNoSeparator;

@end

#pragma mark RFKeyValuePair

@interface RFKeyValuePair : NSObject
{

}
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) id value;

- (id)initWithKey:(NSString *)aKey value:(id)aValue;

+ (RFKeyValuePair *)pairWithKey:(NSString *)key str:(NSString *)str;
+ (RFKeyValuePair *)pairWithKey:(NSString *)key num:(int64_t)num;
+ (RFKeyValuePair *)pairWithNumKey:(int64_t)numKey num:(int64_t)num;

@end

#pragma mark NSString (RFKit)

@interface NSString (RFKit)

- (NSString *)trim;
- (NSInteger)charCount;

+ (BOOL)isEmpty:(NSString *)value;
+ (NSString *)ifNilToStr:(NSString *)value;

+ (NSString *)stringWithInteger:(NSInteger)value;
+ (NSString *)stringWithLong:(long)value;
+ (NSString *)stringWithLongLong:(int64_t)value;
+ (NSString *)stringWithFloat:(float)value;
+ (NSString *)stringWithDouble:(double)value;

- (NSString *)stringByURLEncoding;
- (NSString *)stringByURLDecoding;
- (NSString *)stringByFilterSymbols:(NSArray *)symbols;
- (NSString *)stringByTTSFilter;

- (BOOL)isPhone;
- (BOOL)isEmail;

- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width;
- (CGFloat)widthWithFont:(UIFont *)font;

- (NSString *)toMD5;

@end

#pragma mark NSMutableString (RFKit)

@interface NSMutableString (RFKit)

- (void)removeLastChar;

@end

#pragma mark NSDate (RFKit)

@interface NSDate (RFKit)

+ (NSString *)yyyyMMddHHmmssSince1970:(int64_t)millisecond;
- (NSString *)yyyyMMddHHmmss;
+ (NSString *)yyyyMMddSince1970:(int64_t)millisecond;
- (NSString *)yyyyMMdd;
+ (NSString *)yyyyMMddHHmmssTimestampSince1970:(int64_t)millisecond;
- (NSString *)yyyyMMddHHmmssTimestampSince1970;

+ (int64_t)millisecondSince1970;
+ (NSDate *)dateWithMillisecondSince1970:(int64_t)millisecond;
+ (void)modifyTimeWithLocal:(int64_t)local server:(int64_t)server;

+ (NSDate *)dateString:(NSString *)dateString withFormatString:(NSString *)formateString;

@end
