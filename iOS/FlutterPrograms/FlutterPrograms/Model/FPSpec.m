//
//  FPSpec.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/23.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPSpec.h"

typedef NS_ENUM(NSUInteger, FPSpecType) {
    FPSpecTypeMainBundle,
    FPSpecTypeSandBox,
};

@interface FPSpec()

@end

@implementation FPSpec

+ (instancetype)specWithPath:(NSString *)path {
    FPSpec *spec = [[FPSpec alloc] initWithPath:path];
    return spec;
}

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        @try {
            NSData *specData = [NSData dataWithContentsOfFile:path];
            NSDictionary *specDict = [NSJSONSerialization JSONObjectWithData:specData options:NSJSONReadingMutableContainers error:nil];
            [self setValuesForKeysWithDictionary:specDict];
        } @catch (NSException *exception) {
        } @finally {
        }
    }
    return self;
}

- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    [super setValuesForKeysWithDictionary:keyedValues];
    self.ID = keyedValues[@"id"];
    self.descript = keyedValues[@"description"];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
