//
//  SelectedCell.m
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/1.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "SelectedCell.h"
#import "PhotoHelper.h"
#import "PhotoItem.h"

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

- (void)setItem:(PhotoItem *)item {
    _item = item;
    self.photoView.image = item.originalImage;
//    [PhotoHelper requestPhotoWithPHAsset:item.phAsset imageSize:CGSizeMake(100, 100) completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
//        self.photoView.image = photo;
//    } progressHandler:nil networkAccessAllowed:YES];
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
