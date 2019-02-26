//
//  FPPath.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/24.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPPath.h"

@implementation FPPath

+ (NSString *)updateSpecFileRemoteUrl {
    return @"https://raw.githubusercontent.com/FlutterPrograms/UpdateSpec/master/spec/spec.json";
}

+ (NSString *)applicationPath {
    return [HJM_PathDocuments stringByAppendingPathComponent:@"Application"];
}

+ (NSString *)appBundlesPath {
    return [[self applicationPath] stringByAppendingPathComponent:@"Bundles"];
}

+ (NSString *)appLaunchsPath {
    return [[self applicationPath] stringByAppendingPathComponent:@"Launchs"];
}

+ (NSString *)updateSpecPath {
    return [[self applicationPath] stringByAppendingPathComponent:@"UpdateSpec"];
}

+ (NSString *)appBundlePathWithSpec:(FPSpec *)spec {
    return [[self appBundlesPath] stringByAppendingPathComponent:spec.version];
}

+ (NSString *)appLaunchPathWithSpec:(FPSpec *)spec {
    return [[self appLaunchsPath] stringByAppendingPathComponent:spec.version];
}

+ (NSString *)assertFilePathWithSpec:(FPSpec *)spec {
    NSString *path = [self appBundlePathWithSpec:spec];
    path = [path stringByAppendingPathComponent:FP_ASSERT_FILE_NAME];
    return path;
}

+ (NSString *)specFilePathWithSpec:(FPSpec *)spec {
    NSString *path = [self appBundlePathWithSpec:spec];
    path = [path stringByAppendingPathComponent:FP_SPEC_FILE_NAME];
    return path;
}

+ (NSString *)appLaunchAssertPathWithSpec:(FPSpec *)spec {
    NSString *path = [self appLaunchPathWithSpec:spec];
    path = [path stringByAppendingPathComponent:FP_ASSERT_PATH_NAME];
    return path;
}

+ (NSString *)updateSpecFilePath {
    return [[self updateSpecPath] stringByAppendingPathComponent:FP_SPEC_FILE_NAME];
}

+ (NSString *)appBundlePathAtMainBundle {
    NSString *path = [NSBundle mainBundle].bundlePath;
    path = [path stringByAppendingPathComponent:@"flutter_bundle"];
    return path;
}

+ (NSString *)programsPath {
    return [HJM_PathDocuments stringByAppendingPathComponent:@"Programs"];
}

+ (NSString *)programBundlePathWithSpec:(FPSpec *)spec {
    NSString *path = [self programsPath];
    path = [path stringByAppendingPathComponent:spec.ID];
    path = [path stringByAppendingPathComponent:spec.version];
    return path;
}

+ (NSString *)programLaunchPathWithSpec:(FPSpec *)spec {
    return [self programBundlePathWithSpec:spec];
}

+ (NSString *)programLaunchAssertFilePathWithSpec:(FPSpec *)spec {
    NSString *path = [self programLaunchPathWithSpec:spec];
    path = [path stringByAppendingPathComponent:FP_ASSERT_FILE_NAME];
    return path;
}

+ (NSString *)programLaunchAssertPathWithSpec:(FPSpec *)spec {
    NSString *path = [self programLaunchPathWithSpec:spec];
    path = [path stringByAppendingPathComponent:FP_ASSERT_PATH_NAME];
    return path;
}

@end
