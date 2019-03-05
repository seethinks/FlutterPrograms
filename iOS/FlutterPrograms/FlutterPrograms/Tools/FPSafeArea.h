//
//  FPSafeArea.h
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/3/6.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#ifndef FPSafeArea_h
#define FPSafeArea_h

#import <Foundation/Foundation.h>

#define iPhone4         (CGSizeEqualToSize(CGSizeMake(640, 960),    [[UIScreen mainScreen] currentMode].size))
#define iPhone5         (CGSizeEqualToSize(CGSizeMake(640, 1136),   [[UIScreen mainScreen] currentMode].size))
#define iPhone6         (CGSizeEqualToSize(CGSizeMake(750, 1334),   [[UIScreen mainScreen] currentMode].size))
#define iPhone6Plus     (CGSizeEqualToSize(CGSizeMake(1242, 2208),  [[UIScreen mainScreen] currentMode].size))
#define iPhone7         (CGSizeEqualToSize(CGSizeMake(750, 1334),   [[UIScreen mainScreen] currentMode].size))
#define iPhone7Plus     (CGSizeEqualToSize(CGSizeMake(1242, 2208),  [[UIScreen mainScreen] currentMode].size))
#define iPhone8         (CGSizeEqualToSize(CGSizeMake(750, 1334),   [[UIScreen mainScreen] currentMode].size))
#define iPhone8Plus     (CGSizeEqualToSize(CGSizeMake(1242, 2208),  [[UIScreen mainScreen] currentMode].size))
#define iPhoneX         (CGSizeEqualToSize(CGSizeMake(1125, 2436),  [[UIScreen mainScreen] currentMode].size))
#define iPhoneXr        (CGSizeEqualToSize(CGSizeMake(828, 1792),   [[UIScreen mainScreen] currentMode].size))
#define iPhoneXs        (CGSizeEqualToSize(CGSizeMake(1125, 2436),  [[UIScreen mainScreen] currentMode].size))
#define iPhoneXsMax     (CGSizeEqualToSize(CGSizeMake(1242, 2688),  [[UIScreen mainScreen] currentMode].size))
#define iPhoneX_        (iPhoneX || iPhoneXr || iPhoneXs || iPhoneXsMax)


static inline CGFloat fp_safeAreaTopMargin() {
    if (iPhoneX_) {
        return 44 + 44;
    }
    else {
        return 22 + 44;
    }
}

static inline CGFloat fp_safeAreaBottomMargin() {
    if (iPhoneX_) {
        return 49 + 34;
    }
    else {
        return 49;
    }
}


#endif /* FPSafeArea_h */
