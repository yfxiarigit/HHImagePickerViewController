//
//  ImagePreViewController.h
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/5.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoItem;
@interface ImagePreViewController : UIViewController
@property (nonatomic, strong) NSMutableArray<PhotoItem *> *dataArray;
@end
