//
//  ImagePreviewCell.h
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/5.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImagePreviewCell;
@protocol ImagePreviewCellDelegate <NSObject>

/**
 加载图片完成
 
 @param cell cell
 @param image 图片
 */
- (void)previewCell:(ImagePreviewCell *)cell loadPhotoFinish:(UIImage *)image;

- (void)dismissPreViewController;

@end
@class PhotoItem;
@interface ImagePreviewCell : UICollectionViewCell
@property (nonatomic, strong) PhotoItem *item;
@property (nonatomic, weak) id<ImagePreviewCellDelegate> delegate;
@property (nonatomic, assign) int32_t imageRequestID;
@end
