//
//  ImagePreviewCell.m
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/5.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "ImagePreviewCell.h"
#import "CircleProgressView.h"
#import "PhotoHelper.h"
#import "PhotoItem.h"

@interface ImagePreviewCell()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CircleProgressView *circleProgressView;
@end

@implementation ImagePreviewCell {
    UITapGestureRecognizer *_tapGesture;
    UITapGestureRecognizer *_doubleTapGesture;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        [self.contentView addSubview:self.circleProgressView];
        [_tapGesture requireGestureRecognizerToFail:_doubleTapGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
}

#pragma mark - event
- (void)dismiss {
    if (_delegate && [_delegate respondsToSelector:@selector(dismissPreViewController)]) {
        [_delegate dismissPreViewController];
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tapGesture {
    
    if (_scrollView.zoomScale > 1) {
        [_scrollView setZoomScale:1 animated:YES];
    } else {
        CGPoint touchPoint = [tapGesture locationInView:_imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    
}

#pragma mark scrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 让_imageView永远保持在中间
    UIView *subView = _imageView;

    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;

    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;

    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    if (scrollView.contentSize.height > self.bounds.size.height) {
        scrollView.alwaysBounceVertical = YES;
    }else {
        scrollView.alwaysBounceVertical = NO;
    }
}

#pragma mark - getter

- (void)setItem:(PhotoItem *)item {
    _item = item;
    [PhotoHelper cancelImageRequest:self.imageRequestID];
    
    self.imageView.image = nil;
    if (item.previewImage) {
        self.imageView.image = item.previewImage;
        self.item.previewImage = item.previewImage;
    }else {
        int32_t imageRequestID = [PhotoHelper requestPreviewPhotoWithAsset:item.phAsset resultHandler:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (self.item == item) {
                self.item.previewImage = photo;
                [self calculateFrameWithImageView:self.imageView image:photo];
                self.imageView.image = photo;
                //需要自己计算contentSize，因为scrollView根据内容自适应contentSize不准确
                self.scrollView.contentSize = CGSizeMake(self.imageView.bounds.size.width, self.imageView.bounds.size.height);
                self.circleProgressView.hidden = YES;
            }
        } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            if (progress >= 1) {
                self.circleProgressView.hidden = YES;
                self.circleProgressView.percent = 0;
            }else {
                self.circleProgressView.percent = progress;
                self.circleProgressView.hidden = NO;
            }
        } networkAccessAllowed:YES];
        self.imageRequestID = imageRequestID;
    }
    self.scrollView.zoomScale = 1;
}

///设置图片的位置和大小
- (BOOL)calculateFrameWithImageView:(UIImageView *)imageView image:(UIImage *)showImage {
    if (!showImage) {
        return false;
    }
    CGFloat LongPhotoRatio = 2;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //  计算最合适的图片比例
    CGFloat screenRatio = screenSize.width / screenSize.height;
    CGFloat imageRatio = showImage.size.width / showImage.size.height;
    
    CGSize totalImageSize = CGSizeZero;
    
    //  默认记录 正常图片
    BOOL _isLongPhoto = false;
    if (imageRatio > screenRatio) {
        //  比屏幕宽
        totalImageSize = CGSizeMake(screenSize.width, screenSize.width / imageRatio);
        
    } else {
        //  比屏幕窄
        totalImageSize = CGSizeMake(screenSize.height * imageRatio, screenSize.height);
        
        //  判断是否为 高度很高的图
        if (imageRatio < 1 / LongPhotoRatio) {
            totalImageSize = CGSizeMake(screenSize.width, screenSize.width / imageRatio);
            _isLongPhoto = true;
        }
    }
    
    imageView.frame = CGRectMake(0, 0, totalImageSize.width, totalImageSize.height);
    if (_isLongPhoto) {
        imageView.center = CGPointMake(totalImageSize.width / 2, totalImageSize.height / 2);
    } else {
        imageView.center = CGPointMake(screenSize.width / 2, screenSize.height / 2);
    }
    return _isLongPhoto;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.bouncesZoom = YES;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1;
        _scrollView.clipsToBounds = YES;
        _scrollView.frame = self.bounds;
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        _tapGesture.delegate = self;
        [_scrollView addGestureRecognizer:_tapGesture];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.userInteractionEnabled = YES;
        
        _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        _doubleTapGesture.delegate = self;
        _doubleTapGesture.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:_doubleTapGesture];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = .5;
        longPress.delegate = self;
        [_imageView addGestureRecognizer:longPress];
    }
    return _imageView;
}

- (CircleProgressView *)circleProgressView {
    if (!_circleProgressView) {
        _circleProgressView = [[CircleProgressView alloc] init];
        _circleProgressView.type = CircleProgressViewTypeFill;
        _circleProgressView.progressBackgroundColor = [UIColor whiteColor];
        CGFloat w = 35;
        CGFloat h = 35;
        CGFloat x = self.frame.size.width * 0.5 - w * 0.5;
        CGFloat y = self.frame.size.height * 0.5 - w * 0.5;
        _circleProgressView.frame = CGRectMake(x, y, w, h);
        _circleProgressView.hidden = YES;
    }
    return _circleProgressView;
}

@end
