//
//  PhotoAlbumCell.m
//  Cell
//
//  Created by yfxiari on 2018/6/1.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "PhotoAlbumCell.h"

@interface PhotoAlbumCell()
@property (nonatomic, strong) UIImageView *albumPosterView;
@property (nonatomic, strong) UILabel *albumNameLabel;
@end

@implementation PhotoAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.albumPosterView];
        [self.contentView addSubview:self.albumNameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.albumPosterView.frame = CGRectMake(1, 1, 58, 58);
    self.albumNameLabel.frame = CGRectMake(CGRectGetMaxX(self.albumPosterView.frame) + 15, 0, self.frame.size.width - CGRectGetMaxX(self.albumPosterView.frame) - 30, self.frame.size.height);
}


#pragma mark - getter

- (UILabel *)albumNameLabel {
    if (!_albumNameLabel) {
        _albumNameLabel = [[UILabel alloc] init];
        _albumNameLabel.textColor = [UIColor blackColor];
    }
    return _albumNameLabel;
}

- (UIImageView *)albumPosterView {
    if (!_albumPosterView) {
        _albumPosterView = [[UIImageView alloc] init];
        _albumPosterView.contentMode = UIViewContentModeScaleAspectFill;
        _albumPosterView.clipsToBounds = YES;
    }
    return _albumPosterView;
}

- (void)setPhotoAlbum:(PhotoAlbum *)photoAlbum {
    _photoAlbum = photoAlbum;
    [_photoAlbum getAlbumsPosterImageWithSize:CGSizeMake(58 * [UIScreen mainScreen].scale, 58 * [UIScreen mainScreen].scale) resultHandler:^(UIImage *image, NSDictionary *info) {
        _albumPosterView.image = image;
    }];
    _albumNameLabel.text = [NSString stringWithFormat:@"%@(%zd)",photoAlbum.albumName, photoAlbum.photoCount];
}

@end
