//
//  ImageCropViewController.m
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/7.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "ImageCropViewController.h"
#import "ImageCropView.h"
#import "ImageCropBottomBar.h"

@interface ImageCropViewController()<UIScrollViewDelegate, UIGestureRecognizerDelegate, ImageCropBottomBarDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) ImageCropView *imageCropView;
@property (nonatomic, assign) ImageCropStyle imageCropStyle;
@property (nonatomic, strong) ImageCropBottomBar *bottomBar;
@end

@implementation ImageCropViewController{
    UITapGestureRecognizer *_tapGesture;
}

- (instancetype)initWithImage:(UIImage *)image cropRect:(CGRect)cropRect imageCropStyle:(NSInteger)imageCropStyle {
    self = [super init];
    if (self) {
        self.cropRect = cropRect;
        self.image = image;
        self.imageCropStyle = imageCropStyle;
        [self.view addSubview:self.scrollView];
        [self.view addSubview:self.imageCropView];
        [self.view addSubview:self.bottomBar];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.frame = self.view.bounds;
    self.imageCropView.frame = self.view.bounds;
    if ([UIScreen mainScreen].bounds.size.height == 812) {
        self.bottomBar.frame = CGRectMake(0, self.view.bounds.size.height - 44 - 34, self.view.bounds.size.width, 44 + 34);
    }else {
        self.bottomBar.frame = CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44);
    }
    [self setupImageFrame];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - event

#pragma mark - bottombar delegate

- (void)imageCropBottomBarDidClickFinishButton:(ImageCropBottomBar *)imageCropBottomBar {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageCropViewControllerDidFinishCrop:)]) {
        [self.delegate imageCropViewControllerDidFinishCrop:[self getSubImage]];
    }
}

#pragma mark scrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self updateImageViewFrame];
    [self updateScrollViewInsets];
    [self updateScrollViewContentSize];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    if (scrollView.contentSize.height > self.view.bounds.size.height) {
        scrollView.alwaysBounceVertical = YES;
    }else {
        scrollView.alwaysBounceVertical = NO;
    }
}

