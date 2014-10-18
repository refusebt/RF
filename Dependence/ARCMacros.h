//  
//  ARCMacros.h  
//  InnerBand  
//  
// For an explanation of why these work, see:  
//  
//     http://raptureinvenice.com/arc-support-without-branches/  
//  
//  Created by John Blanco on 1/28/12.  
//  Rapture In Venice releases all rights to this code.  Feel free use and/or copy it openly and freely!  
//  
// NOTE: __bridge_tranfer is not included here because releasing would be inconsistent.  
//       Avoid it unless you're using ARC exclusively or managing it with __has_feature(objc_arc).  
//

//#if !defined(__clang__) || __clang_major__ < 3  
//    #ifndef __bridge  
//        #define __bridge  
//    #endif  
//  
//    #ifndef __bridge_retain  
//        #define __bridge_retain  
//    #endif
//  
//    #ifndef __bridge_retained  
//        #define __bridge_retained  
//    #endif
//
//    #ifndef __bridge_transfer
//        #define __bridge_transfer
//    #endif
//  
//    #ifndef __autoreleasing  
//        #define __autoreleasing  
//    #endif  
//  
//    #ifndef __strong  
//        #define __strong  
//    #endif  
//  
//    #ifndef __unsafe_unretained  
//        #define __unsafe_unretained  
//    #endif  
//  
//    #ifndef __weak  
//        #define __weak  
//    #endif
//#endif  

#if __has_feature(objc_arc)  

#else
	#define __bridge
	#define __bridge_retain
	#define __bridge_retained
	#define __bridge_transfer
	#define __autoreleasing 
	#define __strong
	#define __unsafe_unretained
	#ifdef __weak
		#undef __weak
		#define __weak
	#endif
#endif

#if __has_feature(objc_arc)  
    #define SAFE_ARC_PROP_RETAIN strong  
    #define SAFE_ARC_RETAIN(x) (x)  
    #define SAFE_ARC_RELEASE(x)  
    #define SAFE_ARC_AUTORELEASE(x) (x)  
    #define SAFE_ARC_BLOCK_COPY(x) (x)  
    #define SAFE_ARC_BLOCK_RELEASE(x)  
    #define SAFE_ARC_SUPER_DEALLOC()  
    #define SAFE_ARC_AUTORELEASE_POOL_START() @autoreleasepool {  
    #define SAFE_ARC_AUTORELEASE_POOL_END() }
	#define SAFE_ARC_RETAIN_AUTORELEASE(x) (x)
#else
    #define SAFE_ARC_PROP_RETAIN retain  
    #define SAFE_ARC_RETAIN(x) ([(x) retain])  
    #define SAFE_ARC_RELEASE(x) ([(x) release])  
    #define SAFE_ARC_AUTORELEASE(x) ([(x) autorelease])  
    #define SAFE_ARC_BLOCK_COPY(x) (Block_copy(x))  
    #define SAFE_ARC_BLOCK_RELEASE(x) (Block_release(x))  
    #define SAFE_ARC_SUPER_DEALLOC() ([super dealloc])  
//    #define SAFE_ARC_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    #define SAFE_ARC_AUTORELEASE_POOL_END() [pool release];
	#define SAFE_ARC_AUTORELEASE_POOL_START() @autoreleasepool {
	#define SAFE_ARC_AUTORELEASE_POOL_END() }
	#define SAFE_ARC_RETAIN_AUTORELEASE(x) ([[(x) retain] autorelease])
#endif

#ifndef SAFE_ARC_STRONG
	#if __has_feature(objc_arc)
		#define SAFE_ARC_STRONG strong
	#else
		#define SAFE_ARC_STRONG retain
	#endif
#endif

#ifndef SAFE_ARC_WEAK
	#if __has_feature(objc_arc_weak)
		#define SAFE_ARC_WEAK weak
	#elif __has_feature(objc_arc)
		#define SAFE_ARC_WEAK unsafe_unretained
	#else
		#define SAFE_ARC_WEAK assign
	#endif
#endif
