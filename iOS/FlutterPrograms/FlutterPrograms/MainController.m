//
//  MainController.m
//  Runner
//
//  Created by GuHaijun on 2019/1/17.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "MainController.h"
#import <Flutter/Flutter.h>
#import "FlutterProgramController.h"

@interface MainController ()

@end

@implementation MainController



- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
}

- (IBAction)FlutterPlusPlus:(id)sender {
    //    NSString *urlPath = @"https://www.baidu.com/img/baidu_jgylogo3.gif";
    NSString *urlPath = @"https://raw.githubusercontent.com/FlutterPrograms/InitPrograms/master/FlutterPlusPlus/flutter_assets.zip";
    NSString *folder = @"FlutterPlusPlus";
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *zipPath = [docPath stringByAppendingPathComponent:folder];
    zipPath = [zipPath stringByAppendingPathComponent:@"flutter_assets.zip"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:zipPath]) {
        
        if ([SSZipArchive unzipFileAtPath:zipPath toDestination:docPath]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"解压成功"];
                [self flutter:nil];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"解压失败"];
                [self downLoadWithPath:urlPath localFolder: folder];
            });
        }
        
    }
    else {
        [self downLoadWithPath:urlPath localFolder: folder];
    }
    
}

- (IBAction)filter_menu:(id)sender {
    NSString *urlPath = @"https://raw.githubusercontent.com/FlutterPrograms/InitPrograms/master/flutter_ui_challenge_filter_menu/flutter_assets.zip";
    NSString *folder = @"flutter_ui_challenge_filter_menu";
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *zipPath = [docPath stringByAppendingPathComponent:folder];
    zipPath = [zipPath stringByAppendingPathComponent:@"flutter_assets.zip"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:zipPath]) {
        
        if ([SSZipArchive unzipFileAtPath:zipPath toDestination:docPath]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"解压成功"];
                [self flutter:nil];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"解压失败"];
                [self downLoadWithPath:urlPath localFolder: folder];
            });
        }
        
    }
    else {
        [self downLoadWithPath:urlPath localFolder: folder];
    }
}

- (IBAction)HistoryOfEverything:(id)sender {
    NSString *urlPath = @"https://raw.githubusercontent.com/FlutterPrograms/InitPrograms/master/HistoryOfEverything/flutter_assets.zip";
    NSString *folder = @"HistoryOfEverything";
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *zipPath = [docPath stringByAppendingPathComponent:folder];
    zipPath = [zipPath stringByAppendingPathComponent:@"flutter_assets.zip"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:zipPath]) {
        
        if ([SSZipArchive unzipFileAtPath:zipPath toDestination:docPath]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"解压成功"];
                [self flutter:nil];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"解压失败"];
                [self downLoadWithPath:urlPath localFolder: folder];
            });
        }
        
    }
    else {
        [self downLoadWithPath:urlPath localFolder: folder];
    }
}


- (void)downLoadWithPath:(NSString *)path localFolder:(NSString *)localPath {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [SVProgressHUD show];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat process = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%.2f", process]];
            NSLog(@"%@", [NSString stringWithFormat:@"%.2f", process]);
        });
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *zipDir = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        zipDir = [zipDir URLByAppendingPathComponent:localPath];
        [[NSFileManager defaultManager] createDirectoryAtPath:zipDir.path withIntermediateDirectories:YES attributes:nil error:nil];
        return [zipDir URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        NSString *docPath = NSHomeDirectory();
        docPath = [docPath stringByAppendingPathComponent:@"Documents"];
        NSString *zipPath = [docPath stringByAppendingPathComponent:localPath];
        zipPath = [zipPath stringByAppendingPathComponent:@"flutter_assets.zip"];
        if ([SSZipArchive unzipFileAtPath:zipPath toDestination:docPath]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"解压成功"];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:@"解压失败"];
            });
        }
        [SVProgressHUD dismiss];
    }];
    
    [downloadTask resume];
}

- (IBAction)flutter:(id)sender {
//    NSString *assets = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/flutter_assets"];
//    NSLog(@"assets:%@", assets);
//    NSURL *assetsURL = [NSURL fileURLWithPath:assets];
////    FlutterDartProject *dartPro = [[FlutterDartProject alloc] initWithFlutterAssetsURL:assetsURL];
//    FlutterProgramController *vc = [[FlutterProgramController alloc] initWithProject:dartPro nibName:nil bundle:nil];
//    [self presentViewController:vc animated:true completion:nil];
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
