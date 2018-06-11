//
//  ADUploadLoadingView.h
//  Adore
//
//  Created by Gozap-ios on 17/3/8.
//  Copyright © 2017年 Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADUploadLoadingView : UIView
{
    CAShapeLayer *_cycleLayer;
    UIView *_backgroundView;// 遮层
    UIView *_imageBlock;    // 方块
    UIImageView *_imageView;// 图片
}

+ (void)show;
+ (void)hide;

@end
