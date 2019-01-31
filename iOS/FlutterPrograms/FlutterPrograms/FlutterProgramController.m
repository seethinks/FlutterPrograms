//
//  FlutterProgramController.m
//  FlutterHotUpdataMain
//
//  Created by GuHaijun on 2019/1/25.
//  Copyright © 2019 GuHaijun. All rights reserved.
//

#import "FlutterProgramController.h"
#import "NSLayoutConstraint+NNVisualFormat.h"

@interface FlutterProgramController ()

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation FlutterProgramController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.closeButton];
    
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    NSArray<NSLayoutConstraint *> *constraints =
    [NSLayoutConstraint nn_constraintsWithVisualFormats: @[@{
                                                               @"format" : @"H:[closeButton(==42)]-25-|",
                                                            },
                                                           @{
                                                               @"format" :  @"V:|-topEdge-[closeButton(==32)]",
                                                               @"metrics" : @{ @"topEdge" : @(statusBarHeight + 5)}
                                                            }
                                                           ]
                                                  views: @{
                                                           @"closeButton" : self.closeButton
                                                           }
     ];
    [NSLayoutConstraint activateConstraints:constraints];
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        [_closeButton setTitle:@"ㄨ" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _closeButton.layer.cornerRadius = 16;
        _closeButton.layer.borderColor = _closeButton.titleLabel.textColor.CGColor;
        _closeButton.layer.borderWidth = 0.5;
        _closeButton.layer.masksToBounds = true;
        _closeButton.translatesAutoresizingMaskIntoConstraints = false;
        [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (void)closeAction {
    if (self.navigationController) {
        [self.navigationController popToViewController:self animated:true];
    }
    else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
