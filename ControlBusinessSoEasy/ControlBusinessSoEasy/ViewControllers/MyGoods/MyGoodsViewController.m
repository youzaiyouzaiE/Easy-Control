//
//  MyGoodsViewController.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/7.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "MyGoodsViewController.h"
#import "GoodsInfoDao.h"
#import "GoodsInfoBean.h"

@interface MyGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    
    NSMutableArray *arrayGoods;
    
    __weak IBOutlet UIView *searchView;
    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet UISegmentedControl *_segment;
    
    CGRect barFrame;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewYConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITools shareInstance] customNavigationLeftBarButtonForController:self];
    NSArray *array = [[GoodsInfoDao shareInstance] selectUserAllGoods];
    arrayGoods = [NSMutableArray arrayWithArray:array];
    
    
    searchView.hidden = YES;
    _searchBar.scopeButtonTitles = @[@"1",@"2",@"3",@"4"];
    
    barFrame = self.navigationController.navigationBar.frame ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TapGestureRecognizeAction

- (IBAction)tapSearchViewAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing: YES];
    [self searchViewShowOrHiddenAnimation:NO];
}

#pragma mark - dataOperation
- (NSString *)imagePathForDocument:(NSString *)imageDoumet {
    NSString *imageDocumetPath = [AppData getCachesDirectorySmallDocumentPath:imageDoumet];
    NSArray *sourceArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imageDocumetPath error:nil];
    if (sourceArray.count != 0) {
        NSString *source = sourceArray.firstObject;
        return [imageDocumetPath stringByAppendingPathComponent:source];
    }else
        return nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayGoods.count +1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 44;
    } else
        return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSString *const cellIdentifier = @"goodsListCell";
     NSString *const searchCellIdentifier = @"searchBarCell";
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
//        UISearchBar *searchBar = (UISearchBar *)[cell viewWithTag:1];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        GoodsInfoBean *bean = arrayGoods[indexPath.row -1];
        
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        NSString *imagePath = [self imagePathForDocument:bean.imagePath];
        if (imagePath) {
            imageView.image = [UIImage imageWithContentsOfFile:imagePath];
        } else
            imageView.image  = [UIImage imageNamed:@"NOPhoto"];
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:2];
        nameLabel.text = [NSString stringWithFormat:@"名称：%@",bean.name];
        UILabel *categoryLabel = (UILabel *)[cell viewWithTag:3];
        categoryLabel.text = [NSString stringWithFormat:@"类别：%@",bean.category];
        
        UILabel *outPriceAndStockLabel = (UILabel *)[cell viewWithTag:4];
        outPriceAndStockLabel.text = [NSString stringWithFormat:@"售价：%@   库存：%@",bean.outPrice.stringValue ,bean.stock];
        return cell;
    }
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"pushToGoodsDetailVC" sender:self];
}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (searchBar != _searchBar) {
        [_searchBar becomeFirstResponder];
        [self searchViewShowOrHiddenAnimation:YES];
        return NO;
    } else {
//         NSLog(@"_search will ");
        return YES;
    }
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (searchBar == _searchBar) {
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if (searchBar == _searchBar ) {
        [self searchViewShowOrHiddenAnimation:NO];
    }
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - searchViewAnimation
-(void)searchViewShowOrHiddenAnimation:(BOOL)isShow {
    if (isShow) {
        searchView.hidden = NO;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _searchViewYConstraint.constant = 20;
            [searchView layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
        [UIView animateWithDuration:0.3 animations:^{
            searchView.alpha = 1;
            self.navigationController.navigationBar.frame = CGRectMake(0, -barFrame.size.height, barFrame.size.width, barFrame.size.height);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            searchView.alpha = 0;
            self.navigationController.navigationBar.frame = CGRectMake(0,barFrame.origin.y, barFrame.size.width, barFrame.size.height);
        }];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _searchViewYConstraint.constant += 44;
            [searchView layoutIfNeeded];
        } completion:^(BOOL finished) {
            searchView.hidden = YES;
        }];
    }
}

@end
