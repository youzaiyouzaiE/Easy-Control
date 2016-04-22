//
//  PhotosGridViewController.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/21.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "PhotosGridViewController.h"
#import "PhotoGridCell.h"
#import "PhotoTableCell.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SDImageCache.h"
#import "MWCommon.h"
#import "MWPhotoBrowser.h"

static NSString * const reuseIdentifier = @"PhotoGridCell";

@interface PhotosGridViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource> {
    UIButton *titleButton;
    UIImageView *arrowImage;
    UIView *backGroundView;
    
    //
    NSMutableArray *_arrayItemSelectType;////NSNumber  是否选中对应的item
    
    NSMutableArray *_arrayTableContent;////PHAssetCollection 存入有图片的AssetCollection
    NSMutableArray *_arrayCurrentItems;////当前显示的item里内容 image?
}

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation PhotosGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrayTableContent = [NSMutableArray array];
    
    [self customNavigationBar];
    [self addCollectionView];
    [self addBottomViewAndSubVeiw];
    [self addTableViewAndBackgroudnView];
    [self loadAssetCollectionAndAllPhotoAsset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - view 
-(void)customNavigationBar
{
    UIButton *cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut setFrame:CGRectMake(0, 0, 40, 40)];
    [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBut addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBut];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = NAVIGATION_BAR_COLOR;
    
    titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setFrame:CGRectMake(0, 0, 120, 44)];
    [titleButton setTitle:@"所有照片" forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    [titleButton addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewArrowDown"]];
    [arrowImage setFrame:CGRectMake(titleButton.bounds.size.width - 15 - 4,(titleButton.bounds.size.height - 15)/2 , 15, 15)];
    [titleButton addSubview:arrowImage];
    self.navigationItem.titleView = titleButton;
}

- (void)addCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 2, 5, 2);
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width -10)/4, (self.view.bounds.size.width -10)/4);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[PhotoGridCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_collectionView];
}

- (void)addBottomViewAndSubVeiw
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIButton *completeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeBut setFrame:CGRectMake(self.view.bounds.size.width - 60, 5, 44, 35)];
    [completeBut setTitle:@"完成" forState:UIControlStateNormal];
    [completeBut addTarget:self action:@selector(completeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [completeBut setBackgroundColor:[[UIColor orangeColor] colorWithAlphaComponent:0.5]];
    [bottomView addSubview:completeBut];
    
    [self.view addSubview:bottomView];
}

- (void)addTableViewAndBackgroudnView
{
    backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backGroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    backGroundView.alpha = 0;
    [self.view addSubview:backGroundView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -self.view.bounds.size.height*2/3, self.view.bounds.size.width, self.view.bounds.size.height*2/3) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    [self.view addSubview:_tableView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [backGroundView addGestureRecognizer:tapGesture];
}

#pragma mark - action 
- (void)cancelButtonAction:(UIButton *)button {
    [self dismissView];
}

- (void)titleButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    [self backGroundViewHiddenOrShowAnimation:button.selected];
}

- (void)backGroundViewHiddenOrShowAnimation:(BOOL)isShow {
    [UIView animateWithDuration:0.4 animations:^{
        if (isShow) {
            arrowImage.transform =CGAffineTransformMakeRotation(-M_PI);
            backGroundView.alpha = 1;
            _tableView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height*2/3);
        } else {
            arrowImage.transform = CGAffineTransformMakeRotation(0);
            backGroundView.alpha = 0;
            _tableView.frame = CGRectMake(0, -self.view.bounds.size.height*2/3, self.view.bounds.size.width, self.view.bounds.size.height*2/3);
        }
    }];
}

- (void)tapGestureAction:(id)sender {
    [self backGroundViewHiddenOrShowAnimation:NO];
    titleButton.selected = NO;
}

- (void)completeButtonAction:(id)sender {
    [self dismissView];
}

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - data
- (void)setPhotoSelected:(BOOL)selected atIndex:(NSUInteger)index////set Value
{
    
}

- (BOOL)photoIsSelectedAtIndex:(NSUInteger)index /////get select Value
{
    BOOL value = NO;
    if ([self.delegate respondsToSelector:@selector(photoBrowser:isPhotoSelectedAtIndex:)]) {
        //            value = [self.delegate photoBrowser:self isPhotoSelectedAtIndex:index];
    }
    return value;
}


#pragma mark - load album source
- (void)loadAssetCollectionAndAllPhotoAsset {
    // Load
    if (NSClassFromString(@"PHAsset")) {
        
        // Photos library iOS >= 8
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *options = [PHFetchOptions new];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            
//            PHImageManager *manager = [PHImageManager defaultManager];
//            PHImageRequestOptions *option = [PHImageRequestOptions new];
//            option.networkAccessAllowed = YES;
//            option.resizeMode = PHImageRequestOptionsResizeModeFast;
//            option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//            option.synchronous = false;
//            option.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
//                //                NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithDouble: progress], @"progress", self, @"photo", nil];
//                //                 NSLog(@" option dic = %@",dict);
//            };
            
            /////PHAssetCollectionTypeSmartAlbum    11个（系统的）
            //////PHAssetCollectionTypeAlbum        3个（自定义的： qq 微博 网易新闻）[estimatedAssetCount 7. 2. 1
            //////PHAssetCollectionTypeMoment       地址 （拍照的）
            PHFetchResult *fetchResults = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            PHFetchResult *userResults = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            
            [fetchResults enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"%@",obj.localizedTitle);
                    PHFetchResult *sasets = [PHAsset fetchAssetsInAssetCollection:obj options:options];
                    NSLog(@"sasets content:%lu",(unsigned long)sasets.count);
                    if (sasets.count > 0 && obj.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos) {
                        [_arrayTableContent addObject:obj];
                    }
            }];
            [userResults enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"%@",obj.localizedTitle);
                PHFetchResult *sasets = [PHAsset fetchAssetsInAssetCollection:obj options:options];
                NSLog(@"sasets content:%lu",(unsigned long)sasets.count);
                if (sasets.count > 0) {
                    [_arrayTableContent addObject:obj];
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });

            
        });
        
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 400;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.index = indexPath.row;
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }


/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
*/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayTableContent.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 70;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ NSString *const cellIdentifier = @"PHimageCell";
    PhotoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PhotoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    PHAssetCollection *assetCollection = _arrayTableContent[indexPath.row];
    PHFetchResult *sasets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    [cell setImage:nil title:assetCollection.localizedTitle andNumberContent:[NSString stringWithFormat:@"%lu",(unsigned long)sasets.count]];
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
