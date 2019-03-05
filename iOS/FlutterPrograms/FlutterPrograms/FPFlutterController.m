//
//  FPFlutterController.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/26.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPFlutterController.h"

@interface FPFlutterController ()

@end

@implementation FPFlutterController

- (instancetype)initWithAppBundle:(FPAppBundle *)appBundle nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    FlutterDartProject *dartPro = [[FlutterDartProject alloc] initWithFlutterAssetsURL:[NSURL fileURLWithPath:appBundle.launchAssertPath]];
    self = [super initWithProject:dartPro nibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _appBunndle = appBundle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
