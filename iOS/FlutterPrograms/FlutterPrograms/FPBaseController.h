//
//  FPBaseController.h
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/24.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FPVoidCallback)(NSUInteger type, NSString *message, NSDictionary *info);

@interface FPBaseController : UIViewController

@property (nonatomic, strong) FPVoidCallback callback;

@end

NS_ASSUME_NONNULL_END
