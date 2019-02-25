//
//  FPAssertManager.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/23.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPAssertManager.h"

@interface FPAssertManager()

@property (nonatomic, strong) NSArray<FPAssert *> *asserts;
@property (nonatomic, strong) FPAssert *launchAssert;

@end

@implementation FPAssertManager

static FPAssertManager *_instance = nil;

+ (instancetype)shared {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[FPAssertManager alloc] init];
            [_instance loadBundleAsserts];
        });
    }
    return _instance;
}


- (void)loadBundleAsserts {
    
    NSFileManager *fmgr = [NSFileManager defaultManager];
    NSMutableArray *bundleAsserts = [NSMutableArray new];
    NSString *localAppBundlesPath = [FPPath appBundlesPath];
    BOOL isDir = false;
    // 本地 bundles 路径存在，且为文件夹，遍历本地 app 可能存在版本的 bundle
    if ([fmgr fileExistsAtPath:localAppBundlesPath isDirectory:&isDir]) {
        if (isDir) {
            NSArray *bundles = [fmgr contentsOfDirectoryAtPath:localAppBundlesPath error:nil];
            if (bundles) {
                // 保存 bundle assert 对象
                for (NSString *bundle in bundles) {
                    NSString *bundlePath = [localAppBundlesPath stringByAppendingPathComponent:bundle];
                    FPAssert *assert = [FPAssert assertWithAppBundlePath:bundlePath];
                    if ([fmgr fileExistsAtPath:assert.specFilePath] && [fmgr fileExistsAtPath:assert.assertFilePath]) {
                        [bundleAsserts addObject:assert];
                    }
                }
            }
        }
    }
    
    // 获取 mainBundle 中 bundle 资源
    FPAssert *assert = [FPAssert assertWithAppBundlePath:[FPPath appBundlePathAtMainBundle]];
    if ([fmgr fileExistsAtPath:assert.specFilePath] && [fmgr fileExistsAtPath:assert.assertFilePath]) {
        [bundleAsserts addObject:assert];
    }
    
    // 根据 spec 版本号排序
    NSArray *bundleAssertsSorted = [bundleAsserts sortedArrayUsingComparator:^NSComparisonResult(FPAssert *  _Nonnull obj1, FPAssert *  _Nonnull obj2) {
        NSComparisonResult result = [obj2.spec.version compare:obj1.spec.version options:NSNumericSearch];
        return result;
    }];
    
    self.asserts = bundleAssertsSorted;
}


- (FPAssert *)launchAssert {
    if (!_launchAssert) {
        for (FPAssert *assert in self.asserts) {
            if ([SSZipArchive unzipFileAtPath:assert.assertFilePath toDestination:assert.launchAssertDirectory]) {
                _launchAssert = assert;
                break;
            }
        }
    }
    return _launchAssert;
}

- (BOOL)checkUpdate {
    
    NSString *updateSpecFilePath = [FPPath updateSpecFilePath];
    NSFileManager *fmgr = [NSFileManager defaultManager];
    if (![fmgr fileExistsAtPath:updateSpecFilePath]) {
        return false;
    }
    FPSpec *updateSpec = [FPSpec specWithPath:updateSpecFilePath];
    
    if (updateSpec.version.length == 0) {
        return false;
    }
    
    if ([updateSpec.version compare:self.launchAssert.spec.version options:NSNumericSearch] == NSOrderedAscending) {
        return false;
    }
    else {
        return true;
    }
}

