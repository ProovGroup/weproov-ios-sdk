// Objective-C API for talking to bitbucket.org/weproov/weproovstrucgo/proover Go package.
//   gobind -lang=objc bitbucket.org/weproov/weproovstrucgo/proover
//
// File is generated by gobind. Do not edit.

#ifndef __Proover_H__
#define __Proover_H__

@import Foundation;
#include "Universe.objc.h"

#include "Wperr.objc.h"

@class ProoverInfos;
@class ProoverList;
@class ProoverStruct;
@protocol ProoverListDelegate;
@class ProoverListDelegate;

@protocol ProoverListDelegate <NSObject>
- (void)onProoverFindError:(NSError*)err;
- (void)onProoverFindsuccess:(ProoverList*)list;
@end

@interface ProoverInfos : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (NSString*)name;
- (void)setName:(NSString*)v;
- (NSString*)value;
- (void)setValue:(NSString*)v;
@end

@interface ProoverList : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (NSString*)find;
- (void)setFind:(NSString*)v;
- (long)offset;
- (void)setOffset:(long)v;
- (long)limit;
- (void)setLimit:(long)v;
- (BOOL)haveMore;
- (void)setHaveMore:(BOOL)v;
// skipped field List.Result with unsupported type: []bitbucket.org/weproov/weproovstrucgo/proover.Struct

- (long)count;
- (ProoverStruct*)get:(long)num;
- (void)next:(id<ProoverListDelegate>)delegate;
@end

@interface ProoverStruct : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (instancetype)init;
- (long)id_;
- (void)setId:(long)v;
- (long)userId;
- (void)setUserId:(long)v;
- (NSString*)identifier;
- (void)setIdentifier:(NSString*)v;
// skipped field Struct.Infos with unsupported type: []bitbucket.org/weproov/weproovstrucgo/proover.Infos

- (NSString*)company;
- (NSString*)email;
- (NSString*)firstName;
- (NSString*)get:(NSString*)name;
- (NSString*)lastName;
- (NSString*)phoneNumber;
@end

FOUNDATION_EXPORT ProoverStruct* ProoverCreateLightProover(NSString* firstName, NSString* lastName, NSString* email, NSString* number);

FOUNDATION_EXPORT void ProoverGetList(NSString* find, long offset, long limit, id<ProoverListDelegate> delegate);

FOUNDATION_EXPORT ProoverList* ProoverGetListSync(NSString* find, long offset, long limit, NSError** error);

@class ProoverListDelegate;

@interface ProoverListDelegate : NSObject <goSeqRefInterface, ProoverListDelegate> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (void)onProoverFindError:(NSError*)err;
- (void)onProoverFindsuccess:(ProoverList*)list;
@end

#endif