#pragma mark --
- (void)updateImageViewFrame {
    // 让_imageView永远保持在中间
    UIView *subView = _imageView;
    
    CGFloat offsetX = (self.scrollView.bounds.size.width > self.scrollView.contentSize.width)?
    (self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (self.scrollView.bounds.size.height > self.scrollView.contentSize.height)?
    (self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX,
                                 self.scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)updateScrollViewContentSize {
    //设置scrollView的contentSize，最小为self.view.frame
    CGSize contentSize = self.scrollView.contentSize;
    if (contentSize.width >= self.view.bounds.size.width  && contentSize.height <= self.view.bounds.size.height) {
        contentSize = CGSizeMake(contentSize.width, self.view.bounds.size.height);
    }else if(contentSize.width <= self.view.bounds.size.width && contentSize.height <= self.view.bounds.size.height){
        contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    }else if(contentSize.width <= self.view.bounds.size.width && contentSize.height >= self.view.bounds.size.height){
        contentSize = CGSizeMake(self.view.bounds.size.width, contentSize.height);
    }
    self.scrollView.contentSize = contentSize;
}

- (void)updateScrollViewInsets {
    
    //设置scrollView的contentInset
    CGFloat imageWidth = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    CGFloat cropWidth = self.cropRect.size.width;
    CGFloat cropHeight = self.cropRect.size.height;

    CGFloat leftRightInset = 0.0,topBottomInset = 0.0;

    //imageview的大小和裁剪框大小的三种情况，保证imageview最多能滑动到裁剪框的边缘
    if (imageWidth<= cropWidth) {
        leftRightInset = 0;
    }else if (imageWidth > cropWidth && imageWidth <= self.view.bounds.size.width){
        leftRightInset =(imageWidth - cropWidth)*0.5;
    }else{
        leftRightInset = (self.view.bounds.size.width - cropWidth)*0.5;
    }

    if (imageHeight <= cropHeight) {
        topBottomInset = 0;
    }else if (imageHeight > cropHeight && imageHeight <= self.view.bounds.size.height){
        topBottomInset = (imageHeight - cropHeight)*0.5;
    }else {
        topBottomInset = (self.view.bounds.size.height- cropHeight)*0.5;
    }
    [self.scrollView setContentInset:UIEdgeInsetsMake(topBottomInset, leftRightInset, topBottomInset, leftRightInset)];
}

#pragma mark - 裁剪图片
-(UIImage *)getSubImage{
    //图片大小和当前imageView的缩放比例
    CGFloat scaleRatio = self.image.size.width/_imageView.frame.size.width ;
    //scrollView的缩放比例，即是ImageView的缩放比例
    CGFloat scrollScale = self.scrollView.zoomScale;
    //裁剪框的 左上、右上和左下三个点在初始ImageView上的坐标位置（注意：转换后的坐标为原始ImageView的坐标计算的，而非缩放后的）
    CGPoint leftTopPoint =  [self.view  convertPoint:self.cropRect.origin toView:_imageView];
    CGPoint rightTopPoint = [self.view convertPoint:CGPointMake(self.cropRect.origin.x + self.cropRect.size.width, self.cropRect.origin.y) toView:_imageView];
    CGPoint leftBottomPoint =[self.view convertPoint:CGPointMake(self.cropRect.origin.x, self.cropRect.origin.y+self.cropRect.size.height) toView:_imageView];
    
    //计算三个点在缩放后imageView上的坐标
    leftTopPoint = CGPointMake(leftTopPoint.x * scrollScale, leftTopPoint.y*scrollScale);
    rightTopPoint = CGPointMake(rightTopPoint.x * scrollScale, rightTopPoint.y*scrollScale);
    leftBottomPoint = CGPointMake(leftBottomPoint.x * scrollScale, leftBottomPoint.y*scrollScale);
    
    //计算图片的宽高
    CGFloat width = (rightTopPoint.x - leftTopPoint.x )* scaleRatio;
    CGFloat height = (leftBottomPoint.y - leftTopPoint.y) *scaleRatio;
    
    //计算裁剪区域在原始图片上的位置
    CGRect myImageRect = CGRectMake(leftTopPoint.x * scaleRatio, leftTopPoint.y*scaleRatio, width, height);
    
    //裁剪图片
    CGImageRef imageRef = self.image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    //是否需要圆形图片
    if (self.imageCropStyle == ImageCropStyleCircle) {
        //将图片裁剪成圆形
        smallImage = [self clipCircularImage:smallImage];
    }
    return smallImage;
}

//将图片裁剪成圆形
-(UIImage *)clipCircularImage:(UIImage *)image{
    CGFloat arcCenterX = image.size.width/ 2;
    CGFloat arcCenterY = image.size.height / 2;
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextAddArc(context, arcCenterX, arcCenterY, image.size.width/2, 0.0, 2*M_PI, NO);
    CGContextClip(context);
    CGRect myRect = CGRectMake(0 , 0, image.size.width ,  image.size.height);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  newImage;
}

#pragma mark - getter

- (void)setupImageFrame {
    if (self.imageView.image == nil) {
        return;
    }
    //  计算最合适的图片比例
    CGSize cropSize = self.cropRect.size;
    CGFloat cropRatio = cropSize.width / cropSize.height;
    CGFloat imageRatio = self.imageView.image.size.width / self.imageView.image.size.height;
    
    CGSize totalImageSize = CGSizeZero;
    
    //比屏幕宽
    if (imageRatio > cropRatio) {
        totalImageSize = CGSizeMake(cropSize.height * imageRatio, cropSize.height);
    } else {
        //  比屏幕窄
        totalImageSize = CGSizeMake(cropSize.width, cropSize.width / imageRatio);
    }
    
    self.imageView.frame = CGRectMake(0, 0, totalImageSize.width, totalImageSize.height);
    self.scrollView.contentSize = totalImageSize;
    [self updateScrollViewInsets];
    [self updateScrollViewContentSize];
    [self updateImageViewFrame];
    
    CGFloat offsetY = self.scrollView.contentSize.height * 0.5 - (self.cropRect.origin.y + self.cropRect.size.height * 0.5);
    [self.scrollView setContentOffset:CGPointMake(0, offsetY) animated:NO];
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
        [_scrollView addSubview:self.imageView];
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
        _imageView.clipsToBounds = YES;
        _imageView.image = self.image;
    }
    return _imageView;
}

- (ImageCropView *)imageCropView {
    if (!_imageCropView) {
        _imageCropView = [[ImageCropView alloc] initWithCropRect:self.cropRect cropStyle:self.imageCropStyle];
    }
    return _imageCropView;
}

- (ImageCropBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[ImageCropBottomBar alloc] init];
        _bottomBar.delegate = self;
    }
    return _bottomBar;
}

@end
