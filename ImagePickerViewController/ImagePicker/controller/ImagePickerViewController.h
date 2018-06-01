//
//  ImagePickerViewController.h
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoCell.h"

@class ImagePickerViewController;
@protocol ImagePickerViewControllerDelegate<NSObject>
- (void)imagePickerViewController:(ImagePickerViewController *)imagePickerViewController didFinished:(NSArray<UIImage *> *)photos;
@end

@interface ImagePickerViewController : UIViewController

@property (nonatomic, assign) NSInteger maxSelectedPhotoCount;
@property (nonatomic, strong) NSMutableArray<PhotoItem *> *selectedPhotoItems;
@property (nonatomic, strong) PhotoAlbum *photoAlbum;
@property (nonatomic, weak) id<ImagePickerViewControllerDelegate> delegate;
@end
