//
//  ImageCropBottomBar.h
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/8.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageCropBottomBar;
@protocol ImageCropBottomBarDelegate<NSObject>
- (void)imageCropBottomBarDidClickFinishButton:(ImageCropBottomBar *)imageCropBottomBar;
@end

@interface ImageCropBottomBar : UIView

@property (nonatomic, weak) id<ImageCropBottomBarDelegate> delegate;

@end
