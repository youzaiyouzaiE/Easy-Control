//
//  NewGoodsViewController.m
//  EasyBusiness
//
//  Created by jiahui on 15/11/7.
//  Copyright © 2015年 YouZai. All rights reserved.
//

#import "NewGoodsViewController.h"
#import "ImageButtonCell.h"
#import "ImageLabelCell.h"
#import "CellButton.h"
#import "CellTextField.h"
#import "ScanBarViewController.h"
#import "AddCategoryVC.h"
#import "GoodsInfoDao.h"
#import "GoodsInfoBean.h"

@interface NewGoodsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>{
    NSArray *section2Array;
    
    NSArray *section0KeysArr;
    NSArray *section1KeysArr;
    NSArray *section2KeysArr;
    
    NSMutableDictionary *dicTextFieldInfo;
    UIAlertView *alertView;
    
    __block NSString *categoryName;
    BOOL keyboardShow;
    
    NSString *hasImage;
    
    
    IBOutlet UITapGestureRecognizer *fristImageGesture;
    IBOutlet UITapGestureRecognizer *secondImageGesture;
    IBOutlet UITapGestureRecognizer *thirdImageGesture;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    section2Array = @[@"进价",@"售价",@"规格",@"库存"];
    section0KeysArr = @[@"goodsIDCode",@"goodsName"];
    section1KeysArr = @[@"goodsInPrice",@"goodsOutPrice",@"goodsStandard",@"goodsStock"];
    section0KeysArr = @[@"goodsAuthor",@"goodsNote"];
    hasImage = @"N";
    
    self.navigationItem.title = @"添加商品";
    [[UITools shareInstance] customNavigationLeftBarButtonForController:self];
    
