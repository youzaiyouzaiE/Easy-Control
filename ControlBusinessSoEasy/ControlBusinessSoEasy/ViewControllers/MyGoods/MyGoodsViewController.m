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
#import "GoodsDetailViewController.h"

@interface MyGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIGestureRecognizerDelegate> {
    
    NSMutableArray *arrayGoods;
    
    __weak IBOutlet UIView *searchView;
    __weak IBOutlet UISearchBar *_searchBar;
    UISearchBar *cellSearchBar;
    
    BOOL isShowSearchTableView;
    
    CGRect barFrame;
    NSArray *nameResultArray;
    NSArray *categoryResultArray;
    NSArray *authorResultArray;
    NSArray *noteResultArray;
    
    id <UIGestureRecognizerDelegate> gestureDelegate;
    GoodsInfoBean *_selectBean;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewYConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong ,nonatomic) IBOutletCollection(UITableView) NSArray *searchTableViews;

@property (weak, nonatomic) IBOutlet UITableView *nameResultTableView;
@property (weak, nonatomic) IBOutlet UITableView *categoryResultTableVeiw;
@property (weak, nonatomic) IBOutlet UITableView *authorResultTableView;
@property (weak, nonatomic) IBOutlet UITableView *noteResultTableView;

@end

@implementation MyGoodsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (IOS_7LAST) {
        gestureDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    if (isShowSearchTableView) {
        self.navigationController.navigationBar.frame = CGRectMake(0, -barFrame.size.height, barFrame.size.width, barFrame.size.height);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (IOS_7LAST) {
        self.navigationController.interactivePopGestureRecognizer.delegate = gestureDelegate;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"我的商品", @"我的商品");
    [[UITools shareInstance] customNavigationLeftBarButtonForController:self];
    NSArray *array = [[GoodsInfoDao shareInstance] selectUserAllGoods];
    arrayGoods = [NSMutableArray arrayWithArray:array];
    barFrame = self.navigationController.navigationBar.frame ;

    searchView.hidden = YES;
    _searchBar.scopeButtonTitles = @[@"名称",@"分类",@"供应商",@"备注"];
    [self checkResultTableViewState];
}

- (void)checkResultTableViewState
{
    if (nameResultArray == nil) {
        _nameResultTableView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TapGestureRecognizeAction
- (IBAction)tapSearchViewAction:(UITapGestureRecognizer *)sender
{
    [self.view endEditing: YES];
    [self searchViewShowOrHiddenAnimation:NO];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.class isSubclassOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        if (!searchView.hidden) {
            return NO;
        } else
            return YES;
    } else {////tap
        if (isShowSearchTableView) {
            [self.view endEditing: YES];
            UIButton *btnCancel = [_searchBar valueForKey:@"_cancelButton"];
            [btnCancel setEnabled:YES];
            return NO;
        } else
            return YES;
    }
}

#pragma mark - imageFileOperation
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return arrayGoods.count +1;
    }else if (tableView == _nameResultTableView) {
        return nameResultArray.count;
    }else if (tableView == _categoryResultTableVeiw) {
        return categoryResultArray.count;
    }else if (tableView == _authorResultTableView) {
        return authorResultArray.count;
    }else if (tableView == _noteResultTableView) {
        return noteResultArray.count;
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        if (indexPath.row == 0) {
            return 44;
        } else
            return 70;
    } else
        return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *const cellIdentifier = @"goodsListCell";
     NSString *const searchCellIdentifier = @"searchBarCell";
    if (indexPath.row == 0 && tableView == _tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
        cellSearchBar = (UISearchBar *)[cell viewWithTag:1];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        GoodsInfoBean *bean = nil;
        if (tableView == _tableView) {
            bean = arrayGoods[indexPath.row -1];
        } else if(tableView == _nameResultTableView) {
            bean = nameResultArray[indexPath.row];
        } else if(tableView == _categoryResultTableVeiw) {
            bean = categoryResultArray[indexPath.row];
        } else if(tableView == _authorResultTableView) {
            bean = authorResultArray[indexPath.row];
        } else if(tableView == _noteResultTableView) {
            bean = noteResultArray[indexPath.row];
        }
        
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5.0f;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _tableView) {
        _selectBean = arrayGoods[indexPath.row - 1];
    } else if(tableView == _nameResultTableView) {
        _selectBean = nameResultArray[indexPath.row];
    } else if(tableView == _categoryResultTableVeiw) {
        _selectBean = categoryResultArray[indexPath.row];
    } else if(tableView == _authorResultTableView) {
        _selectBean = authorResultArray[indexPath.row];
    } else if(tableView == _noteResultTableView) {
        _selectBean = noteResultArray[indexPath.row];
    }
    [self performSegueWithIdentifier:@"pushToGoodsDetailVC" sender:self];
}

- (void)cellSearchBarAnimation {
    CGRect frame = cellSearchBar.frame;
    [UIView animateWithDuration:0.3 animations:^{
        cellSearchBar.frame = CGRectMake(0, -40, frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
        cellSearchBar.frame = frame;
    }];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar != _searchBar) {
        [self cellSearchBarAnimation];
        [_searchBar becomeFirstResponder];
        [self searchViewShowOrHiddenAnimation:YES];
        return NO;
    } else {
        
        return YES;
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar == _searchBar) {
//        NSLog(@"text :%@",searchBar.text);
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) {
        NSInteger selectIndex = _searchBar.selectedScopeButtonIndex ;
        [self clearData];
        _searchBar.selectedScopeButtonIndex = selectIndex;
        return ;
    }
        [self dataBaseSelectMethodString];
}

