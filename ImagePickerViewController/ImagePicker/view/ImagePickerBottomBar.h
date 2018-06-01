//
//  ImagePickerBottomBar.h
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagePickerBottomBarDelegate<NSObject>
- (void)imagePickerBottomBarDidClickSureButton;
@end

@interface ImagePickerBottomBar : UIView
@property (nonatomic, weak) id<ImagePickerBottomBarDelegate> delegate;
@end
