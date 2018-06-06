//
//  ImagePickerViewController.h
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImagePickerViewController, PhotoAlbum, PhotoItem;
@protocol ImagePickerViewControllerDelegate<NSObject>

///选中回调
- (void)imagePickerViewController:(ImagePickerViewController *)imagePickerViewController didFinished:(NSArray<PhotoItem *> *)photos isSelectedOriginalImage:(BOOL)isSelectedOriginalImage;

///取消选择
- (void)imagePickerViewControllerDidCanceled:(ImagePickerViewController *)imagePickerViewController;
@end

@interface ImagePickerViewController : UIViewController

@property (nonatomic, strong) PhotoAlbum *photoAlbum;

/// 最大允许选中的照片数量,默认是1
@property (nonatomic, assign) NSInteger maxAllowSelectedPhotoCount;

/// 默认选中的照片
@property (nonatomic, strong) NSMutableArray<PhotoItem *> *selectedPhotoItems;

@property (nonatomic, weak) id<ImagePickerViewControllerDelegate> delegate;

/// 默认为NO;
@property (nonatomic, assign, getter=isAllowSelectedOriginalImage) BOOL allowSelectedOriginalImage;

/// 允许拍摄
@property (nonatomic, assign) BOOL allowTakePicture;

@end
