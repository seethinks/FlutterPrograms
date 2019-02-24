//
//  FPSpec.h
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/23.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FPSpec : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *descript;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) id images;
@property (nonatomic, strong) NSString *flutterAssertUrl;
@property (nonatomic, strong) NSString *github;
@property (nonatomic, strong) NSString *feature;
@property (nonatomic, strong) NSString *versionRecord;
@property (nonatomic, strong) NSString *flutterVersion;

+ (instancetype)specWithPath:(NSString *)path;
- (instancetype)initWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
