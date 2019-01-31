// Objective-C API for talking to bitbucket.org/weproov/weproovstrucgo/requestNative Go package.
//   gobind -lang=objc bitbucket.org/weproov/weproovstrucgo/requestNative
//
// File is generated by gobind. Do not edit.

#ifndef __Rn_H__
#define __Rn_H__

@import Foundation;
#include "Universe.objc.h"


@class RnHttpGolangWarperResponce;
@protocol RnHttpGolangWarperDelegate;
@class RnHttpGolangWarperDelegate;

@protocol RnHttpGolangWarperDelegate <NSObject>
- (void)get:(NSString*)url token:(NSString*)token resp:(RnHttpGolangWarperResponce*)resp;
@end

@interface RnHttpGolangWarperResponce : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
// skipped field HttpGolangWarperResponce.Wg with unsupported type: *types.Named

- (long)statusCode;
- (void)setStatusCode:(long)v;
- (NSData*)data;
- (void)setData:(NSData*)v;
- (NSError*)error;
- (void)setError:(NSError*)v;
- (void)set:(long)status data:(NSData*)data err:(NSError*)err;
- (void)setStringError:(NSString*)value;
@end

/**
 * func Get(url string, token string) *HttpGolangWarperResponce {
	resp := &HttpGolangWarperResponce{}
	resp.Wg.Add(1)
	C.getDataFromAsync(C.CString(url), C.CString(token), unsafe.Pointer(resp))
	resp.Wg.Wait()
	return resp
}
 */
FOUNDATION_EXPORT RnHttpGolangWarperResponce* RnGet(NSString* url, NSString* token);

FOUNDATION_EXPORT BOOL RnHaveDelegate(void);

FOUNDATION_EXPORT void RnSetDelegate(id<RnHttpGolangWarperDelegate> delegate);

@class RnHttpGolangWarperDelegate;

@interface RnHttpGolangWarperDelegate : NSObject <goSeqRefInterface, RnHttpGolangWarperDelegate> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (void)get:(NSString*)url token:(NSString*)token resp:(RnHttpGolangWarperResponce*)resp;
@end

#endif
