//
//  FPMiddlemanResult.h
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/3/14.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPMiddlemanResult : NSObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, readonly) NSDictionary *dict;

@end

NS_ASSUME_NONNULL_END