- (void)downloadUpdateAssert {

    NSString *updateSpecPath = [FPPath updateSpecPath];
    FPAssert *assert = [FPAssert assertWithAppBundlePath:updateSpecPath];

    NSURL *URL = [NSURL URLWithString:assert.spec.flutterAssertUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSessionDownloadTask *downloadTask = [[FPNetworkManager shared] downloadTaskWithRequest:request  progress:^(NSProgress * _Nonnull downloadProgress) {

    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

        NSFileManager *fmgr = [NSFileManager defaultManager];
        NSString *tempPath = assert.assertFilePath;
        if ([fmgr fileExistsAtPath:tempPath]) {
            [fmgr removeItemAtPath:tempPath error:nil];
        }
        [fmgr createDirectoryAtPath:tempPath withIntermediateDirectories:true attributes:nil error:nil];

        NSURL *tempFileUrl = [NSURL fileURLWithPath:tempPath];
        return tempFileUrl;

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        BOOL isSuccess = false;
        NSFileManager *fmgr = [NSFileManager defaultManager];
        if (error) {
            [fmgr removeItemAtURL:filePath error:nil];
            isSuccess = false;
            FP_NSLog(@"%@", error);
        }
        else {
//            [fmgr removeItemAtPath:assert.assertPath error:nil];
//            [fmgr copyItemAtPath:filePath.path toPath:assert.assertPath error:nil];
//            [fmgr removeItemAtPath:assert.specFilePath error:nil];
//            [fmgr copyItemAtPath:FPApplicationUpdateSpecFileLocalPath() toPath:assert.specFilePath error:nil];
//            isSuccess = true;
            FP_NSLog(@"%@", filePath.path);
        }
    }];
    [downloadTask resume];
}

- (void)downloadUpdateSpec {
    
    NSURL *URL = [NSURL URLWithString:[FPPath updateSpecFileRemoteUrl]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [[FPNetworkManager shared] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSFileManager *fmgr = [NSFileManager defaultManager];
        BOOL isDir = false;
        NSString *updateSpecPath = [FPPath updateSpecPath];
        if (![fmgr fileExistsAtPath:updateSpecPath isDirectory:&isDir]) {
            [fmgr createDirectoryAtPath:updateSpecPath withIntermediateDirectories:true attributes:nil error:nil];
        }
        else {
            if (!isDir) {
                [fmgr removeItemAtPath:updateSpecPath error:nil];
                [fmgr createDirectoryAtPath:updateSpecPath withIntermediateDirectories:true attributes:nil error:nil];
            }
        }
        NSString *updateSpecFilePath = [FPPath updateSpecFilePath];
        if ([fmgr fileExistsAtPath:updateSpecFilePath]) {
            [fmgr removeItemAtPath:updateSpecFilePath error:nil];
        }
        
        NSURL *updateSpecFileUrl = [NSURL fileURLWithPath:updateSpecFilePath];
        return updateSpecFileUrl;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            NSFileManager *fmgr = [NSFileManager defaultManager];
            [fmgr removeItemAtURL:filePath error:nil];
            FP_NSLog(@"%@", filePath.path)
            FP_NSLog(@"%@", error);
        }
        else {
            FP_NSLog(@"%@", filePath.path)
        }
    }];
    [downloadTask resume];
}

lazygetter(NSArray, asserts)

//
//- (void)fetchApplicationAssert:(FPAssert *)assert  progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(BOOL isSuccess)) completionHandler {
//    
//    
//    NSData *specData = [NSData dataWithContentsOfFile:assert.specFilePath];
//    NSDictionary *specDict = [NSJSONSerialization JSONObjectWithData:specData options:NSJSONReadingMutableContainers error:nil];
//    NSString *assertUrl = [specDict objectForKey:@"flutterAssertUrl"];
//    
//    NSURL *URL = [NSURL URLWithString:assertUrl];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDownloadTask *downloadTask = [[FPNetworkManager shared] downloadTaskWithRequest:request  progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        
//        NSFileManager *fmgr = [NSFileManager defaultManager];
//        NSString *tempPath = FPApplicationAssertTempPath();
//        if ([fmgr fileExistsAtPath:tempPath]) {
//            [fmgr removeItemAtPath:tempPath error:nil];
//        }
//        [fmgr createDirectoryAtPath:tempPath withIntermediateDirectories:true attributes:nil error:nil];
//        
//        NSURL *tempFileUrl = [NSURL fileURLWithPath:tempPath];
//        return tempFileUrl;
//        
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        BOOL isSuccess = false;
//        NSFileManager *fmgr = [NSFileManager defaultManager];
//        if (error) {
//            [fmgr removeItemAtURL:filePath error:nil];
//            isSuccess = false;
//            FP_NSLog(@"%@", error);
//        }
//        else {
//            [fmgr removeItemAtPath:assert.assertPath error:nil];
//            [fmgr copyItemAtPath:filePath.path toPath:assert.assertPath error:nil];
//            [fmgr removeItemAtPath:assert.specFilePath error:nil];
//            [fmgr copyItemAtPath:FPApplicationUpdateSpecFileLocalPath() toPath:assert.specFilePath error:nil];
//            isSuccess = true;
//            FP_NSLog(@"%@", filePath.path);
//        }
//        completionHandler(isSuccess);
//    }];
//    [downloadTask resume];
//}
//

