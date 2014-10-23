//
//  RFKit.m
//  RF
//
//  Created by gouzhehua on 14-6-25.
//  Copyright (c) 2014年 GZH. All rights reserved.
//

#import "RFKit.h"
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>
#import "ARCMacros.h"

static NSInteger s_appVer = -1;
static NSString *s_language = nil;

#pragma mark RFKit

@implementation RFKit

+ (BOOL)isDebugMode
{
#ifndef __OPTIMIZE__
	return YES;
#else
	return NO;
#endif
}

+ (NSString *)preferredLanguage
{
//	preferredLanguages : (
//						  zh-Hans,
//						  en,
//						  ja,
//						  fr,
//						  zh-Hant,
//						  de,
//						  nl,
//						  it,
//						  es,
//						  pt-PT,
//						  da,
//						  fi,
//						  nb,
//						  sv,
//						  ko,
//						  ru,
//						  pl,
//						  pt,
//						  tr,
//						  uk
//						  )
	
	if (s_language == nil)
	{
		s_language = @"";
		
		NSArray *languages = [NSLocale preferredLanguages];
		if ([languages count] > 0)
		{
			s_language = [[languages objectAtIndex:0] copy];
		}
	}
	
	return s_language;
}

+ (BOOL)isEnLanguage
{
	NSString *lang = [RFKit preferredLanguage];
	if ([lang isEqualToString:@"en"])
	{
		return YES;
	}
	return NO;
}

+ (BOOL)isCnLanguage
{
	NSString *lang = [RFKit preferredLanguage];
	if ([lang isEqualToString:@"zh-Hans"])
	{
		return YES;
	}
	return NO;
}

+ (NSInteger)verStrToInt:(NSString *)strVer
{
	NSInteger nVer = 0;
	if (strVer != nil)
	{
		NSArray *array = [strVer componentsSeparatedByString:@"."];
		
		// 1 000 001
		if (array.count > 0)
		{
			nVer = [[array objectAtIndex:0] integerValue] * 1000000;
			if (array.count > 1)
			{
				nVer += [[array objectAtIndex:1] integerValue] * 1000;
				if (array.count > 2)
				{
					nVer += [[array objectAtIndex:2] integerValue];
				}
			}
		}
	}
	
	return nVer;
}

+ (NSInteger)iosVer
{
	if (s_appVer >= 0)
		return s_appVer;
	
	NSString *ver = [[UIDevice currentDevice] systemVersion];
	s_appVer = [RFKit verStrToInt:ver];
	
	return s_appVer;
}

+ (NSInteger)appVer
{
	if (s_appVer >= 0)
		return s_appVer;
	
	NSString *ver = [RFKit bundleVersion];
	s_appVer = [RFKit verStrToInt:ver];
	
	return s_appVer;
}

+ (BOOL)isIPhone5Type
{
	CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat height = bounds.size.height;
	
    return (([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) && (height >= 568));
}

+ (void)clearApplicationIconBadgeNumber
{
	[UIApplication sharedApplication].applicationIconBadgeNumber = 1;
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

+ (BOOL)isNil:(id)value
{
	if (value == nil)
	{
		return YES;
	}
	
	if (value == [NSNull null])
	{
		return YES;
	}
	
	return NO;
}

+ (id<NSCoding>)objectWithSerializedObject:(id<NSCoding>)aSerializedObject
{
	id<NSCoding> newObj = nil;
	
	NSMutableData* saveData = [[NSMutableData alloc] init];
	{
		NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:saveData];
		{
			[archiver encodeRootObject:aSerializedObject];
			[archiver finishEncoding];
			
			NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:saveData];
			newObj = [unArchiver decodeObject];
			SAFE_ARC_RELEASE(unArchiver);
		}
		SAFE_ARC_RELEASE(archiver);
	}
	SAFE_ARC_RELEASE(saveData);
	
	return newObj;
}

+ (id)loadObjectFromNibName:(NSString *)aNibName class:(Class)aClass
{
	NSArray* objects = [[NSBundle mainBundle] loadNibNamed:aNibName owner:nil options:nil];
    for (id object in objects)
	{
        if ([object isKindOfClass:aClass])
		{
            return object;
        }
    }
	return nil;
}

+ (NSString *)fullVersion
{
	return [NSString stringWithFormat:@"%@.%@", [RFKit bundleVersion], [RFKit bundleBuild]];
}

