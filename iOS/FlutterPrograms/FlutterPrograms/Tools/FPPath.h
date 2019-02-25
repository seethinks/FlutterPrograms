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
+ (NSString *)launchAssertPathWithSpec:(FPSpec *)spec;
+ (NSString *)launchAssertDirectoryWithSpec:(FPSpec *)spec;
+ (NSString *)appBundlePathAtMainBundle;

+ (NSString *)updateSpecFileRemoteUrl;
+ (NSString *)updateSpecPath;
+ (NSString *)updateSpecFilePath;

@end

NS_ASSUME_NONNULL_END
