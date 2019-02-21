#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <middleman/MiddlemanPlugin.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    [[MiddlemanPlugin shared] setMethodCallHandler:@"platformVersion" handler:^(id arguments, FlutterResult result) {
        result(@"1.0.0");
    }];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
