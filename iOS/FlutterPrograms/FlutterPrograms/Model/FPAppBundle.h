//
//  FPAppBundle.h
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/23.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPAppBundle : NSObject

+ (instancetype)appBundleWithPath:(NSString *)appBundlePath;

@property (nonatomic, readonly) FPSpec *spec;
@property (nonatomic, readonly) NSString *appBundlePath;
@property (nonatomic, readonly) NSString *specFilePath;
@property (nonatomic, readonly) NSString *assertFilePath;

- (NSString *)launchPath ;
- (NSString *)launchAssertPath;
- (BOOL)checkAssertMD5;

@end

NS_ASSUME_NONNULL_END