//
//- (BOOL)checkVersionWithApplicationAssert:(FPAssert *)info {
//    NSString *updateSpecFilePath = FPApplicationUpdateSpecFileLocalPath();
//    NSFileManager *fmgr = [NSFileManager defaultManager];
//    if (![fmgr fileExistsAtPath:updateSpecFilePath]) {
//        return false;
//    }
//    else {
//        NSData *updateSpecData = [NSData dataWithContentsOfFile:updateSpecFilePath];
//        NSDictionary *updateSpecDict = [NSJSONSerialization JSONObjectWithData:updateSpecData options:NSJSONReadingMutableContainers error:nil];
//        NSString *updateVersion = [updateSpecDict objectForKey:@"version"];
//        
//        NSData *localSpecData = [NSData dataWithContentsOfFile:info.specFilePath];
//        NSDictionary *localSpecDict = [NSJSONSerialization JSONObjectWithData:localSpecData options:NSJSONReadingMutableContainers error:nil];
//        NSString *localVersion = [localSpecDict objectForKey:@"version"];
//        
//        if (updateVersion == nil || localVersion == nil) {
//            return false;
//        }
//        
//        if ([updateVersion compare:localVersion options:NSNumericSearch] == NSOrderedDescending) {
//            return true;
//        }
//        else {
//            return false;
//        }
//    }
//}
//
//
//- (void)getApplicationAssert:(void (^)(FPAssert *info))callback {
//    
//    FPAssert *info = [FPAssert new];
//    NSFileManager *fmgr = [NSFileManager defaultManager];
//    info.specFilePath = FPApplicationSpecFilePath();
//    info.assertPath = FPApplicationAssertPath();
//    
//    if (![fmgr fileExistsAtPath:info.specFilePath]) {
//        callback([self getMainBundleApplicationAssert]);
//    }
//    
//    NSString *assertFilePath = FPApplicationAssertFilePath();
//    if ([SSZipArchive unzipFileAtPath:assertFilePath toDestination:info.assertPath]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            callback(info);
//        });
//    }
//    else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            callback([self getMainBundleApplicationAssert]);
//        });
//    }
//}
//
//- (FPAssert *)getMainBundleApplicationAssert {
//    FPAssert *info = [FPAssert new];
//    info.specFilePath = FPMainBundleApplicationSpecFilePath();
//    info.assertPath = FPMainBundleApplicationAssertPath();
//    return info;
//}
//
//- (void)getApplicationPath {
//    
//}


//- (void)fetchApplicationUpdateAssert
//Progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
//                           completionHandler:(void (^)())completionHandler {
//
//    NSURL *URL = [NSURL URLWithString:FPApplicationUpdateSpecFileRemoteUrl()];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//
//    NSURLSessionDownloadTask *downloadTask = [[FPNetworkManager shared] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//
//        NSFileManager *fmgr = [NSFileManager defaultManager];
//        BOOL isDir = false;
//        NSString *updateSpecPath = FPApplicationUpdateSpecFileLocalPath();
//        if (![fmgr fileExistsAtPath:updateSpecPath isDirectory:&isDir]) {
//            [fmgr createDirectoryAtPath:updateSpecPath withIntermediateDirectories:true attributes:nil error:nil];
//        }
//        else {
//            if (!isDir) {
//                [fmgr removeItemAtPath:updateSpecPath error:nil];
//                [fmgr createDirectoryAtPath:updateSpecPath withIntermediateDirectories:true attributes:nil error:nil];
//            }
//        }
//        NSString *updateSpecFilePath = FPApplicationUpdateSpecFileLocalPath();
//        if ([fmgr fileExistsAtPath:updateSpecFilePath]) {
//            [fmgr removeItemAtPath:updateSpecFilePath error:nil];
//        }
//
//        NSURL *updateSpecFileUrl = [NSURL fileURLWithPath:updateSpecFilePath];
//        return updateSpecFileUrl;
//
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        if (error) {
//            NSFileManager *fmgr = [NSFileManager defaultManager];
//            [fmgr removeItemAtURL:filePath error:nil];
//            FP_NSLog(@"%@", error);
//        }
//        else {
//            FP_NSLog(@"%@", filePath.path);
//        }
//    }];
//    [downloadTask resume];
//
//}

@end
