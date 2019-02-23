//
//  FPNetworkManager.h
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/23.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPNetworkManager : AFHTTPSessionManager

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
