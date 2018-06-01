//
//  ViewController.m
//  3DTouch
//
//  Created by yfxiari on 2018/5/24.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "ViewController.h"
#import "PhotoAlbumsViewController.h"
#import "ImagePickerViewController.h"
#import "PhotoHelper.h"

@interface ViewController ()<ImagePickerViewControllerDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    PhotoAlbumsViewController *vc = [[PhotoAlbumsViewController alloc] init];
    ImagePickerViewController *imagePicker = [[ImagePickerViewController alloc] init];
    imagePicker.delegate = self;
    imagePicker.photoAlbum = [PhotoHelper getTheAllPhotoAlbum];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.viewControllers = @[vc, imagePicker];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)imagePickerViewController:(ImagePickerViewController *)imagePickerViewController didFinished:(NSArray<UIImage *> *)photos {
    NSLog(@"%zd", photos.count);
}



@end
