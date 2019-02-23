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
        return result(@(true));
    }];
    
    [[MiddlemanPlugin shared] setMethodCallHandler:@"getAppSpec" handler:^(id arguments, FlutterResult result) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"spec.json" ofType:nil];
        NSData *specData = [NSData dataWithContentsOfFile:path];
        NSString *specString = [[NSString alloc] initWithData:specData encoding:NSUTF8StringEncoding];
        return result(specString);
    }];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
