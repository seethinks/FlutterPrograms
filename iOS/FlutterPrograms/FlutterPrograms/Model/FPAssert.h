//
//  FPAssert.h
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/23.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPAssert : NSObject

+ (instancetype)assertWithAppBundlePath:(NSString *)appBundlePath;

@property (nonatomic, readonly) FPSpec *spec;
@property (nonatomic, readonly) NSString *appBundlePath;
@property (nonatomic, readonly) NSString *specFilePath;
@property (nonatomic, readonly) NSString *assertFilePath;
@property (nonatomic, readonly) NSString *launchAssertDirectory;
@property (nonatomic, readonly) NSString *launchAssertPath;

@end

NS_ASSUME_NONNULL_END
