#import "MiddlemanPlugin.h"

@interface MiddlemanPlugin()
@property (nonatomic, strong) FlutterMethodChannel *_channel;
@property (nonatomic, strong) NSMutableDictionary *handlers;
@end

@implementation MiddlemanPlugin

static MiddlemanPlugin* _instance = nil;

+ (instancetype)shared {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[MiddlemanPlugin alloc] init];
        });
    }
    return _instance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"middleman"
                                     binaryMessenger:[registrar messenger]];
    MiddlemanPlugin* instance = [MiddlemanPlugin shared];
    [registrar addMethodCallDelegate:instance channel:channel];
    instance._channel = channel;
}

- (FlutterMethodChannel *)channel {
    return self._channel;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    MiddlemanCallHandler handler = [self.handlers objectForKey:call.method];
    if (handler) {
        handler(call.arguments, result);
    }
}

- (void)setMethodCallHandler:(NSString *)method handler:(MiddlemanCallHandler)handler {
    if (method == nil || handler == nil) {
        return;
    }
    [self.handlers setObject:handler forKey:method];
}

- (void)invokeMethod:(NSString*)method arguments:(id)arguments {
    [self._channel invokeMethod:method arguments:arguments];
}

- (void)invokeMethod:(NSString*)method
           arguments:(id)arguments
              result:(FlutterResult)callback {
    [self._channel invokeMethod:method arguments:arguments result:callback];
}

- (NSMutableDictionary *)handlers {
    if (!_handlers) {
        _handlers = [NSMutableDictionary new];
    }
    return _handlers;
}

@end