    dicTextFieldInfo = [NSMutableDictionary dictionary];
    alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideAction:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)CustomNavigationBackButtonAndTitle:(NSString *)title {
    self.navigationItem.title = title;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - action 
- (void)scanBarAction:(id)sender {
    ScanBarViewController *scanBarVC = [[ScanBarViewController alloc] init];
    [self.navigationController pushViewController:scanBarVC animated:YES];
}

- (IBAction)completeAction:(UIButton *)sender {
    if (dicTextFieldInfo[section0KeysArr[1]] == nil) {
        alertView.message = @"请输入商品名称";
        [alertView show];
        return ;
    }
    if (dicTextFieldInfo[section0KeysArr[2]] == nil) {
        alertView.message = @"请选择商品分类";
        [alertView show];
        return ;
    }
    if (dicTextFieldInfo[section1KeysArr[1]] == nil) {
        alertView.message = @"请输入商品售价";
        [alertView show];
        return ;
    }
    [self saveCurrentGoodInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueAddAction:(UIButton *)sender {
    
}

- (void)keyboardShowAction:(NSNotificationCenter *)sender {
    keyboardShow = YES;
}

- (void)keyboardHideAction:(NSNotificationCenter *)sender {
    keyboardShow = NO;
}

- (IBAction)fristImageGestureRecognizerAction:(UITapGestureRecognizer *)sender {
     NSLog(@"frist image action");
}

- (IBAction)secondImageGuestureRecognizerAction:(UITapGestureRecognizer *)sender {
     NSLog(@"second image  ");
}

- (IBAction)thirdImageGestureRecognizerAction:(UITapGestureRecognizer *)sender {
     NSLog(@"third iamge action ");
}

#pragma mark -DB operation
- (void)saveCurrentGoodInfo {
    GoodsInfoBean *bean = [GoodsInfoBean new];
    bean.goodsIDCode = dicTextFieldInfo[section0KeysArr[0]];
    bean.name = dicTextFieldInfo[section0KeysArr[1]];
    bean.category = categoryName;
    bean.inPrice = dicTextFieldInfo[section1KeysArr[0]];
    bean.outPrice = dicTextFieldInfo[section1KeysArr[1]];
    bean.standard = dicTextFieldInfo[section1KeysArr[2]];
    bean.stock = dicTextFieldInfo[section1KeysArr[3]];
    bean.author = dicTextFieldInfo[section2KeysArr[0]];
    bean.note = dicTextFieldInfo[section2KeysArr[1]];
    bean.imagePath = hasImage;
    [[GoodsInfoDao shareInstance] insertBean:bean];
}

#pragma  mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (!keyboardShow) {
        return NO;
    } else {
        [self.view endEditing:YES];
        return YES;
    }
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"商品信息";
    } else if (section == 1) {
        return @"";
    } else if (section == 2) {
        return @"添加图片";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 4;
    } else if (section == 2) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2)
        return 98;
    else 
        return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *barCodeCell = @"BarCodeCell";
    static NSString *nameCell = @"NameCell";
    static NSString *classCell = @"LabelCell";
    static NSString *imagesCell = @"TernaryIamgeCell";
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
//     NSLog(@"indexparh section is %d, row is %d",indexPath.row,indexPath.row);
    if (section == 0) {
        if (row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:barCodeCell];
            ImageButtonCell* imageCell = nil;
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"ImageButtonCell" bundle:nil] forCellReuseIdentifier:barCodeCell];
                imageCell = (ImageButtonCell* )[tableView dequeueReusableCellWithIdentifier:barCodeCell];
                imageCell.textField.delegate = self;
                [imageCell.button addTarget:self action:@selector(scanBarAction:) forControlEvents:UIControlEventTouchUpInside];
            } else
                imageCell = (ImageButtonCell* )cell;
            imageCell.textField.indexPath = indexPath;
            imageCell.textField.text = dicTextFieldInfo[section0KeysArr[indexPath.row]];
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return imageCell;
        } else if (row == 1) {
            ImageLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:nameCell];
            if (!cell) {
                cell = (ImageLabelCell *)[[[NSBundle mainBundle] loadNibNamed:@"ImageLabelCell" owner:self options:nil] objectAtIndex:0];
                cell.textField.delegate = self;
            }
            cell.titleLabel.text = @"名称";
            cell.textField.indexPath = indexPath;
            cell.textField.text = dicTextFieldInfo[section0KeysArr[indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:classCell forIndexPath:indexPath];
            UILabel *CategoryLabel = (UILabel *)[cell viewWithTag:4];
            if (categoryName) {
                CategoryLabel.text = categoryName;
            } else
                CategoryLabel.text = @"默认分类";
            return cell;
        }
    } else if(section == 1) {
        ImageLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:nameCell];
        if (!cell) {
            cell = (ImageLabelCell *)[[[NSBundle mainBundle] loadNibNamed:@"ImageLabelCell" owner:self options:nil] objectAtIndex:0];
            cell.textField.delegate = self;
        }
        cell.textField.indexPath = indexPath;
        cell.titleLabel.text = section2Array[indexPath.row];
        cell.textField.text = dicTextFieldInfo[section1KeysArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:imagesCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
   return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self performSegueWithIdentifier:@"pushToAddCategoryVC" sender:self];
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToAddCategoryVC"]) {
        AddCategoryVC *categoryVC = (AddCategoryVC *)segue.destinationViewController;
        categoryVC.alreadyCategoryNames = categoryName;
       categoryVC.categoryNames = ^(NSString *bigName, NSString *smallName) {
           categoryName = [NSString stringWithFormat:@"%@ - %@",bigName,smallName];
           [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CellTextField *cellTextField = nil;
    if ([textField isKindOfClass:[CellTextField class]]) {
        cellTextField = (CellTextField *)textField;
        NSIndexPath *indexPath = cellTextField.indexPath;
        if ((indexPath.section == 1) && (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3)) {
            [textField setKeyboardType:UIKeyboardTypeDecimalPad];
        }
    }
    [textField setReturnKeyType:UIReturnKeyDone];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    CellTextField *cellTextField = nil;
    if ([textField isKindOfClass:[CellTextField class]]) {
        cellTextField = (CellTextField *)textField;
        NSIndexPath *indexPath = cellTextField.indexPath;
        if ((indexPath.section == 1) && (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3)) {
            [textField setKeyboardType:UIKeyboardTypeDecimalPad];
            if (textField.text.length == 0 && [string isEqualToString:@"."]) {
                return NO;
            }
            if ([textField.text rangeOfString:@"."].location != NSNotFound) {////has point
                if ([string isEqualToString:@"."]) {
                    return  NO;
                }
                if ((textField.text.length - 3 == [textField.text rangeOfString:@"."].location) && ![string isEqualToString:@""]) {
                    alertView.message = @"最多输入两位小数";
                    [alertView show];
                    return NO;
                }
            }
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    CellTextField *cellTextField = nil;
    if ([textField isKindOfClass:[CellTextField class]]) {
        cellTextField = (CellTextField *)textField;
        [self mappingTextFieldDictionary:cellTextField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)mappingTextFieldDictionary:(CellTextField *)textfield {
    if (textfield.text == nil || [textfield.text isEqualToString:@""]) {
        return ;
    }
    NSIndexPath *indexPath = textfield.indexPath;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *dictionKey = @"key";
    if (section == 0) {
        dictionKey = section0KeysArr[row];
    } else if (section == 1) {
        dictionKey = section1KeysArr[row];
        NSNumber *valueNum = nil;
        if (row == 0 || row == 1) {
            valueNum = [NSNumber numberWithDouble:textfield.text.doubleValue];
            dicTextFieldInfo[dictionKey] = valueNum;
            return ;
        }
    } else if (section == 2) {
        dictionKey = section2KeysArr[row];
    }
    dicTextFieldInfo[dictionKey] = textfield.text;
}

@end
