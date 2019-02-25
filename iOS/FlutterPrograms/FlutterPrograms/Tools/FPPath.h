//
//  FPPath.h
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/24.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPPath : NSObject

+ (NSString *)applicationPath;

+ (NSString *)appBundlesPath;
+ (NSString *)appBundlePathWithSpec:(FPSpec *)spec;
+ (NSString *)assertFilePathWithSpec:(FPSpec *)spec;
+ (NSString *)specFilePathWithSpec:(FPSpec *)spec;

+ (NSString *)updateSpecFileRemoteUrl;
+ (NSString *)updateSpecPath;
+ (NSString *)updateSpecFilePath;

+ (NSString *)appLaunchsPath;
+ (NSString *)appLaunchPathWithSpec:(FPSpec *)spec;
+ (NSString *)appLaunchAssertPathWithSpec:(FPSpec *)spec;

+ (NSString *)appBundlePathAtMainBundle;

@end

NS_ASSUME_NONNULL_END
