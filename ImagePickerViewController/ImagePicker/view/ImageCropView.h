//
//  ImageCropView.h
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/7.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCropHeader.h"

@interface ImageCropView : UIView

/**
 裁剪view

 @param cropRect 裁剪区域，注意圆形时width 要和 height 相等
 @param style 圆形还是矩形
 @return 实例对象
 */
- (instancetype)initWithCropRect:(CGRect)cropRect cropStyle:(ImageCropStyle)style;

#pragma mark - 禁用
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
-(instancetype) init NS_UNAVAILABLE;
+(instancetype) new NS_UNAVAILABLE;
@end
