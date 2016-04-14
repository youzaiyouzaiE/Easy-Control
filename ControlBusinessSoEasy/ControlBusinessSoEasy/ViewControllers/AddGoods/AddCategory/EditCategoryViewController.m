//
//  EditCategoryViewController.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "EditCategoryViewController.h"
#import "BigCategoryBean.h"
#import "SmallCaregoryBean.h"
#import "SmallCaregoryDao.h"
#import "BigCategoryDao.h"
#import "AddOrEditViewController.h"

@interface EditCategoryViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate> {
    BOOL isEditType;
    BOOL isAddCategory;
    
    id <UINavigationControllerDelegate> navigationDelegate;
    BOOL isNeedUpdateCategoryList;
    
    NSString *categoryName;
    
    NSString *modifyName;
    
    UIAlertView *alertView;
    NSInteger deleteRow;
    BigCategoryBean *bigBean;
    NSArray *smallBeansArray;
    BOOL isDeleteBean;
    
    SuperBean *currentEditBean;////当前要修改的bean
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EditCategoryViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backItemAction:)];
    
    if (self.categoryType == smallCategory) {
        self.navigationItem.title = @"小分类";
    } else {
        self.navigationItem.title = @"大分类";
    }
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton addTarget:self action:@selector(editButtionItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitle:@"完成" forState:UIControlStateSelected];
    editButton.frame = CGRectMake(0, 0, 40, 40);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    if (!_arrayCategorys) {
        _arrayCategorys = [NSMutableArray array];
    }
    _tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

#pragma mark - action
-(void)backItemAction:(id)sender {
    if (isNeedUpdateCategoryList) {
        self.needUpdateBlock(YES,isDeleteBean);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editButtionItemAction:(UIButton *)button {
    button.selected = !button.selected;
    isEditType = button.selected;
    if (isEditType) {
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView.editing = YES;
    } else {
        _tableView.allowsMultipleSelectionDuringEditing = NO;
        _tableView.editing = NO;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.class isSubclassOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        
    }
    return YES;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NSLog(@"添加 Is cancelled: %i", [context isCancelled]);
        if (![context isCancelled]) {
            if (isNeedUpdateCategoryList) {
                self.needUpdateBlock(YES,isDeleteBean);
            }
        }
    }];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _arrayCategorys.count) {
        return 40;
    } else {
        return 70;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayCategorys.count +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"defaultCell";
    static NSString *addIdentifier = @"addCell";
    if (indexPath.row < _arrayCategorys.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        SuperBean *bean = _arrayCategorys[indexPath.row];
        cell.textLabel.text = [bean valueForKey:@"name"];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
//        UILabel *titleLable = (UILabel *)[cell viewWithTag:1];
//        self.categoryType == smallCategory ? (titleLable.text = @"添加小分类" ): (titleLable.text = @"添加大分类" );
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    SuperBean *bean = _arrayCategorys[indexPath.row];
    modifyName = [bean valueForKey:@"name"];
    [self performSegueWithIdentifier:@"AddOrEditSegue" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [_arrayCategorys count]) {
        return YES;
    } else
        return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _arrayCategorys.count) {
        return YES;
    } else
        return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <_arrayCategorys.count) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        isNeedUpdateCategoryList = YES;
        deleteRow = indexPath.row;
        SuperBean *bean = _arrayCategorys[indexPath.row];
        if ([bean isKindOfClass:[BigCategoryBean class]]) {
            bigBean = (BigCategoryBean *)bean;
            smallBeansArray = [[SmallCaregoryDao shareInstance] selectSmallCaregoryByBigID:bigBean.idKey];
            if (smallBeansArray.count >0) {
                if (!alertView) {
                     alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"将删除该大分类下所有小分类" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
                }
                [alertView show];
            }
        } else {
            [bean deleteBean];
            [_arrayCategorys removeObjectAtIndex:deleteRow];
            [_tableView reloadData];
            isDeleteBean = YES;
        }
    }
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _arrayCategorys.count) {
        isAddCategory = NO;
        if (isEditType) {
            currentEditBean = _arrayCategorys[indexPath.row];
            modifyName = [currentEditBean valueForKey:@"name"];
            [self performSegueWithIdentifier:@"AddOrEditSegue" sender:self];
        } else {///Choose
            if (isNeedUpdateCategoryList) {
                self.needUpdateBlock(YES,isDeleteBean);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        isAddCategory = YES;
        modifyName = nil;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"AddOrEditSegue" sender:self];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        for (SmallCaregoryBean *smallBean in smallBeansArray) {
            [smallBean deleteBean];
        }
        [bigBean deleteBean];
        [_arrayCategorys removeObjectAtIndex:deleteRow];
        [_tableView reloadData];
        isDeleteBean = YES;
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddOrEditViewController *addOrEidtVC = ( AddOrEditViewController *)[segue destinationViewController];
    if (isAddCategory && self.categoryType == smallCategory) {
        addOrEidtVC.navTitle = @"添加小分类";
    } else if (isAddCategory && self.categoryType == bigCategory) {
        addOrEidtVC.navTitle = @"添加大分类";
    } else if (!isAddCategory && self.categoryType == bigCategory) {
        addOrEidtVC.navTitle = @"修改大分类";
    } else if (!isAddCategory && self.categoryType == smallCategory) {
        addOrEidtVC.navTitle = @"修改小分类";
    }
    addOrEidtVC.arrayContents = _arrayCategorys;
    addOrEidtVC.textFiledStr = modifyName;
    addOrEidtVC.categoryName = ^(NSString *name){
        categoryName = name;
        /////save bean
        if (self.categoryType == smallCategory) {
            if (!isEditType) {
                SmallCaregoryBean *bean = [SmallCaregoryBean new];
                bean.bigCaregoryID = _bigCategoryBeanId;
                bean.name = name;
                bean.location = _arrayCategorys.count;
                [[SmallCaregoryDao shareInstance] insertBean:bean];
                [_arrayCategorys addObject:bean];
            } else {
                [currentEditBean setValue:name forKey:@"name"];
                [[SmallCaregoryDao shareInstance] updateBean:currentEditBean];
            }
             isNeedUpdateCategoryList = YES;
        } else {
            if (!isEditType) {
                BigCategoryBean *bean = [BigCategoryBean new];
                bean.userId = [UserInfo shareInstance].uid;
                bean.name = name;
                bean.location = _arrayCategorys.count;
                [[BigCategoryDao shareInstance] insertBean:bean];
                [_arrayCategorys addObject:bean];
            } else {
                [currentEditBean setValue:name forKey:@"name"];
                [[BigCategoryDao shareInstance] updateBean:currentEditBean];
            }
             isNeedUpdateCategoryList = YES;
        }
        [self.tableView reloadData];
    };
}





@end
