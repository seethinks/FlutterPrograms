//
//  FPAppController.h
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/26.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPFlutterController.h"

@interface FPAppController : FPFlutterController

@property (nonatomic, strong) FPAppBundle *appBunndle;

- (instancetype)initWithAppBundle:(FPAppBundle *)appBundle nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
