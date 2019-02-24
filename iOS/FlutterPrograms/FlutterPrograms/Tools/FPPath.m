//
//  FPPath.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/24.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPPath.h"

@implementation FPPath

+ (NSString *)applicationUpdateSpecFileRemoteUrl {
    return @"https://raw.githubusercontent.com/FlutterPrograms/UpdateSpec/master/spec/spec.json";
}

+ (NSString *)applicationPath {
    return [HJM_PathDocuments stringByAppendingPathComponent:@"Application"];
}

+ (NSString *)updateSpecPath {
    return [[self applicationPath] stringByAppendingPathComponent:@"UpdateSpec"];
}

+ (NSString *)appBundlesPath {
    return [[self applicationPath] stringByAppendingPathComponent:@"Bundles"];
}

+ (NSString *)updateSpecPathFilePath {
    return [[self updateSpecPath] stringByAppendingString:FP_SPEC_FILE_NAME];
}

+ (NSString *)launchAssertDirectoryWithSpec:(FPSpec *)spec {
    return [[self appBundlesPath] stringByAppendingPathComponent:spec.version];
}

+ (NSString *)launchAssertPathWithSpec:(FPSpec *)spec {
    NSString *path = [self launchAssertDirectoryWithSpec:spec];
    path = [path stringByAppendingPathComponent:@"flutter_assets"];
    return path;
}

+ (NSString *)appBundlePathAtMainBundle {
    NSString *path = [NSBundle mainBundle].bundlePath;
    path = [path stringByAppendingPathComponent:@"flutter_bundle"];
    return path;
}

@end
