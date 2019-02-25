//
//  FPAppBundleManager.h
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/23.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPAppBundleManager : NSObject

@property (nonatomic, readonly) NSArray<FPAppBundle *> *asserts;
@property (nonatomic, readonly) FPAppBundle *launchAppBundle;

+ (instancetype)shared;

- (BOOL)checkUpdate;
- (void)downloadUpdateSpec;
- (void)downloadUpdateAssertFile;

@end

NS_ASSUME_NONNULL_END
