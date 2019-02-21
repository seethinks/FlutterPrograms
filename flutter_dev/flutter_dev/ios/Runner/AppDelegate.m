#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <middleman/MiddlemanPlugin.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    __weak typeof(self) weakSelf = self;
    [[MiddlemanPlugin shared] setMethodCallHandler:@"openProgram" handler:^(id arguments, FlutterResult result) {
        NSLog(@"Native iOS %@:%@",NSStringFromClass([weakSelf class]), arguments);
        return result(@"Open program successful!!!");
    }];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
