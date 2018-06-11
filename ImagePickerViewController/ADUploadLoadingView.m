//
//  ADUploadLoadingView.m
//  Adore
//
//  Created by Gozap-ios on 17/3/8.
//  Copyright © 2017年 Walsh. All rights reserved.
//
#define Screen_Width            [UIScreen mainScreen].bounds.size.width
#define Screen_Height           [UIScreen mainScreen].bounds.size.height
#define UploadBlockWidth  RealXValue(60)
#define RealXValue(value)        ((value) / 320.0f * Screen_Width)
#define ColorWithHex(hexValue)  [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:1]
#define Application             [UIApplication sharedApplication]
#define MainColor               ColorWithHex(0x394151)
#define GrayColor               ColorWithHex(0x5C5C5C)

#import "ADUploadLoadingView.h"

@implementation ADUploadLoadingView

static id _instace;

+ (instancetype)sharedInstace
{
    if(!_instace)
        _instace = [[self alloc] init];
    
    return _instace;
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backgroundView];
        
        _imageBlock = [UIView new];
        _imageBlock.backgroundColor = ColorWithHex(0xF7F7F7);
        _imageBlock.layer.cornerRadius = 5;
        _imageBlock.layer.shadowColor = GrayColor.CGColor;
        _imageBlock.layer.shadowOffset = CGSizeMake(2, 2);
        _imageBlock.layer.shadowOpacity = .3;
        [self addSubview:_imageBlock];
        
        _imageBlock.frame = CGRectMake(0, 0, UploadBlockWidth, UploadBlockWidth);
        _imageBlock.center = CGPointMake(Screen_Width * 0.5, Screen_Height * 0.5);
        
        _cycleLayer = [CAShapeLayer layer];
        _cycleLayer.lineCap = kCALineCapRound;
        _cycleLayer.lineJoin = kCALineJoinRound;
        _cycleLayer.lineWidth = 3;
        _cycleLayer.fillColor = UIColor.clearColor.CGColor;
        _cycleLayer.strokeColor = MainColor.CGColor;
        _cycleLayer.strokeEnd = 0;
        
        CGFloat cycleWidth = UploadBlockWidth / 2.2 - _cycleLayer.lineWidth;
        CGPoint center = CGPointMake(cycleWidth / 2.0, cycleWidth / 2.0);
        CGFloat radius = (cycleWidth - _cycleLayer.lineWidth) / 2.0;
        CGFloat startAngle = -M_PI_2;
        CGFloat endAngle = 2*M_PI - M_PI_2;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:radius
                                                        startAngle:startAngle
                                                          endAngle:endAngle
                                                         clockwise:YES];
        _cycleLayer.path = path.CGPath;
        _cycleLayer.frame = (CGRect){(UploadBlockWidth - cycleWidth) / 2, (UploadBlockWidth - cycleWidth) / 2, cycleWidth, cycleWidth};
        [_imageBlock.layer addSublayer:_cycleLayer];
        
        CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue = @-1.0;
        strokeStartAnimation.toValue = @1.0;
        
        CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.fromValue = @0.0;
        strokeEndAnimation.toValue = @1.15;
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup new];
        animationGroup.duration = 2;
        animationGroup.repeatCount = MAXFLOAT;
        animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
        // removedOnCompletion设置为NO 后台的时候动画不会消失
        animationGroup.removedOnCompletion = NO;
        [_cycleLayer addAnimation:animationGroup forKey:@"animationGroup"];
        
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotateAnimation.fromValue = @0;
        rotateAnimation.toValue = @(M_PI * 2);
        rotateAnimation.repeatCount = MAXFLOAT;
        rotateAnimation.duration = 1;
        // removedOnCompletion设置为NO 后台的时候动画不会消失
        rotateAnimation.removedOnCompletion = NO;
        [_cycleLayer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
    }
    return self;
}

+ (void)show
{
    id loadingView = [self sharedInstace];
    [Application.windows.firstObject addSubview:loadingView];
//    [loadingView showWithAnimation:.15 completion:nil];
}

+ (void)hide
{
    [[self sharedInstace] hide];
}

- (void)hide
{
    self.alpha = 0;
    [_cycleLayer removeAllAnimations];
    _cycleLayer = nil;
    [_instace removeFromSuperview];
    _instace = nil;
}

@end
