//
//  FPAppBundleManager.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/23.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPAppBundleManager.h"

@interface FPAppBundleManager()

@property (nonatomic, strong) NSArray<FPAppBundle *> *appBundles;
@property (nonatomic, strong) FPAppBundle *launchAppBundle;

@end

@implementation FPAppBundleManager

static FPAppBundleManager *_instance = nil;

+ (instancetype)shared {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[FPAppBundleManager alloc] init];
            [_instance loadAppBundles];
        });
    }
    return _instance;
}


- (void)loadAppBundles {
    
    NSFileManager *fmgr = [NSFileManager defaultManager];
    NSMutableArray *AppBundles = [NSMutableArray new];
    NSString *localAppBundlesPath = [FPPath appBundlesPath];
    BOOL isDir = false;
    // 本地 bundles 路径存在，且为文件夹，遍历本地 app 可能存在版本的 bundle
    if ([fmgr fileExistsAtPath:localAppBundlesPath isDirectory:&isDir]) {
        if (isDir) {
            NSArray *bundles = [fmgr contentsOfDirectoryAtPath:localAppBundlesPath error:nil];
            if (bundles) {
                // 保存 bundle 对象
                for (NSString *bundle in bundles) {
                    NSString *bundlePath = [localAppBundlesPath stringByAppendingPathComponent:bundle];
                    FPAppBundle *appBundle = [FPAppBundle appBundleWithPath:bundlePath];
                    if ([fmgr fileExistsAtPath:appBundle.specFilePath] && [fmgr fileExistsAtPath:appBundle.assertFilePath]) {
                        [AppBundles addObject:appBundle];
                    }
                }
            }
        }
    }
    
    // 获取 mainBundle 中 bundle 资源
    FPAppBundle *appBundle = [FPAppBundle appBundleWithPath:[FPPath appBundlePathAtMainBundle]];
    if ([fmgr fileExistsAtPath:appBundle.specFilePath] && [fmgr fileExistsAtPath:appBundle.assertFilePath]) {
        [AppBundles addObject:appBundle];
    }
    
    // 根据 spec 版本号排序
    NSArray *appBundlesSorted = [AppBundles sortedArrayUsingComparator:^NSComparisonResult(FPAppBundle *  _Nonnull obj1, FPAppBundle *  _Nonnull obj2) {
        NSComparisonResult result = [obj2.spec.version compare:obj1.spec.version options:NSNumericSearch];
        return result;
    }];
    
    self.appBundles = appBundlesSorted;
}


- (FPAppBundle *)launchAppBundle {
    if (!_launchAppBundle) {
        for (FPAppBundle *bundle in self.appBundles) {
            if ([SSZipArchive unzipFileAtPath:bundle.assertFilePath toDestination:bundle.launchPath]) {
                _launchAppBundle = bundle;
                break;
            }
        }
    }
    return _launchAppBundle;
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
    
    NSString *currentVersion = self.launchAppBundle.spec.version;
    NSString *updateVersion = updateSpec.version;
    if (!([updateVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending)) {
        return false;
    }
    
    return true;
}

- (void)downloadUpdateAssertFile {
    
    NSString *updateSpecFilePath = [FPPath updateSpecFilePath];
    NSFileManager *fmgr = [NSFileManager defaultManager];
    if (![fmgr fileExistsAtPath:updateSpecFilePath]) {
        return;
    }
    FPSpec *spec = [FPSpec specWithPath:updateSpecFilePath];

    NSURL *URL = [NSURL URLWithString:spec.flutterAssertUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSessionDownloadTask *downloadTask = [[FPNetworkManager shared] downloadTaskWithRequest:request  progress:^(NSProgress * _Nonnull downloadProgress) {
        FP_NSLog(@"downloadUpdateAssertFile: %@", downloadProgress.localizedDescription);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

        NSFileManager *fmgr = [NSFileManager defaultManager];
        NSString *appBundlePath = [FPPath appBundlePathWithSpec:spec];
        if ([fmgr fileExistsAtPath:appBundlePath]) {
            [fmgr removeItemAtPath:appBundlePath error:nil];
        }
        [fmgr createDirectoryAtPath:appBundlePath withIntermediateDirectories:true attributes:nil error:nil];

        NSString *assertFilePath = [FPPath assertFilePathWithSpec:spec];
        NSURL *fileUrl = [NSURL fileURLWithPath:assertFilePath];
        return fileUrl;

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (!error) {
            NSFileManager *fmgr = [NSFileManager defaultManager];
            NSError *copyError = nil;
            [fmgr copyItemAtPath:updateSpecFilePath toPath:[FPPath specFilePathWithSpec:spec] error:&copyError];
            if (copyError) {
                [fmgr removeItemAtPath:[FPPath appBundlePathWithSpec:spec] error:nil];
            }
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
        
    }];
    [downloadTask resume];
}

lazygetter(NSArray, appBundles)

@end
