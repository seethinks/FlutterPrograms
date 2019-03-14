//
//  FPMiddlemanResult.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/3/14.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPMiddlemanResult.h"

@implementation FPMiddlemanResult

- (NSDictionary *)dict {
    NSString *code = (self.code == nil) ? @"" : self.code;
    NSString *message = (self.message == nil) ? @"" : self.message;
    NSDictionary *data = (self.data == nil) ? @{} : self.data;
    
    return @{
             @"code" : code,
             @"message" : message,
             @"data" : data,
             };
}

@end
