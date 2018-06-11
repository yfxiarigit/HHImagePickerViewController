//
//  PhotoCell.h
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoItem;
@interface PhotoCell : UICollectionViewCell
@property (nonatomic, strong) PhotoItem *photoItem;
@property (nonatomic, assign, getter=isAllowSelectd) BOOL allowSelected;
@property (nonatomic, copy) void(^didClickSelectButtonBlock)(BOOL isSelected);
- (void)seletedPhoto:(BOOL)selected;
@end
