//
//  CircleProgressView.m
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/7.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "CircleProgressView.h"

#define CGPointCenterPointOfRect(rect) CGPointMake(rect.origin.x + rect.size.width / 2.0f, rect.origin.y + rect.size.height / 2.0f)

@implementation CircleProgressView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.lineWidth =1.5f;
        self.progressBackgroundColor = [UIColor lightGrayColor];
        self.progressColor = [UIColor whiteColor];
        self.type = CircleProgressViewTypeStroke;
        self.padding = 2;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self drawBackground:rect];
    [self drawProgress:rect];
}

- (void)drawBackground:(CGRect)rect {
    CGRect ovalRect = CGRectMake(self.lineWidth, self.lineWidth, rect.size.width - 2 * self.lineWidth, rect.size.height - 2 * self.lineWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    path.lineWidth = self.lineWidth;
    [self.progressBackgroundColor setStroke];
    [path stroke];
}

- (void)drawProgress:(CGRect)rect {
    CGFloat padding = 0;
    if (self.type == CircleProgressViewTypeFill) {
        padding = self.padding;
    }
    CGRect arcRect = CGRectMake(self.lineWidth + padding, self.lineWidth + padding, rect.size.width - 2 * self.lineWidth - 2 * padding, rect.size.height - 2 * self.lineWidth - 2 * padding);
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = startAngle + self.percent * 2 * M_PI;
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointCenterPointOfRect(arcRect) radius:arcRect.size.width * 0.5 startAngle:startAngle endAngle:endAngle clockwise:YES];
    if (self.type == CircleProgressViewTypeStroke) {
        path.lineWidth = self.lineWidth;
        [self.progressColor setStroke];
        [path stroke];
    }else {
        [path addLineToPoint:CGPointCenterPointOfRect(arcRect)];
        [path closePath];
        [self.progressColor setFill];
        [path fill];
    }
}

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    [self setNeedsDisplay];
}

@end

