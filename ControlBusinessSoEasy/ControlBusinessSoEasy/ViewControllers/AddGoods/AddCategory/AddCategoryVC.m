//
//  AddCategoryVC.m
//  EasyBusiness
//
//  Created by jiahui on 15/12/1.
//  Copyright © 2015年 YouZai. All rights reserved.
//

#import "AddCategoryVC.h"
#import "EditCategoryViewController.h"
#import "BigCategoryDao.h"
#import "SmallCaregoryDao.h"
#import "BigCategoryBean.h"
#import "SmallCaregoryBean.h"

@interface AddCategoryVC () <UITableViewDataSource,UITableViewDelegate>{
    CategoryType selectType;
    BOOL _tableHasBeenShownAtLeastOnce;
    
    NSInteger _selectBigItem;
    NSInteger _selectSmallItem;
    NSMutableArray *arrayBigCategorys;
    NSMutableArray *arraySmallCategorys;
}
@property (weak, nonatomic) IBOutlet UITableView *bigTableView;
@property (weak, nonatomic) IBOutlet UITableView *smallTable;

@end

@implementation AddCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品分类";
    [UITools customNavigationBackButtonForController:self];
    _tableHasBeenShownAtLeastOnce = NO;
    arrayBigCategorys = [NSMutableArray array];
    arraySmallCategorys = [NSMutableArray array];
    
    [self checkBigCategors];
    [self getDefaultSelectItems];
    _bigTableView.rowHeight = 38;
    _smallTable.rowHeight = 38;
}

- (void)getDefaultSelectItems {
    _selectBigItem = -1;
    if (_alreadyCategoryNames) {
        NSArray *arrNames = [_alreadyCategoryNames componentsSeparatedByString:@" - "];
        if (arrNames) {
            NSString *bigName = [arrNames firstObject];
            [arrayBigCategorys enumerateObjectsUsingBlock:^(BigCategoryBean *obj, NSUInteger idx, BOOL *stop) {
                if ([bigName isEqualToString:obj.name] ) {
                    _selectBigItem = idx;
                    *stop = YES;
                }
            }];
            if (_selectBigItem == -1) {
                _selectBigItem = 0;
            }
            NSString *smallName = [arrNames lastObject];
            BigCategoryBean *fristBigBean = arrayBigCategorys[_selectBigItem];
            [self checkSmallCategorsWithBigCategorID:fristBigBean.idKey];
            [arraySmallCategorys enumerateObjectsUsingBlock:^(SmallCaregoryBean *obj, NSUInteger idx, BOOL * stop) {
                if ([smallName isEqualToString:obj.name]) {
                    _selectSmallItem = idx;
                    *stop = YES;
                }
            }];
        } else {
            _selectBigItem = 0;
            _selectSmallItem = -1;
            BigCategoryBean *fristBigBean = arrayBigCategorys[0];
            [self checkSmallCategorsWithBigCategorID:fristBigBean.idKey];
        }
    } else {
        _selectBigItem = 0;
        _selectSmallItem = -1;
        BigCategoryBean *fristBigBean = arrayBigCategorys[0];
        [self checkSmallCategorsWithBigCategorID:fristBigBean.idKey];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ( ! _tableHasBeenShownAtLeastOnce ) {
        _tableHasBeenShownAtLeastOnce = YES;
        BOOL animationEnabledForInitialFirstRowSelect = YES; // Whether to animate the selection of the first row or not... in viewDidAppear:, it should be YES (to "smooth" it). If you use this same technique in viewWillAppear: then "YES" has no point, since the view hasn't appeared yet.
        [self scrollBigTableView:animationEnabledForInitialFirstRowSelect];
        if (_selectSmallItem != -1) {
            [self scrollSmallTableView:animationEnabledForInitialFirstRowSelect];
        }
    }
}

- (void)scrollBigTableView:(BOOL)animated {
    NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:_selectBigItem inSection: 0];
    [self.bigTableView selectRowAtIndexPath:indexPathForFirstRow animated:animated scrollPosition:UITableViewScrollPositionTop];
}

