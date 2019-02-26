//
//  FPAppController.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/26.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPAppController.h"
#import "FlutterProgramController.h"

@interface FPAppController ()

@end

@implementation FPAppController

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
            BOOL opened = [self openProgram:arguments];
            return result(@(opened));
        }
        else {
            return result(@(false));
        }
    }];
    
    [[MiddlemanPlugin shared] setMethodCallHandler:@"getAppSpec" handler:^(id arguments, FlutterResult result) {
        NSData *specData = [NSData dataWithContentsOfFile:self.appBunndle.specFilePath];
        NSString *specString = [[NSString alloc] initWithData:specData encoding:NSUTF8StringEncoding];
        return result(specString);
    }];
}

- (BOOL)openProgram:(NSDictionary *)specJson {
    
    FPSpec *spec = [FPSpec new];
    [spec setValuesForKeysWithDictionary:specJson];
    NSString *assertFilePath = [FPPath programLaunchAssertFilePathWithSpec:spec];
    NSString *LaunchPath = [FPPath programLaunchPathWithSpec:spec];
    if (![SSZipArchive unzipFileAtPath:assertFilePath toDestination:LaunchPath]) {
        return false;
    }
    NSString *LaunchAssertPath = [FPPath programLaunchAssertPathWithSpec:spec];
    FlutterDartProject *dartPro = [[FlutterDartProject alloc] initWithFlutterAssetsURL:[NSURL fileURLWithPath:LaunchAssertPath]];
    FlutterProgramController *vc = [[FlutterProgramController alloc] initWithProject:dartPro nibName:nil bundle:nil];
    
    [GeneratedPluginRegistrant registerWithRegistry:vc.pluginRegistry];
    [self presentViewController:vc animated:true completion:nil];
    
    return true;
}

@end
