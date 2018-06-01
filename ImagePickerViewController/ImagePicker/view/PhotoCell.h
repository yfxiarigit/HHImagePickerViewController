//
//  PhotoCell.h
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbumCell.h"

@interface PhotoCell : UICollectionViewCell
@property (nonatomic, strong) PhotoItem *photoItem;
- (void)seletedPhoto:(BOOL)selected;
@end