+ (NSString *)bundleVersion
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)bundleBuild
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)bundleIdentifier
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)bundleDisplayName
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)bundleName
{
	return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)className:(Class)cls
{
	const char *pName = class_getName(cls);
	return [NSString stringWithCString:pName encoding:NSASCIIStringEncoding];
}

+ (NSString *)selectorName:(SEL)aSelector
{
	const char *pName = sel_getName(aSelector);
	return [NSString stringWithCString:pName encoding:NSASCIIStringEncoding];
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

+ (int64_t)toInt64WithJsonValue:(id)value
{
	if (value == nil || value == [NSNull null])
	{
		return 0;
	}
	
	if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
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
	
	if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
	{
		return [value shortValue];
	}
	
	return 0;
}

+ (float)toFloatWithJsonValue:(id)value
{
	if (value == nil || value == [NSNull null])
	{
		return 0;
	}
	
	if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
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
	
	if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
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

+ (id)deepMutableCopyWithJson:(id)json
{
	if (json == nil || [json isKindOfClass:[NSNull class]])
	{
		NSMutableString *str = [NSMutableString stringWithCapacity:0];
		return str;
	}
	
	if ([json isKindOfClass:[NSNumber class]])
	{
		NSMutableString *str = [NSMutableString stringWithCapacity:0];
		[str appendFormat:@"%@", json];
		return str;
	}
	
	if ([json isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for (id value in json)
		{
			[array addObject:[RFKit deepMutableCopyWithJson:value]];
		}
		return array;
	}
	
	if ([json isKindOfClass:[NSDictionary class]])
	{
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		for (NSString *key in json)
		{
			id value = [RFKit deepMutableCopyWithJson:json[key]];
			[dict setObject:value forKey:key];
		}
		return dict;
	}
	
	if ([json isKindOfClass:[NSString class]])
	{
		NSMutableString *str = [NSMutableString stringWithCapacity:0];
		[str appendFormat:@"%@", json];
		return str;
	}
	
	return json;
}

+ (NSString *)getUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef uuid = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return (__bridge_transfer NSString *)(uuid);
}

+ (NSString *)getUUIDNoSeparator
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	
    NSString *str = [(__bridge NSString *)string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(string);
    return str;
}

@end

#pragma mark RFKeyValuePair

@implementation RFKeyValuePair
@synthesize key;
@synthesize value;

- (id)initWithKey:(NSString *)aKey value:(id)aValue
{
	self = [super init];
    if (self)
    {
		key = SAFE_ARC_RETAIN(aKey);
		value = SAFE_ARC_RETAIN(aValue);
    }
    return self;
}

- (void)dealloc
{
	SAFE_ARC_RELEASE(key);
	SAFE_ARC_RELEASE(value);
	
	SAFE_ARC_SUPER_DEALLOC();
}

+ (RFKeyValuePair *)pairWithKey:(NSString *)key str:(NSString *)str
{
	RFKeyValuePair *pair = [[RFKeyValuePair alloc] initWithKey:key value:str];
	return SAFE_ARC_AUTORELEASE(pair);
}

+ (RFKeyValuePair *)pairWithKey:(NSString *)key num:(int64_t)num
{
	RFKeyValuePair *pair = [[RFKeyValuePair alloc] initWithKey:key
														 value:[NSString stringWithLongLong:num]];
	return SAFE_ARC_AUTORELEASE(pair);
}

+ (RFKeyValuePair *)pairWithNumKey:(int64_t)numKey num:(int64_t)num
{
	RFKeyValuePair *pair = [[RFKeyValuePair alloc] initWithKey:[NSString stringWithLongLong:numKey]
														 value:[NSString stringWithLongLong:num]];
	return SAFE_ARC_AUTORELEASE(pair);
}

@end

#pragma mark NSString (RFKit)

@implementation NSString (RFKit)

- (NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSInteger)charCount
{
	int strlength = 0;
    char *p = (char *)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++)
	{
        if (*p)
		{
            p++;
            strlength++;
        }
        else
		{
            p++;
        }
    }
    return strlength;
}

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

- (NSString *)stringByURLEncoding
{
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																							 (CFStringRef)self,
																							 NULL,
																							 CFSTR("!*'();:@&=+$,/?%#[]"),
																							 kCFStringEncodingUTF8);
	return SAFE_ARC_AUTORELEASE(result);
}

- (NSString *)stringByURLDecoding
{
	NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																											 (CFStringRef)self,
																											 CFSTR(""),
																											 kCFStringEncodingUTF8);
    return SAFE_ARC_AUTORELEASE(result);
}

