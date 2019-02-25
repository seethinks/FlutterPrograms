//
//  FPAssertManager.h
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/23.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPAssertManager : NSObject

@property (nonatomic, readonly) NSArray<FPAssert *> *asserts;
@property (nonatomic, readonly) FPAssert *launchAssert;

+ (instancetype)shared;

- (BOOL)checkUpdate;
- (void)downloadUpdateSpec;
//- (void)fetchApplicationUpdateSpec;
//- (void)fetchApplicationUpdateAssert;
//- (void)getApplicationAssert:(void (^)(FPAssert *info))callback;
//- (BOOL)checkVersionWithApplicationAssert:(FPAssert *)info;
//- (void)fetchApplicationAssert:(FPAssert *)assert  progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(BOOL isSuccess)) completionHandler;

@end

NS_ASSUME_NONNULL_END
