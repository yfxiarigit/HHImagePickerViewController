//
//  PhotoItem.h
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotoItem : NSObject

@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, strong) PHAsset *phAsset;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) UIImage *previewImage;

+ (PhotoItem *)itemWithPHAsset:(PHAsset *)asset;
@end