- (NSString *)stringByFilterSymbols:(NSArray *)symbols
{
	NSMutableString *buffer = [NSMutableString stringWithString:self];
	for (NSString *s in symbols)
	{
		[buffer replaceOccurrencesOfString:s withString:@"" options:NSLiteralSearch range:NSMakeRange(0, buffer.length)];
	}
	return buffer;
}

- (NSString *)stringByTTSFilter
{
	return [self stringByFilterSymbols:
			@[
			 @"&",
			 @"%",
			 @"<",
			 @">",
			 @"#",
			 @"$"
			 ]
			];
}

- (BOOL)isPhone
{
	NSString *regex = @"\\d{3,20}";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	if ([predicate evaluateWithObject:self])
	{
		return YES;
	}
	return NO;
}

- (BOOL)isEmail
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
	return [emailTest evaluateWithObject:self];
}

- (CGFloat)heightWithFont:(UIFont *)font width:(CGFloat)width
{
	CGFloat height = 0;
	
	CGSize size = CGSizeZero;
	if (IS_IOS7)
	{
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
									font, NSFontAttributeName,
									nil];
		size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
								  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
							   attributes:attributes
								  context:nil].size;
	}
	else
	{
		size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, 9999) lineBreakMode:NSLineBreakByCharWrapping];
	}
	height = size.height;
	
	return height;
}

- (CGFloat)widthWithFont:(UIFont *)font
{
	CGSize size = CGSizeZero;
	if (IS_IOS7)
	{
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
									font, NSFontAttributeName,
									nil];
		size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, font.lineHeight)
								  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
							   attributes:attributes
								  context:nil].size;
	}
	else
	{
		size = [self sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, font.lineHeight) lineBreakMode:NSLineBreakByCharWrapping];
	}
	return size.width;
}

- (NSString *)toMD5
{
	const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
	
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

#pragma mark NSMutableString (RFKit)

@implementation NSMutableString (RFKit)

- (void)removeLastChar
{
	if (self.length > 0)
	{
		[self deleteCharactersInRange:NSMakeRange((self.length - 1), 1)];
	}
}

@end

#pragma mark NSDate (RFKit)

static int64_t s_deviation = 0;

@implementation NSDate (RFKit)

+ (NSString *)yyyyMMddHHmmssSince1970:(int64_t)millisecond
{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:((double)millisecond / 1000)];
	return [date yyyyMMddHHmmss];
}

- (NSString *)yyyyMMddHHmmss
{
	// 性能改善
	static NSDateFormatter *formater = nil;
	if (formater == nil)
	{
		formater = [[NSDateFormatter alloc] init];
		[formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	}
	
    NSString *strTime = [formater stringFromDate:self];
	return strTime;
}

+ (NSString *)yyyyMMddSince1970:(int64_t)millisecond
{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:((double)millisecond / 1000)];
	return [date yyyyMMdd];
}

- (NSString *)yyyyMMdd
{
	// 性能改善
	static NSDateFormatter *formater = nil;
	if (formater == nil)
	{
		formater = [[NSDateFormatter alloc] init];
		[formater setDateFormat:@"yyyy-MM-dd"];
	}
	
    NSString *strTime = [formater stringFromDate:self];
	return strTime;
}

+ (NSString *)yyyyMMddHHmmssTimestampSince1970:(int64_t)millisecond
{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:((double)millisecond / 1000)];
	return [date yyyyMMddHHmmssTimestampSince1970];
}

- (NSString *)yyyyMMddHHmmssTimestampSince1970
{
	// 性能改善
	static NSDateFormatter *formater = nil;
	if (formater == nil)
	{
		formater = [[NSDateFormatter alloc] init];
		[formater setDateFormat:@"yyyyMMddHHmmss"];
	}
	
    NSString *strTime = [formater stringFromDate:self];
	return strTime;
}

+ (int64_t)millisecondSince1970
{
	NSTimeInterval now = [[NSDate new] timeIntervalSince1970];
	return ((int64_t)(now*1000) + s_deviation);
}

+ (NSDate *)dateWithMillisecondSince1970:(int64_t)millisecond
{
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:((double)millisecond / 1000)];
	return date;
}

+ (void)modifyTimeWithLocal:(int64_t)local server:(int64_t)server
{
	s_deviation = server - local;
}

+ (NSDate *)dateString:(NSString *)dateString withFormatString:(NSString *)formateString;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formateString];
    NSDate *date = [dateFormatter dateFromString:dateString];
	return date;
}

@end
