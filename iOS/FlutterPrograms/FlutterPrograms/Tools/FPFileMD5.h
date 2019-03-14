//
//  FPFileMD5.h
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/3/14.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPFileMD5 : NSObject

/**
 校验应用

 @param spec 应用spec
 @return 校验结果
 */
+ (BOOL)checkProgramAssertMD5WithSpec:(FPSpec *)spec;

/**
 app校验

 @param appBundle appBundle对象
 @return 校验结果
 */
+ (BOOL)checkAppAssertMD5WithAppBundle:(FPAppBundle *)appBundle;

@end

NS_ASSUME_NONNULL_END
