//
//  PhotoCell.m
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "PhotoCell.h"
#import "PhotoItem.h"
#import "PhotoHelper.h"

@interface PhotoCell()
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *content;
//选中时的遮罩
@property (nonatomic, strong) UIButton *coverView;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) NSString *localIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;
@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.photoView];
        [self.contentView addSubview:self.coverView];
        [self.contentView addSubview:self.selectButton];
    }
    return self;
}

- (void)setPhotoItem:(PhotoItem *)photoItem {
    _photoItem = photoItem;
    [self seletedPhoto:photoItem.selected];
    self.localIdentifier = photoItem.phAsset.localIdentifier;
    [PhotoHelper cancelImageRequest:self.imageRequestID];
    
    if (photoItem.thumbnail) {
        self.photoView.image = photoItem.thumbnail;
    }else {
        int32_t imageRequestID = [PhotoHelper requestPhotoWithPHAsset:photoItem.phAsset imageSize:CGSizeMake(375 / 4.0, 375 / 4.0) completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if ([photoItem.phAsset.localIdentifier isEqualToString:self.localIdentifier]) {
                self.photoView.image = photo;
            }
        } progressHandler:nil networkAccessAllowed:YES];
        self.imageRequestID = imageRequestID;
    }
}

#pragma mark - event
- (void)clickSelectButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self seletedPhoto:sender.selected];
    if (self.didClickSelectButtonBlock) {
        self.didClickSelectButtonBlock(sender.selected);
    }
}

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

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        [_selectButton setImage:[UIImage imageNamed:@"photoUnselected"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"photoSelected"] forState:UIControlStateSelected];
        _selectButton.frame = CGRectMake(self.bounds.size.width - 25 - 5, 5, 25, 25);
        _selectButton.selected = NO;
        [_selectButton addTarget:self action:@selector(clickSelectButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _selectButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - other
- (void)seletedPhoto:(BOOL)selected {
    _photoItem.selected = selected;
    if (selected) {
        [UIView animateWithDuration:0.2 animations:^{
            _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        } completion:^(BOOL finished) {
            _selectButton.selected = YES;
        }];
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        } completion:^(BOOL finished) {
            _selectButton.selected = NO;
        }];
    }
}

@end
