//
//  ImagePickerViewController.h
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ImageCropHeader.h"

@class ImagePickerViewController, PhotoAlbum, PhotoItem;
@protocol ImagePickerViewControllerDelegate<NSObject>

@optional
///选中回调
- (void)imagePickerViewController:(ImagePickerViewController *)imagePickerViewController didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray<PhotoItem *> *)sourceAssets isSelectedOriginalImage:(BOOL)isSelectedOriginalImage;

///取消选择
- (void)imagePickerViewControllerDidCanceled:(ImagePickerViewController *)imagePickerViewController;
@end

@interface ImagePickerViewController : UIViewController

- (instancetype)initWithStyle:(ImagePickerStyle)style;

@property (nonatomic, strong) PhotoAlbum *photoAlbum;

/// 最大允许选中的照片数量,默认是3
@property (nonatomic, assign) NSInteger maxAllowSelectedPhotoCount;

@property (nonatomic, weak) id<ImagePickerViewControllerDelegate> delegate;

/// 允许预览
@property (nonatomic, assign, getter=isAllowPreview) BOOL allowPreview;

/// 默认为NO;
@property (nonatomic, assign, getter=isAllowSelectedOriginalImage) BOOL allowSelectedOriginalImage;

/// 裁剪回调
@property (nonatomic, copy) void(^finishCropBlock)(UIImage *image);

/// 允许拍摄,暂未做
@property (nonatomic, assign) BOOL allowTakePicture;

@end
