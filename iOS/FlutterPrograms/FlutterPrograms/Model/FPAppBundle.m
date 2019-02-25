//
//  FPAppBundle.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/23.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPAppBundle.h"

@interface FPAppBundle()
{
    FPSpec *_spec;
    NSString *_appBundlePath;
}

@end

@implementation FPAppBundle

+ (instancetype)appBundleWithPath:(NSString *)appBundlePath {
    FPAppBundle *appBundle = [[FPAppBundle alloc] initWithPath:appBundlePath];
    return appBundle;
}

- (instancetype)initWithPath:(NSString *)appBundlePath {
    self = [super init];
    if (self) {
        _appBundlePath = appBundlePath;
    }
    return self;
}

- (FPSpec *)spec {
    if (!_spec) {
        _spec = [FPSpec specWithPath:self.specFilePath];
    }
    return _spec;
}

- (NSString *)specFilePath {
    return [self.appBundlePath stringByAppendingPathComponent:FP_SPEC_FILE_NAME];
}

- (NSString *)assertFilePath {
    return [self.appBundlePath stringByAppendingPathComponent:FP_ASSERT_FILE_NAME];
}

- (NSString *)launchPath {
    return [FPPath appLaunchPathWithSpec:self.spec];
}

- (NSString *)launchAssertPath {
    return [FPPath appLaunchAssertPathWithSpec:self.spec];
}

@end