//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
////    NSLog(@"text :%@",searchBar.text);
//    return YES;
//}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self searchViewShowOrHiddenAnimation:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar setShowsCancelButton:YES animated:NO];
    if (searchBar == _searchBar ) {
         [self dataBaseSelectMethodString];
    }
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    if ([searchBar.text isEqualToString:@""] || searchBar.text == nil) {
        return;
    }
    NSArray *searchResultArray = [self arrayForTableViewWithScopeIndex:selectedScope];
    if (searchResultArray == nil) {
        [self dataBaseSelectMethodString];
    } else {
        [self whereSearchTableViewShow:[self selectTableViewWithScopeIndex:selectedScope]];
    }
}

- (UITableView *)selectTableViewWithScopeIndex:(NSInteger)index {
    if (index == 0) {
        return _nameResultTableView;
    } else if (index == 1) {
        return _categoryResultTableVeiw;
    } else if (index == 2) {
        return _authorResultTableView;
    } else if (index == 3) {
       return _noteResultTableView;
    }
    return nil;
}

- (NSArray *)arrayForTableViewWithScopeIndex:(NSInteger)index {
    if (index == 0) {
        return nameResultArray;
    } else if (index == 1) {
        return categoryResultArray;
    } else if (index == 2) {
        return authorResultArray;
    } else if (index == 3) {
        return noteResultArray;
    }
    return  nil;
}

- (void)whereSearchTableViewShow:(UITableView *)tableView {
    for (UITableView *table in _searchTableViews) {
        if (table == tableView) {
            table.hidden = NO;
        } else {
            isShowSearchTableView = YES;
            table.hidden = YES;
        }
    }
}


#pragma mark - dataBase operation 
-(void)dataBaseSelectMethodString
{
    switch (_searchBar.selectedScopeButtonIndex) {
        case 0:
        {
            nameResultArray = [[GoodsInfoDao shareInstance] selectGoodsWithName:_searchBar.text];
            [self whereSearchTableViewShow:_nameResultTableView];
            if (nameResultArray.count > 0) {
                [_nameResultTableView reloadData];
            } else {
                _nameResultTableView.hidden = YES;
                isShowSearchTableView = NO;
            }
        }
            break;
            
        case 1:
        {
            categoryResultArray = [[GoodsInfoDao shareInstance] selectGoodsWithCategory:_searchBar.text];
            [self whereSearchTableViewShow:_categoryResultTableVeiw];
            if (categoryResultArray.count > 0) {
                [_categoryResultTableVeiw reloadData];
            }  else {
                _categoryResultTableVeiw.hidden = YES;
                isShowSearchTableView = NO;
            }
        }
            break;
            
        case 2:
        {
            authorResultArray = [[GoodsInfoDao shareInstance] selectGoodsWithAuthor:_searchBar.text];
             [self whereSearchTableViewShow:_authorResultTableView];
            if (authorResultArray.count > 0) {
                [_authorResultTableView reloadData];
            }  else {
                _authorResultTableView.hidden = YES;
                isShowSearchTableView = NO;
            }
        }
            break;
            
        case 3:
        {
            noteResultArray = [[GoodsInfoDao shareInstance] selectGoodsWithNote:_searchBar.text];
            [self whereSearchTableViewShow:_noteResultTableView];
            if (noteResultArray.count > 0) {
                [_noteResultTableView reloadData];
            }  else {
                _noteResultTableView.hidden = YES;
                isShowSearchTableView = NO;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)clearData {
    nameResultArray = nil;
    categoryResultArray = nil;
    authorResultArray = nil;
    noteResultArray = nil;
    
    _nameResultTableView.hidden = YES;
    _categoryResultTableVeiw.hidden = YES;
    _authorResultTableView.hidden = YES;
    _noteResultTableView.hidden = YES;
     isShowSearchTableView = NO;
    
    _searchBar.text = nil;
    _searchBar.selectedScopeButtonIndex = 0;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToGoodsDetailVC"]) {
        GoodsDetailViewController *detailVC = (GoodsDetailViewController *)[segue destinationViewController];
        detailVC.contentGoodsBean = _selectBean;
        if (isShowSearchTableView) {
            detailVC.isFromSearchView = YES;
        }
    }
}

#pragma mark - searchViewAnimation
-(void)searchViewShowOrHiddenAnimation:(BOOL)isShow
{
    if (isShow) {
        APPLICATION_SHARE.navigationBarIsUp = YES;
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
        APPLICATION_SHARE.navigationBarIsUp = NO;
        searchView.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            searchView.alpha = 0;
            self.navigationController.navigationBar.frame = CGRectMake(0,barFrame.origin.y, barFrame.size.width, barFrame.size.height);
        }];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _searchViewYConstraint.constant += 44;
            [searchView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self clearData];
        }];
    }
}

- (void)dealloc
{
    
}


@end
