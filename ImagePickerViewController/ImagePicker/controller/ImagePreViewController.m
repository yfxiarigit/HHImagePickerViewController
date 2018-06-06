//
//  ImagePreViewController.m
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/5.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "ImagePreViewController.h"
#import "ImagePreviewCell.h"

@interface ImagePreViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImagePreviewCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ImagePreViewController {
    BOOL _isOriginalNavHidden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isOriginalNavHidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:_isOriginalNavHidden animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImagePreviewCell *cell = (ImagePreviewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImagePreviewCell" forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //写在这里是为了使返回到被缩放的cell时，能够及时复原原始图片大小
    ((ImagePreviewCell *)cell).item = self.dataArray[indexPath.row];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - cell delegate
- (void)previewCell:(ImagePreviewCell *)cell loadPhotoFinish:(UIImage *)image {
    
}

- (void)dismissPreViewController {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.dataArray removeAllObjects];
    }];
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = [UIScreen mainScreen].bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.alwaysBounceHorizontal = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ImagePreviewCell class] forCellWithReuseIdentifier:@"ImagePreviewCell"];
    }
    return _collectionView;
}

- (NSMutableArray<PhotoItem *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
