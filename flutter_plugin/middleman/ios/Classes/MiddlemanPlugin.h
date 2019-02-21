#import <Flutter/Flutter.h>

typedef void (^MiddlemanCallHandler)(id arguments, FlutterResult result);

@interface MiddlemanPlugin : NSObject<FlutterPlugin>

@property (nonatomic, readonly) FlutterMethodChannel *channel;

+ (instancetype)shared;

- (void)setMethodCallHandler:(NSString *)method
                     handler:(MiddlemanCallHandler)handler;
- (void)invokeMethod:(NSString*)method arguments:(id)arguments;
- (void)invokeMethod:(NSString*)method
           arguments:(id)arguments
              result:(FlutterResult)callback;

@end
