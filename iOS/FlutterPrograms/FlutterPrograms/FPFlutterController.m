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

- (instancetype)initWithFlutterAssertPath:(NSString*)flutterAssertPath
                                  nibName:(NSString*)nibNameOrNil
                                   bundle:(NSBundle*)nibBundleOrNil {
#if HOT_UPDATE
    FlutterDartProject *dartPro = [[FlutterDartProject alloc] initWithFlutterAssetsURL:[NSURL fileURLWithPath:flutterAssertPath]];
    FPFlutterController *vc = [super initWithProject:dartPro nibName:nibNameOrNil bundle:nibBundleOrNil];
    self = vc;
#else
    FlutterEngine *engine = [[FlutterEngine alloc] initWithName:@"io.flutter" project:nil];
    [engine runWithEntrypoint:nil];
    FPFlutterController *vc = [super initWithEngine:engine nibName:nil bundle:nil];
    self = vc;
#endif
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
