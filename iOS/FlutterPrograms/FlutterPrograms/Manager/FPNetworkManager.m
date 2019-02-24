//
//  FPNetworkManager.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/23.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPNetworkManager.h"

@implementation FPNetworkManager

static FPNetworkManager *_instance = nil;

+ (instancetype)shared {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            _instance = [[FPNetworkManager alloc] initWithSessionConfiguration:configuration];
        });
    }
    return _instance;
}

@end
