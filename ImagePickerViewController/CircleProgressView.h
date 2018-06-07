//
//  CircleProgressView.h
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/7.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CircleProgressViewType) {
    ///空心圆环
    CircleProgressViewTypeStroke,
    ///实心圆
    CircleProgressViewTypeFill,
};

@interface CircleProgressView : UIView

///进度条颜色
@property (nonatomic, strong) UIColor *progressColor;
///背景圆环的颜色,默认lighGrayColor
@property (nonatomic, strong) UIColor *progressBackgroundColor;
///圆环的颜色
@property (nonatomic, assign) CGFloat lineWidth;
///实心圆进度条和背景圆环的间隙
@property (nonatomic, assign) CGFloat padding;
///进度
@property (nonatomic, assign) CGFloat percent;
///默认圆环
@property (nonatomic, assign) CircleProgressViewType type;

@end
