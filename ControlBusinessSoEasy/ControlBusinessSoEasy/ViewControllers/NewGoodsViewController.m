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

@interface NewGoodsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSArray *section2Array;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     section2Array = @[@"进价",@"售价",@"规格",@"库存"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        return @"上传图片";
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
    static NSString *classCell = @"ClassCell";
    static NSString *imagesCell = @"ImagesCell";
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && row != 1) {
        if (row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:barCodeCell];
            ImageButtonCell* imageCell = nil;
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"ImageButtonCell" bundle:nil] forCellReuseIdentifier:barCodeCell];
                imageCell = (ImageButtonCell* )[tableView dequeueReusableCellWithIdentifier:barCodeCell];
                imageCell.textField.delegate = self;
            }
            imageCell.textField.indexPath = indexPath;
            [imageCell.button addTarget:self action:@selector(scanBarAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            return imageCell;
        } else if (row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:classCell forIndexPath:indexPath];
            
        }
    } else if(section == 1 || (section == 0 && row == 1)) {
        ImageLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:nameCell];
        if (!cell) {
            cell = (ImageLabelCell *)[[[NSBundle mainBundle] loadNibNamed:@"ImageLabelCell" owner:self options:nil] objectAtIndex:0];
            cell.textField.delegate = self;
        }
        cell.textField.indexPath = indexPath;
        if (section == 0 && row == 1) {
            cell.titleLabel.text = @"名称";
        
        } else {
            cell.titleLabel.text = section2Array[indexPath.row];
        
        }
        
        
        return cell;
    }else if(section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:imagesCell forIndexPath:indexPath];
//        UIImage *addImag = (UIImage *)[cell viewWithTag:1];
//        UIImage *image1 = (UIImage *)[cell viewWithTag:2];
//        UIImage *image2 = (UIImage *)[cell viewWithTag:3];
        
    }
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
}

#pragma mark - action 
- (void)scanBarAction:(id)sender
{
    ScanBarViewController *scanBarVC = [[ScanBarViewController alloc] init];
    [self.navigationController pushViewController:scanBarVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [textField setReturnKeyType:UIReturnKeyDone];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
