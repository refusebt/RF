//
//  RFKit.h
//  RF
//
//  Created by gouzhehua on 14-6-25.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RFJModel.h"

#define DECREASE_COUNT(v)	\
	((v)>0 ? (--(v)) : 0)

#define VER(a,b,c)	\
	((a) * 1000000 + (b) * 1000 + (c))

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

#define DICT_ADD_STR(dict, key, value)	\
	[(dict) setObject:[NSString ifNilToStr:(value)] forKey:(key)]
#define DICT_ADD_INT_STR(dict, key, value)	\
	[(dict) setObject:[NSString stringWithLongLong:(value)] forKey:(key)]
#define DICT_ADD_FLOAT_STR(dict, key, value)	\
	[(dict) setObject:[NSString stringWithDouble:(value)] forKey:(key)]

typedef NSMutableArray RFKeyValues;
typedef NSMutableArray RFKeyValue;

#define KVS_ADD_STR(keyValues, key, value)	\
	[(keyValues) addObject:[NSMutableArray arrayWithObjects:(key), (value), nil]];

#define KVS_ADD_INT(keyValues, key, value)	\
	[(keyValues) addObject:[NSMutableArray arrayWithObjects:(key), [NSNumber numberWithInteger:(value)], nil]];

#define KVS_ADD_FLOAT(keyValues, key, value)	\
	[(keyValues) addObject:[NSMutableArray arrayWithObjects:(key), [NSNumber numberWithDouble:(value)], nil]];

#define KV_KEY(keyValue)	\
	[(keyValue) objectAtIndex:0]

#define KV_VALUE(keyValue)	\
	[(keyValue) objectAtIndex:1]

#define KV_VALUE_STR(keyValue)	\
	J2Str([(keyValue) objectAtIndex:1])

#define KV_VALUE_INT(keyValue)	\
	J2Integer([(keyValue) objectAtIndex:1])

#define KV_VALUE_FLOAT(keyValue)	\
	J2Float([(keyValue) objectAtIndex:1])

#pragma mark RFKit

@interface RFKit : NSObject

+ (BOOL)isDebugMode;
+ (BOOL)isSimulatorEnv;
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
