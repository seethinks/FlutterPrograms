//
//  FPFlutterController.h
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/26.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import <Flutter/Flutter.h>

typedef void(^FPVoidCallback)(NSString *state, NSString *message, NSDictionary *info);

@interface FPFlutterController : FlutterViewController

@property (nonatomic, strong) FPAppBundle *appBunndle;
@property (nonatomic, strong) FPVoidCallback callback;

- (instancetype)initWithAppBundle:(FPAppBundle *)appBundle nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
