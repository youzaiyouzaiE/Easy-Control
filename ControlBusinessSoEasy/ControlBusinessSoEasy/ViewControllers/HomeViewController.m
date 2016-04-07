//
//  HomeViewController.m
//  EasyBusiness
//
//  Created by jiahui on 15/10/13.
//  Copyright (c) 2015年 YouZai. All rights reserved.
//

#import "HomeViewController.h"
#import "RACollectionViewReorderableTripletLayout.h"
#import "NewGoodsViewController.h"

@interface HomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,RACollectionViewDelegateReorderableTripletLayout, RACollectionViewReorderableTripletLayoutDataSource,UIGestureRecognizerDelegate> {
    
    NSArray *titleArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"生意宝";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:73/255.0f green:179/255.0f blue:255/255.0f alpha:1];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    titleArray = @[@"我的商品",@"新增商品",@"销售商品",@"销售查询",@"预购清单",@"采购商品",@"会员信息",@"关于"];
    
    if (IOS_7LAST) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.class isSubclassOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
//         NSLog(@"Home interactivePopGestureRecognizer");
    }
    return YES;
}

#pragma mark - RACollectionViewDelegateTripletLayout
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(10.f, 0, 20.f, 0);
}

- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView {
    return 0;
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView {
    return 10.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView {
    return 10.f;
}

#pragma mark - RACollectionViewDelegateReorderableTripletLayout
- (CGFloat)reorderingItemAlpha:(UICollectionView *)collectionview {
    return .3f;
}

- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(50.f, 0, 50.f, 0); //Sorry, horizontal scroll is not supported now.
}

- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView reloadData];
}

#pragma mark - RACollectionViewReorderableTripletLayoutDataSource
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {
    //    UIImage *image = [_photosArray objectAtIndex:fromIndexPath.item];
    //    [_photosArray removeObjectAtIndex:fromIndexPath.item];
    //    [_photosArray insertObject:image atIndex:toIndexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ItemCell";
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UILabel *title = (UILabel *)[cell viewWithTag:2];
    title.text = titleArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *itemString = titleArray[indexPath.row];
    if ([itemString isEqualToString:@"新增商品"]) {
        [self performSegueWithIdentifier:@"AddGoods" sender:self];
    } else if([itemString isEqualToString:@"我的商品"]) {
        [self performSegueWithIdentifier:@"pushToMyGoodsVC" sender:self];
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
}


@end
