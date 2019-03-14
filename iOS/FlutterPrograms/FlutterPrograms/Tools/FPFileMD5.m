//
//  FPFileMD5.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/3/14.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPFileMD5.h"

@implementation FPFileMD5

+ (BOOL)checkAssertMD5WithAssertFilePath:(NSString *)assertFilePath spec:(FPSpec *)spec {
    
    // 文件检查
    NSFileManager *fmgr = [NSFileManager defaultManager];
    BOOL isDir = true;
    if ([fmgr fileExistsAtPath:assertFilePath isDirectory:&isDir]) {
        if (isDir) {
            return false;
        }
    }
    
    // md5校验
    NSString *assertMD5 = [FileHash md5HashOfFileAtPath:assertFilePath];
    if ([assertMD5 isEqualToString:spec.flutterAssertMD5]) {
        return true;
    }
    return false;
}

+ (BOOL)checkProgramAssertMD5WithSpec:(FPSpec *)spec {
    NSString *assertFilePath = [FPPath programLaunchAssertFilePathWithSpec:spec];
    return [self checkAssertMD5WithAssertFilePath:assertFilePath spec:spec];
}

+ (BOOL)checkAppAssertMD5WithAppBundle:(FPAppBundle *)appBundle {
    return [self checkAssertMD5WithAssertFilePath:appBundle.assertFilePath spec:appBundle.spec];
}

@end
