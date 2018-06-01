//
//  UIImage+PhotoEx.m
//  Cell
//
//  Created by yfxiari on 2018/6/1.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "UIImage+PhotoEx.h"
#import <objc/runtime.h>


static char localIdentifierKey;
static char PHImageFileURLKey;

@implementation UIImage (PhotoEx)


- (void)setLocalIdentifier:(NSString *)localIdentifier {
    objc_setAssociatedObject(self, &localIdentifierKey, localIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)setPhImageFileURLKey:(NSString *)phImageFileURLKey {
    objc_setAssociatedObject(self, &PHImageFileURLKey, phImageFileURLKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)localIdentifier {
    return objc_getAssociatedObject(self, &localIdentifierKey);
}

- (NSString *)phImageFileURLKey {
    return objc_getAssociatedObject(self, &PHImageFileURLKey);
}

@end
