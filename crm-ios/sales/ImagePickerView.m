//
//  ImagePickerView.m
//  sales
//
//  Created by user on 2016/11/24.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import "ImagePickerView.h"
#import "OMeViewController.h"
#import "JFImagePickerController.h"
#import "ImagePickerCell.h"
static NSString *imagePickerCellIdentifier = @"imagePickerCellIdentifier";

@interface ImagePickerView()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray<UIImage *> *_photosArray;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ImagePickerConfig *config;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) BOOL showDeleteIcon;
@property (nonatomic, strong) NSString *rightItemTitle;

@end

@implementation ImagePickerView

- (instancetype)initWithFrame:(CGRect)frame config:(ImagePickerConfig *)config {
    if(self = [super initWithFrame:frame]) {
        _config = (config != nil)?config:([ImagePickerConfig new]);
        [self setupView];
        [self initializeData];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame config:nil];
}

- (void)setCurrentController:(UIViewController *)currentController {
    _rightItemTitle = currentController.navigationItem.rightBarButtonItem.title;
    _currentController = currentController;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = _config.itemSize;
    layout.sectionInset = _config.sectionInset;
    layout.minimumLineSpacing = _config.minimumLineSpacing;
    layout.minimumInteritemSpacing = _config.minimumInteritemSpacing;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.clipsToBounds = YES;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.bounces = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[ImagePickerCell class] forCellWithReuseIdentifier:imagePickerCellIdentifier];
    [self addSubview:_collectionView];
    
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGes:)];
    [_collectionView addGestureRecognizer:longGes];
}

- (void)initializeData {
    _photosArray = [NSMutableArray new];
}

- (void)refreshCollectionView {
    NSInteger n;
    CGFloat width = _collectionView.frame.size.width - _config.sectionInset.left - _config.sectionInset.right;
    n = (width + _config.minimumInteritemSpacing)/(_config.itemSize.width + _config.minimumInteritemSpacing);
    CGFloat height = ((NSInteger)(_photosArray.count)/n +1) * (_config.itemSize.height + _config.minimumLineSpacing);
    height -= _config.minimumLineSpacing;
    height += _config.sectionInset.top;
    height += _config.sectionInset.bottom;
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    [_collectionView reloadData];
    if(self.viewHeightChanged) {
        self.viewHeightChanged(height);
    }
}

- (void)refreshImagePickerViewWithPhotoArray:(NSArray *)array {
    if(array.count > 0) {
        [_photosArray removeAllObjects];
        [_photosArray addObjectsFromArray:array];
    }
    [self refreshCollectionView];
}

- (NSArray<UIImage *> *)getPhotos {
    NSArray *array = [NSArray arrayWithArray:_photosArray];
    return array;
}

#pragma make - collectionViewDelegate -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(_photosArray.count < _config.photosMaxCount) {
        return _photosArray.count + 1;
    }
    return _photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imagePickerCellIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if (indexPath.row < _photosArray.count) {
        cell.imgView.image = _photosArray[indexPath.row];
        cell.deleteBtn.hidden = !self.showDeleteIcon;
    } else {
        cell.imgView.image = [UIImage imageNamed:@"moments_add"];
        cell.deleteBtn.hidden = true;
    }
    cell.deleteBlock = ^(NSIndexPath *indexPath) {
        [_photosArray removeObjectAtIndex:indexPath.row];
        [_collectionView reloadData];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row >= _photosArray.count) {
        self.showDeleteIcon = false;
        self.currentController.navigationItem.rightBarButtonItem.title = self.rightItemTitle;
        [_collectionView reloadData];
        [self pickPhotos];
    }
}

- (void)longGes:(UILongPressGestureRecognizer *)longGes {
    if (longGes.state == UIGestureRecognizerStateBegan) {
        self.showDeleteIcon = true;
        self.currentController.navigationItem.rightBarButtonItem.title = @"完成";
        [_collectionView reloadData];
    }
}

- (void)endEdit {
    self.showDeleteIcon = false;
    [_collectionView reloadData];
    self.currentController.navigationItem.rightBarButtonItem.title = self.rightItemTitle;
}

- (void)pickPhotos{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从照片库选取",nil];
    [action showInView:self.currentController.view];
}


#pragma mark - UIActionSheet delegateÓ -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *vc = [UIImagePickerController new];
            vc.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
            vc.delegate = self;
            [self.currentController presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 1:
        {
            NSInteger count = _config.photosMaxCount - _photosArray.count;
            [JFImagePickerController setMaxCount:count];
            JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:[UIViewController new]];

            picker.pickerDelegate = self;
            
            [self.currentController presentViewController:picker animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - JFImagePicker Delegate -

- (void)imagePickerDidFinished:(JFImagePickerController *)picker{
    
    __weak typeof(self) weakself = self;
    for (ALAsset *asset in picker.assets) {
        [[JFImageManager sharedManager] imageWithAsset:asset resultHandler:^(CGImageRef imageRef, BOOL longImage) {
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_photosArray addObject:image];
                [weakself refreshCollectionView];
            });
        }];
    }
    [self imagePickerDidCancel:picker];
}

- (void)imagePickerDidCancel:(JFImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [JFImagePickerController clear];
}

#pragma  mark - imagePickerController Delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self imageHandleWithpickerController:picker MdediaInfo:info];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imageHandleWithpickerController:(UIImagePickerController *)picker MdediaInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_photosArray addObject:image];
    [self refreshCollectionView];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

@end

@implementation ImagePickerConfig

- (instancetype)init {
    if(self = [super init]) {
        _itemSize = CGSizeMake(60, 60);
        _sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _minimumLineSpacing = 10.0f;
        _minimumInteritemSpacing = 10.0f;
        _photosMaxCount = 9;
    }
    return self;
}


@end