- (void)scrollSmallTableView:(BOOL)animated {
    NSIndexPath *indexPathForFirstRowSmall = [NSIndexPath indexPathForRow:_selectSmallItem inSection: 0];
    [self.smallTable selectRowAtIndexPath:indexPathForFirstRowSmall animated:animated scrollPosition:UITableViewScrollPositionTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - dataFromDB
- (void)checkBigCategors {
    [arrayBigCategorys removeAllObjects];
   NSArray *array = [[BigCategoryDao shareInstance] selectAll];
    arrayBigCategorys = [NSMutableArray arrayWithArray:array];
    if (arrayBigCategorys.count == 0) {
        BigCategoryBean *bigBean = [BigCategoryBean new];
        bigBean.userId = [UserInfo shareInstance].uid;
        bigBean.name = @"默认分类";
        bigBean.location = 0;
        if ([[BigCategoryDao shareInstance] insertBean:bigBean]) {
            [arrayBigCategorys addObject:bigBean];
        }
    }
}

- (void)checkSmallCategorsWithBigCategorID:(NSString *)bigID {
    [arraySmallCategorys removeAllObjects];
    NSArray *array = [[SmallCaregoryDao shareInstance] selectSmallCaregoryByBigID:bigID];
    arraySmallCategorys = [NSMutableArray arrayWithArray:array];
}

#pragma mark - Actions
- (IBAction)editBigCategory:(id)sender {
    selectType = bigCategory;
    [self performSegueWithIdentifier:@"editCategorySegue" sender:self];
}

- (IBAction)editSmallCategory:(id)sender {
    selectType = smallCategory;
    [self performSegueWithIdentifier:@"editCategorySegue" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditCategoryViewController *editCatagoryVC = (EditCategoryViewController *)segue.destinationViewController;
    editCatagoryVC.categoryType = selectType;
    if (selectType == smallCategory) {
        NSString *bigBeanID = [arrayBigCategorys[_selectBigItem] valueForKey:@"idKey"];
        editCatagoryVC.bigCategoryBeanId = bigBeanID;
        editCatagoryVC.arrayCategorys = arraySmallCategorys;
        editCatagoryVC.needUpdateBlock = ^(BOOL needUpdate){
            if (needUpdate) {
                [self checkSmallCategorsWithBigCategorID:bigBeanID];
                [self.smallTable reloadData];
                [self scrollSmallTableView:YES];
            }
        };
    } else {
        editCatagoryVC.arrayCategorys = arrayBigCategorys;
        editCatagoryVC.needUpdateBlock = ^(BOOL needUpdate){
            if (needUpdate) {
                [self checkBigCategors];
                [self.bigTableView reloadData];
                [self scrollBigTableView:YES];
            }
        };
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _bigTableView) {
        return arrayBigCategorys.count;
    } else {
        return arraySmallCategorys.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    SuperBean *bean = nil;
    if (tableView == _bigTableView ) {
        bean = arrayBigCategorys[indexPath.row];
    } else if (tableView == _smallTable){
        bean = arraySmallCategorys[indexPath.row];
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    cell.textLabel.text = [bean valueForKey:@"name"];
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _bigTableView ) {
        _selectBigItem = indexPath.row;
        NSString *bigBeanID = [arrayBigCategorys[_selectBigItem] valueForKey:@"idKey"];
        [self checkSmallCategorsWithBigCategorID:bigBeanID];
        _selectSmallItem = -1;
        [self.smallTable reloadData];
        
    }  else if (tableView == _smallTable){
        _selectSmallItem = indexPath.row;
        NSString *bigBeanName = [arrayBigCategorys[_selectBigItem] valueForKey:@"name"];
        NSString *smallBeanName = [arraySmallCategorys[_selectSmallItem] valueForKey:@"name"];
        self.categoryNames(bigBeanName, smallBeanName);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
