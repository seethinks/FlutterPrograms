//
//  FPAppController.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/26.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPAppController.h"
#import "FPProgramController.h"

@interface FPAppController ()

@end

@implementation FPAppController

- (instancetype)initWithAppBundle:(FPAppBundle *)appBundle nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithFlutterAssertPath:appBundle.launchAssertPath nibName:nil bundle:nil];
    if (self) {
        _appBunndle = appBundle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupMiddleman];
}

- (void)setupMiddleman {
    __weak typeof(self) weakSelf = self;
    [[MiddlemanPlugin shared] setMethodCallHandler:@"openProgram" handler:^(id arguments, FlutterResult result) {
        NSLog(@"Native iOS %@:%@",NSStringFromClass([weakSelf class]), arguments);
        if ([arguments isKindOfClass:[NSDictionary class]]) {
            NSDictionary *openInfo = [self openProgram:arguments];
            return result(openInfo);
        }
        else {
            FPMiddlemanResult *openInfo = [FPMiddlemanResult new];
            openInfo.code = @"1";
            openInfo.message = @"应用参数错误";
            return result(openInfo.dict);
        }
    }];
    
    [[MiddlemanPlugin shared] setMethodCallHandler:@"getAppSpec" handler:^(id arguments, FlutterResult result) {
        NSLog(@"Native iOS %@:%@",NSStringFromClass([weakSelf class]), arguments);
        NSData *specData = [NSData dataWithContentsOfFile:self.appBunndle.specFilePath];
        NSString *specString = [[NSString alloc] initWithData:specData encoding:NSUTF8StringEncoding];
        specString = (specString == nil) ? @"" : specString;
        FPMiddlemanResult *openInfo = [FPMiddlemanResult new];
        openInfo.code = @"0";
        openInfo.message = @"成功";
        openInfo.data = @{
                          @"specString" : specString,
                          };
        return result(openInfo.dict);
    }];
}

- (NSDictionary *)openProgram:(NSDictionary *)specJson {
    
    FPSpec *spec = [FPSpec new];
    [spec setValuesForKeysWithDictionary:specJson];
    if (![FPFileMD5 checkProgramAssertMD5WithSpec:spec]) {
        FPMiddlemanResult *openInfo = [FPMiddlemanResult new];
        openInfo.code = @"2";
        openInfo.message = @"程序校验失败!";
        return openInfo.dict;
    }
    NSString *assertFilePath = [FPPath programLaunchAssertFilePathWithSpec:spec];
    NSString *launchPath = [FPPath programLaunchPathWithSpec:spec];
    if (![SSZipArchive unzipFileAtPath:assertFilePath toDestination:launchPath]) {
        FPMiddlemanResult *openInfo = [FPMiddlemanResult new];
        openInfo.code = @"3";
        openInfo.message = @"程序解压失败!";
        return openInfo.dict;
    }
    NSString *LaunchAssertPath = [FPPath programLaunchAssertPathWithSpec:spec];
    FPProgramController *vc = [[FPProgramController alloc] initWithFlutterAssertPath:LaunchAssertPath nibName:nil bundle:nil];
    [GeneratedPluginRegistrant registerWithRegistry:vc.pluginRegistry];
    [self presentViewController:vc animated:true completion:nil];
    
    FPMiddlemanResult *openInfo = [FPMiddlemanResult new];
    openInfo.code = @"0";
    openInfo.message = @"程序打开成功";
    return openInfo.dict;
}

@end
