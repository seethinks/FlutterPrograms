//
//  FPUpdateAssertController.m
//  FlutterPrograms
//
//  Created by GuHaijun on 2019/2/24.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FPUpdateAssertController.h"

@interface FPUpdateAssertController ()

@property (nonatomic, strong) FPAssert *assert;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation FPUpdateAssertController

- (instancetype)initWithAssert:(FPAssert *)assert {
    self = [super init];
    if (self) {
        self.assert = assert;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self fetchUpdateAssert];
}

- (void)setupSubviews {
    [self.view addSubview: self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

- (void)fetchUpdateAssert {
    [SVProgressHUD show];
//    [[FPAssertManager shared] fetchApplicationAssert:self.assert progress:^(NSProgress * _Nonnull downloadProgress) {
//        [SVProgressHUD showProgress:downloadProgress.fractionCompleted];
//    } completionHandler:^(BOOL isSuccess) {
//        [SVProgressHUD dismiss];
//    }];
}

lazygetter(UIView, contentView)

@end
