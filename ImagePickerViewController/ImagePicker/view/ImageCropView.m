//
//  ImageCropView.m
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/7.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "ImageCropView.h"

@interface ImageCropView()
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, assign) ImageCropStyle style;
@end

@implementation ImageCropView

- (instancetype)initWithCropRect:(CGRect)cropRect cropStyle:(ImageCropStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.style = style;
        self.cropRect = cropRect;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (self.style == ImageCropStyleCircle) {
        [self transparentCutRoundArea];
    }else {
        [self transparentCutSquareArea];
    }
}

//矩形裁剪区域
- (void)transparentCutSquareArea{
    //半透明背景
    UIBezierPath *alphaPath = [UIBezierPath bezierPathWithRect:self.bounds];
    
    //矩形透明区域
    UIBezierPath *squarePath = [UIBezierPath bezierPathWithRect:self.cropRect];
    [alphaPath appendPath:squarePath];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = alphaPath.CGPath;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    self.layer.mask = shapeLayer;
    
    //裁剪框
    UIBezierPath *cropPath = [UIBezierPath bezierPathWithRect:self.cropRect];
    CAShapeLayer *cropLayer = [CAShapeLayer layer];
    cropLayer.path = cropPath.CGPath;
    cropLayer.fillColor = [UIColor whiteColor].CGColor;
    cropLayer.strokeColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:cropLayer];
}

//圆形裁剪区域
-(void)transparentCutRoundArea{
    CGFloat arcX = self.cropRect.origin.x + self.cropRect.size.width * 0.5;
    CGFloat arcY = self.cropRect.origin.y +  self.cropRect.size.height * 0.5;
    CGFloat arcRadius;
    if (self.cropRect.size.height > self.cropRect.size.width) {
        arcRadius = self.cropRect.size.width * 0.5;
    }else{
        arcRadius  = self.cropRect.size.height * 0.5;
    }
    
    //圆形透明区域
    UIBezierPath *alphaPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(arcX, arcY) radius:arcRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    [alphaPath appendPath:arcPath];
    CAShapeLayer  *layer = [CAShapeLayer layer];
    layer.path = alphaPath.CGPath;
    layer.fillRule = kCAFillRuleEvenOdd;
    self.layer.mask = layer;
    
    //裁剪框
    UIBezierPath *cropPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(arcX, arcY) radius:arcRadius+1 startAngle:0 endAngle:2*M_PI clockwise:NO];
    CAShapeLayer *cropLayer = [CAShapeLayer layer];
    cropLayer.path = cropPath.CGPath;
    cropLayer.strokeColor = [UIColor whiteColor].CGColor;
    cropLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.layer addSublayer:cropLayer];
}

@end
