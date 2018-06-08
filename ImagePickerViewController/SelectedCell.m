//
//  SelectedCell.m
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/1.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "SelectedCell.h"

@interface SelectedCell()
@property (nonatomic, strong) UIImageView *photoView;
@end

@implementation SelectedCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.photoView.frame = self.contentView.bounds;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.photoView.image = image;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
    }
    return _photoView;
}

@end
