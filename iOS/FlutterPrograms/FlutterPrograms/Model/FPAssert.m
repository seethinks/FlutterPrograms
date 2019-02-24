//
//  FPAssert.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/23.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPAssert.h"

@interface FPAssert()
{
    FPSpec *_spec;
    NSString *_appBundlePath;
}

@end

@implementation FPAssert

+ (instancetype)assertWithAppBundlePath:(NSString *)appBundlePath {
    FPAssert *assert = [[FPAssert alloc] initWithAppBundlePath:appBundlePath];
    return assert;
}

- (instancetype)initWithAppBundlePath:(NSString *)appBundlePath {
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
    return [self.appBundlePath stringByAppendingPathComponent:@"spec.json"];
}

- (NSString *)assertFilePath {
    return [self.appBundlePath stringByAppendingPathComponent:@"flutter_assets.zip"];
}

- (NSString *)launchAssertDirectory {
    return [[FPPath appBundlesPath] stringByAppendingPathComponent:self.spec.version];
}

- (NSString *)launchAssertPath {
    NSString *path = [self launchAssertDirectory];
    path = [path stringByAppendingPathComponent:@"flutter_assets"];
    return path;
}

@end
