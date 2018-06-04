//
//  ImagePickerBottomBar.m
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "ImagePickerBottomBar.h"

@interface ImagePickerBottomBar()
@property (nonatomic, strong) UIButton *originalButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIView *line;
@end

@implementation ImagePickerBottomBar {
    BOOL _isSelectedOriginal;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        [self addSubview:self.originalButton];
        [self addSubview:self.sureButton];
        [self addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.sureButton.frame = CGRectMake(self.frame.size.width - 75, 0.5 * (self.frame.size.height - 30), 60, 30);
    self.line.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    self.originalButton.frame = CGRectMake(5, 0, 80, self.frame.size.height);
}

#pragma mark - event

- (void)clickSureButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerBottomBarDidClickSureButton)]) {
        [self.delegate imagePickerBottomBarDidClickSureButton];
    }
}

- (void)clickOriginalButton {
    _isSelectedOriginal = !_isSelectedOriginal;
    _originalButton.selected = _isSelectedOriginal;
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerBottomBar:didClickOriginalButton:)]) {
        [self.delegate imagePickerBottomBar:self didClickOriginalButton:_isSelectedOriginal];
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

- (UIButton *)originalButton {
    if (!_originalButton) {
        _originalButton = [[UIButton alloc] init];
        [_originalButton setImage:[UIImage imageNamed:@"photoUnselected"] forState:UIControlStateNormal];
        [_originalButton setImage:[UIImage imageNamed:@"photoSelected"] forState:UIControlStateSelected];
        
        [_originalButton setTitle:@"原图" forState:UIControlStateNormal];
        [_originalButton setTitle:@"原图" forState:UIControlStateSelected];
        [_originalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _originalButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_originalButton addTarget:self action:@selector(clickOriginalButton) forControlEvents:UIControlEventTouchDown];
    }
    return _originalButton;
}

@end
