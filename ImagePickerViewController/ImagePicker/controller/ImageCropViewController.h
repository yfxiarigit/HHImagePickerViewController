//
//  ImageCropViewController.h
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/7.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCropHeader.h"

@protocol ImageCropViewControllerDelegate<NSObject>
- (void)imageCropViewControllerDidCancel;
- (void)imageCropViewControllerDidFinishCrop:(UIImage *)cropImage;
@end

@interface ImageCropViewController : UIViewController
@property (nonatomic, weak) id<ImageCropViewControllerDelegate> delegate;


- (instancetype)initWithImage:(UIImage *)image cropRect:(CGRect)cropRect imageCropStyle:(NSInteger)imageCropStyle;

-(instancetype) init NS_UNAVAILABLE;
+(instancetype) new NS_UNAVAILABLE;
@end
