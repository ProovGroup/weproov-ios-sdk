// Objective-C API for talking to bitbucket.org/weproov/weproovstrucgo/pack Go package.
//   gobind -lang=objc bitbucket.org/weproov/weproovstrucgo/pack
//
// File is generated by gobind. Do not edit.

#ifndef __Pack_H__
#define __Pack_H__

@import Foundation;
#include "Universe.objc.h"

#include "Cachedimage.objc.h"
#include "Translations.objc.h"

@class PackPacks;
@class PackStruct;
@protocol PackDelegate;
@class PackDelegate;

@protocol PackDelegate <NSObject>
- (void)onPackError:(NSError*)err;
- (void)onPackSuccess;
@end

@interface PackPacks : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
// skipped field Packs.Packs with unsupported type: *types.Slice

- (long)count;
- (PackStruct*)get:(long)num;
@end

@interface PackStruct : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (NSString*)name;
- (void)setName:(NSString*)v;
- (NSString*)type;
- (void)setType:(NSString*)v;
- (long)title;
- (void)setTitle:(long)v;
- (long)cachedId;
- (void)setCachedId:(long)v;
// skipped field Struct.Title_ with unsupported type: *types.Named

- (long)ask;
- (void)setAsk:(long)v;
// skipped field Struct.Ask_ with unsupported type: *types.Named

// skipped field Struct.Subpack with unsupported type: *types.Slice

// skipped field Struct.PackIds with unsupported type: *types.Slice

- (long)countSubpack;
- (NSString*)getAskTr;
- (void)getImage:(id<CachedimageDelegate>)delegate;
- (PackStruct*)getSubpack:(long)num;
- (NSString*)getTitleTr;
- (BOOL)haveAsk;
- (BOOL)haveSubpack;
- (void)send:(long)val delegate:(id<PackDelegate>)delegate;
@end

FOUNDATION_EXPORT void PackDownloadPack(id<PackDelegate> delegate);

FOUNDATION_EXPORT PackPacks* PackGetAlls(void);

@class PackDelegate;

@interface PackDelegate : NSObject <goSeqRefInterface, PackDelegate> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (void)onPackError:(NSError*)err;
- (void)onPackSuccess;
@end

#endif
