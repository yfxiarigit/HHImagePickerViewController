//
//  ImageCropBottomBar.m
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/8.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "ImageCropBottomBar.h"

@interface ImageCropBottomBar()
@property (nonatomic, strong) UIButton *finishButton;
@end

@implementation ImageCropBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self addSubview:self.finishButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.finishButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 70, 0.5 * (44 - 35), 55, 35);
}

- (void)clickFinishButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropBottomBarDidClickFinishButton:)]) {
        [self.delegate imageCropBottomBarDidClickFinishButton:self];
    }
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] init];
        _finishButton.backgroundColor = [UIColor blueColor];
        _finishButton.layer.cornerRadius = 3;
        _finishButton.clipsToBounds = YES;
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton addTarget:self action:@selector(clickFinishButton) forControlEvents:UIControlEventTouchDown];
    }
    return _finishButton;
}

@end
