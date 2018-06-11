//
//  ImagePickerBottomBar.h
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImagePickerBottomBar;
@protocol ImagePickerBottomBarDelegate<NSObject>

///完成
- (void)imagePickerBottomBarDidClickSureButton;

///选择原图
- (void)imagePickerBottomBar:(ImagePickerBottomBar *)bar didClickOriginalButton:(BOOL)isSelected;
- (void)imagePickerBottomBarDidClickPreviewButton;
@end

@interface ImagePickerBottomBar : UIView
@property (nonatomic, weak) id<ImagePickerBottomBarDelegate> delegate;
@property (nonatomic, assign, getter=isShowOriginalButton) BOOL showOriginalButton;
@end
