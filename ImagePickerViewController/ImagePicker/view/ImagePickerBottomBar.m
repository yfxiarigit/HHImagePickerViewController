//
//  ImagePickerBottomBar.m
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "ImagePickerBottomBar.h"

@interface ImagePickerBottomBar()
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView *line;
@end

@implementation ImagePickerBottomBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        [self addSubview:self.sureButton];
        [self addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.sureButton.frame = CGRectMake(self.frame.size.width - 75, 0.5 * (self.frame.size.height - 30), 60, 30);
    self.line.frame = CGRectMake(0, 0, self.frame.size.width, 1);
}

#pragma mark - event

- (void)clickSureButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerBottomBarDidClickSureButton)]) {
        [self.delegate imagePickerBottomBarDidClickSureButton];
    }
}

#pragma mark - getter

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor blackColor];
    }
    return _line;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = 3;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.borderColor = [UIColor blackColor].CGColor;
        _sureButton.layer.borderWidth = 1;
        [_sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchDown];
    }
    return _sureButton;
}

@end
