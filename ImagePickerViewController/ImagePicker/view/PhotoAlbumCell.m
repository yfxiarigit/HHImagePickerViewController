//
//  PhotoAlbumCell.m
//  Cell
//
//  Created by yfxiari on 2018/6/1.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "PhotoAlbumCell.h"
#import "PhotoAlbum.h"
#import "PhotoHelper.h"

@interface PhotoAlbumCell()
@property (nonatomic, strong) UIImageView *albumPosterView;
@property (nonatomic, strong) UILabel *albumNameLabel;
@property (nonatomic, strong) NSString *localIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;
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
    self.localIdentifier = photoAlbum.phCollection.localIdentifier;
    [PhotoHelper cancelImageRequest:self.imageRequestID];
    
    _albumPosterView.image = nil;
    if (photoAlbum.posterImage) {
        _albumPosterView.image = photoAlbum.posterImage;
    }else {
        int32_t imageRequetID = [PhotoHelper requestAlbumPosterWithAlbum:photoAlbum imageWithSize:CGSizeMake(58, 58) resultHandler:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if ([photoAlbum.phCollection.localIdentifier isEqualToString:photoAlbum.phCollection.localIdentifier]) {
                _albumPosterView.image = photo;
                photoAlbum.posterImage = photo;
            }
        }];
        self.imageRequestID = imageRequetID;
    }
    _albumNameLabel.text = [NSString stringWithFormat:@"%@(%zd)",photoAlbum.albumName, photoAlbum.photoCount];
}

@end
