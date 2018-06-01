//
//  PhotoCell.m
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell()
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *content;
//选中时的遮罩
@property (nonatomic, strong) UIButton *coverView;
@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoView];
        [self.contentView addSubview:self.coverView];
    }
    return self;
}

- (void)setPhotoItem:(PhotoItem *)photoItem {
    _photoItem = photoItem;
    self.coverView.selected = photoItem.selected;
    [self seletedPhoto:photoItem.selected];
    [photoItem getThumbImageWithSize:CGSizeMake(self.bounds.size.width * [UIScreen mainScreen].scale, self.bounds.size.height * [UIScreen mainScreen].scale) resultHandler:^(UIImage *image, NSDictionary *info) {
        _photoView.image = image;
    }];
}

#pragma mark - event

#pragma mark - getter

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        _photoView.frame = self.bounds;
    }
    return _photoView;
}

- (UIButton *)coverView {
    if (!_coverView) {
        _coverView = [[UIButton alloc] init];
        _coverView.frame = self.bounds;
        _coverView.enabled = NO;
    }
    return _coverView;
}

#pragma mark - other
- (void)seletedPhoto:(BOOL)selected {
    _photoItem.selected = selected;
    if (selected) {
        [UIView animateWithDuration:0.2 animations:^{
            _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        }];
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        }];
    }
}

@end
