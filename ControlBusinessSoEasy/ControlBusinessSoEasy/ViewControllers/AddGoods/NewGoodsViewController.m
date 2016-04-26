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
#import "MBProgressHUD.h"
#import "EditCategoryViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SDImageCache.h"
#import "MWCommon.h"
#import "MWPhotoBrowser.h"
#import "PhotosGridViewController.h"
//typedef NS_ENUM(NSUInteger, sectionType) {
//    goodsInfomationSection,
//    goods,
//    <#MyEnumValueC#>,
//};


@interface NewGoodsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate,UITextViewDelegate>{
    NSArray *section1TitleArray;
    NSArray *section2TitleArray;
    NSArray *section0KeysArr;
    NSArray *section1KeysArr;
    NSArray *section2KeysArr;
    
    NSArray *section0ImageArr;
    NSArray *section1ImageArr;
    
    NSMutableDictionary *dicTextFieldInfo;
    
    __block NSString *categoryName;
    __block NSString *_authorName;////
    BOOL keyboardShow;
    
    NSString *imageDocument;
    UIActionSheet *sheetAction;
    UIActionSheet *deleteSheetAction;
    NSInteger tapSelectItem;

    BOOL hasFristImage;
    BOOL hasSecondImage;
    BOOL hasThirdImage;
    
    NSMutableDictionary *imageDictionary;
    UIImagePickerController *imagePickerController;
    
    BOOL isSaveCurrentBean;
    __weak IBOutlet UIView *bottomView;
    
    NSIndexPath *_editingIndexPath;
    CGRect tableViewFrame;
    NSMutableArray *_assets;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottomConstraint;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) ALAssetsLibrary *ALAssetsLibrary;

@end

@implementation NewGoodsViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideAction:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backItemAction:)];
    section1TitleArray = @[@"进价",@"售价",@"规格",@"库存"];
    section2TitleArray = @[@"供应商",@"备注"];
    
    section0KeysArr = @[@"goodsIDCode",@"name",@"category"];
    section1KeysArr = @[@"inPrice",@"outPrice",@"standard",@"stock",@"author"];
    section2KeysArr = @[@"note"];
    
    section0ImageArr = @[@"NG_code",@"NG_name",@"NG_category"];
    section1ImageArr = @[@"NG_inPrice",@"NG_outPrice",@"NG_standard",@"NG_stock",@"NG_Author"];
    
    dicTextFieldInfo = [NSMutableDictionary dictionary];
    imageDictionary = [NSMutableDictionary dictionary];
//    _photos = [NSMutableArray array];
//    _thumbs = [NSMutableArray array];
    
    if (_isEditType) {
        self.navigationItem.title = _contentBean.name;
        [self dictionaryDataMapping];
        categoryName = _contentBean.category;
        _authorName = _contentBean.author;
        imageDocument = _contentBean.imagePath;
        [self imageDictionaryContentMapping];
        isSaveCurrentBean = YES;
        
        bottomView.hidden = YES;
        _tableBottomConstraint.constant = 0;
        [self.view needsUpdateConstraints];
        [UITools navigationRightBarButtonForController:self forAction:@selector(updateBean:) normalTitle:@"保存" selectedTitle:nil];
    } else {
        self.navigationItem.title = @"添加商品";
        imageDocument = [AppData random_uuid];
        tapSelectItem = -1;
    }
}

- (void)dictionaryDataMapping {
    [self safetySetDictionaryValue:_contentBean.goodsIDCode forKey:section0KeysArr[0] WithDic:dicTextFieldInfo];
    [self safetySetDictionaryValue:_contentBean.name forKey:section0KeysArr[1] WithDic:dicTextFieldInfo];
    [self safetySetDictionaryValue:_contentBean.category forKey:section0KeysArr[2] WithDic:dicTextFieldInfo];
    [self safetySetDictionaryValue:_contentBean.inPrice forKey:section1KeysArr[0] WithDic:dicTextFieldInfo];
    [self safetySetDictionaryValue:_contentBean.outPrice forKey:section1KeysArr[1] WithDic:dicTextFieldInfo];
    [self safetySetDictionaryValue:_contentBean.standard forKey:section1KeysArr[2] WithDic:dicTextFieldInfo];
    [self safetySetDictionaryValue:_contentBean.stock forKey:section1KeysArr[3] WithDic:dicTextFieldInfo];
    [self safetySetDictionaryValue:_contentBean.author forKey:section1KeysArr[4] WithDic:dicTextFieldInfo];
    [self safetySetDictionaryValue:_contentBean.note forKey:section2KeysArr[0] WithDic:dicTextFieldInfo];
}

- (void)safetySetDictionaryValue:(id)value forKey:(id)key WithDic:(NSDictionary *)dic{
    NSString *newValue = @"";
    if (value == nil) {
        [dic setValue:newValue forKey:key];
    } else
        [dic setValue:value forKey:key];
}

- (void)imageDictionaryContentMapping {
    NSString *smallFilePath = [AppData getCachesDirectorySmallDocumentPath:imageDocument];
    NSArray *smallImageParthArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:smallFilePath error:nil];
    [smallImageParthArray enumerateObjectsUsingBlock:^(NSString *parth, NSUInteger idx, BOOL * stop) {
        UIImage *image = [UIImage imageWithContentsOfFile:[smallFilePath stringByAppendingPathComponent:parth]];
//        NSRange range = [parth rangeOfString:@"."];
        NSString *key = [NSString stringWithFormat:@"%d",idx];
        if (idx == 0) {
            hasFristImage = YES;
        } else if (idx == 1) {
            hasSecondImage = YES;
        } else if (idx == 2) {
            hasThirdImage = YES;
        }
        [imageDictionary setObject:image forKey:key];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotificationCenter
- (void)keyboardShowAction:(NSNotification *)notification {
    if (keyboardShow ) {
        return ;
    }
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    tableViewFrame = _tableView.frame;
    if (_isEditType) {
        _tableView.frame = CGRectMake(tableViewFrame.origin.x, tableViewFrame.origin.y, tableViewFrame.size.width, tableViewFrame.size.height - keyboardSize.height);
    } else
        _tableView.frame = CGRectMake(tableViewFrame.origin.x, tableViewFrame.origin.y, tableViewFrame.size.width, tableViewFrame.size.height - keyboardSize.height + 50);
    
    [self.tableView scrollToRowAtIndexPath:_editingIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
     keyboardShow = YES;
}

- (void)keyboardHideAction:(NSNotification *)sender {
    if (!keyboardShow) {
        return ;
    }
    _tableView.frame = tableViewFrame;
    keyboardShow = NO;
}

#pragma mark - action 
-(void)backItemAction:(id)sender {
    if (!isSaveCurrentBean) {
        [self deleteDocumentAllImages];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateBean:(id)sender
{
    [self.view endEditing:YES];
    _contentBean.goodsIDCode = dicTextFieldInfo[section0KeysArr[0]];
    _contentBean.name = dicTextFieldInfo[section0KeysArr[1]];
    _contentBean.category = categoryName;
    _contentBean.inPrice = dicTextFieldInfo[section1KeysArr[0]];
    _contentBean.outPrice = dicTextFieldInfo[section1KeysArr[1]];
    _contentBean.standard = dicTextFieldInfo[section1KeysArr[2]];
    _contentBean.stock = dicTextFieldInfo[section1KeysArr[3]];
    _contentBean.author = dicTextFieldInfo[section1KeysArr[4]];
    _contentBean.note = dicTextFieldInfo[section2KeysArr[0]];
    _contentBean.imagePath = imageDocument;
    if ([[GoodsInfoDao shareInstance] updateBean:_contentBean]) {
        [[UITools shareInstance] showMessageToView:self.view message:@"保存成功" autoHideTime:0.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.modifyBlock(_contentBean);
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    /// pop Navigation and update tableView
}

- (void)scanBarAction:(id)sender {////扫描
    ScanBarViewController *scanBarVC = [[ScanBarViewController alloc] init];
    [self.navigationController pushViewController:scanBarVC animated:YES];
}

- (IBAction)completeAction:(UIButton *)sender {
    if (![self chickInPutInformation]) {
        return ;
    }
    [self saveCurrentGoodInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)continueAddAction:(UIButton *)sender {///继续添加
    if (![self chickInPutInformation]) {
        return ;
    }
    MBProgressHUD *hud = [[UITools shareInstance] showLoadingViewAddToView:self.view autoHide:NO];
    [self saveCurrentGoodInfo];
    [self clearData];
    [self.tableView reloadData];
    imageDocument = [AppData random_uuid];
    [hud hide:YES];
}

-(BOOL)chickInPutInformation {
    NSString *name = dicTextFieldInfo[section0KeysArr[1]];
    if ( name == nil || [name isEqualToString:@""] || name.length < 1) {
        [[UITools shareInstance] showMessageToView:self.view message:@"请输入商品名称"];
        return NO;
    }
    if (categoryName == nil || [categoryName isEqualToString:@""] || [categoryName length] == 0) {
        [[UITools shareInstance] showMessageToView:self.view message:@"请选择商品分类"];
        return NO;
    }
    if (dicTextFieldInfo[section1KeysArr[1]] == nil) {
        [[UITools shareInstance] showMessageToView:self.view message:@"请输入商品售价"];
        return NO;
    }
    return YES;
}

- (void)fristButtonAction:(id )sender {
    tapSelectItem = 0;
    if (hasFristImage) {
        [self createDeleteSheetAction];
    } else
        [self createSheetAction];
}

- (void)secondButtonAction:(id )sender {
    tapSelectItem = 1;
    if (hasSecondImage) {
        [self createDeleteSheetAction];
    } else
        [self createSheetAction];
}

- (void)thirdButtonAction:(id )sender {
    tapSelectItem = 2;
    if (hasThirdImage) {
        [self createDeleteSheetAction];
    } else
        [self createSheetAction];
}

- (void)createSheetAction {
    if (!sheetAction) {
        sheetAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"cancel") destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    [sheetAction showInView:self.view];
}

- (void)createDeleteSheetAction {
    if (!deleteSheetAction) {
        deleteSheetAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",@"删除", nil];
        deleteSheetAction.destructiveButtonIndex = 2;
    }
    [deleteSheetAction showInView:self.view];
}

#pragma mark -DB operation
- (void)saveCurrentGoodInfo {
    GoodsInfoBean *bean = [GoodsInfoBean new];
    bean.userID = [UserInfo shareInstance].userId;
    bean.goodsIDCode = dicTextFieldInfo[section0KeysArr[0]];
    bean.name = dicTextFieldInfo[section0KeysArr[1]];
    bean.category = categoryName;
    bean.inPrice = dicTextFieldInfo[section1KeysArr[0]];
    bean.outPrice = dicTextFieldInfo[section1KeysArr[1]];
    bean.standard = dicTextFieldInfo[section1KeysArr[2]];
    bean.stock = dicTextFieldInfo[section1KeysArr[3]];
    bean.author = dicTextFieldInfo[section1KeysArr[4]];
    bean.note = dicTextFieldInfo[section2KeysArr[0]];
    bean.imagePath = imageDocument;
    [[GoodsInfoDao shareInstance] insertBean:bean];
    isSaveCurrentBean = YES;
}

- (void)deleteDocumentAllImages {
    [self removeImageFileAllContents:YES ];
}

- (void)removeImageFileAllContents:(BOOL )isRemoveAll {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (isRemoveAll) {///移除所有图片
            NSError *error = nil;
            NSString *allFilePath = [AppData getCachesDirectoryDocumentPath:imageDocument];
            if (![[NSFileManager defaultManager] removeItemAtPath:allFilePath error:&error]) {
                NSLog(@"error :%@",error.localizedDescription);
            }
        } else {////移除选中的
            NSString *bigFilePath = [AppData getCachesDirectoryBigDocumentPath:imageDocument];
            NSString *smallFilePath = [AppData getCachesDirectorySmallDocumentPath:imageDocument];
            NSString *saveToImagePath = [bigFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.JPG",(long)tapSelectItem]];
            NSError *error = nil;
            if (![[NSFileManager defaultManager] removeItemAtPath:saveToImagePath error:&error]) {
                NSLog(@"remove %ld.JPG error :%@",(long)tapSelectItem,error.localizedDescription);
            }
            
            NSString *smallSaveToImagePath = [smallFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.JPG",(long)tapSelectItem]];
            NSError *smallError = nil;
            if (![[NSFileManager defaultManager] removeItemAtPath:smallSaveToImagePath error:&smallError]) {
                NSLog(@"remove small %ld.JPG Error :%@",(long)tapSelectItem,smallError.localizedDescription);
            }
        }
    });
}

#pragma mark - clearData
- (void)clearData {
    _photos = nil;
    [dicTextFieldInfo removeAllObjects];
    tapSelectItem = -1;
    imageDocument = nil;
    hasFristImage = NO;
    hasSecondImage = NO;
    hasThirdImage = NO;
    [imageDictionary removeAllObjects];
    isSaveCurrentBean = NO;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NSLog(@"添加 Is cancelled: %i", [context isCancelled]);
        if (![context isCancelled]) {
            if (!isSaveCurrentBean) {
                [self deleteDocumentAllImages];
            }
        }
    }];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 || buttonIndex == 1) {
        if (!imagePickerController) {
            imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
            imagePickerController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
            imagePickerController.navigationBar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
        }
    }
    if (buttonIndex == 0) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
    } else if(buttonIndex == 1) {
        if (NSClassFromString(@"PHAsset")) {
            PhotosGridViewController *photoGridVC = [[PhotosGridViewController alloc] init];
            UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:photoGridVC];
            [self presentViewController:navigationVC animated:YES completion:^{
                
            }];
            
        } else {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
        }
    } else if((actionSheet == deleteSheetAction) && (buttonIndex == actionSheet.destructiveButtonIndex)) {
        [imageDictionary removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)tapSelectItem]];
        [self deleteOrAddIamgeForIdent:tapSelectItem isAddedType:NO];////delete
        //////delete in file image
        [self removeImageFileAllContents:NO];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:_tableView.numberOfSections -1]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *imageSmall = [UITools imageWithImageSimple:image scaledToSize:CGSizeMake(240, 240)];
    [imageDictionary setObject:imageSmall forKey:[NSString stringWithFormat:@"%ld",(long)tapSelectItem]];
    [self deleteOrAddIamgeForIdent:tapSelectItem isAddedType:YES];//////added
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = [AppData getCachesDirectoryBigDocumentPath:imageDocument];
        NSString *saveToImagePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.JPG",(long)tapSelectItem]];
      
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        if ([imageData writeToFile:saveToImagePath atomically:NO]) {
//             NSLog(@"存入文件 成功！");
        } else {
             NSLog(@"图片未能存入");
        }
        
        NSString *smallfilePath = [AppData getCachesDirectorySmallDocumentPath:imageDocument];
        NSString *smallSaveToImagePath = [smallfilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.JPG",(long)tapSelectItem]];
        NSData *smallImageData = UIImageJPEGRepresentation(imageSmall, 1);
        if ([smallImageData writeToFile:smallSaveToImagePath atomically:NO]) {
            //             NSLog(@"存入文件 成功！");
        } else {
            NSLog(@"图片未能存入");
        }
    });
    [self.navigationController dismissViewControllerAnimated: YES completion:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:_tableView.numberOfSections -1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

- (void)deleteOrAddIamgeForIdent:(NSInteger )seleect isAddedType:(BOOL)has {
    switch (seleect) {
        case 0:
            hasFristImage = has;
            break;
            
        case 1:
            hasSecondImage = has;
            break;
            
        case 2:
            hasThirdImage = has;
            break;
            
        default:
            break;
    }
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

#pragma mark - UITableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"商品信息";
    } else if (section == 1) {
        return @"";
    }  else if (section == 2) {
        return @"备注";
    }else if (section == 3) {
        return @"添加图片";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return section0KeysArr.count;
    } else if (section == 1) {
        return section1KeysArr.count;
    } else if (section == 2) {
        return section2KeysArr.count;
    } else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3)
        return 98;
    else if (indexPath.section == 2) {
        return 70;
    } else
        return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *barCodeCell = @"BarCodeCell";
    static NSString *nameCell = @"NameCell";
    static NSString *classCell = @"LabelCell";
    static NSString *imagesCell = @"TernaryIamgeCell";
    static NSString *noteCell = @"noteCellIdentifier";
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
            [cell.titleImage setImage:[UIImage imageNamed:section0ImageArr[row]]];
            cell.titleLabel.text = @"名称";
            cell.textField.indexPath = indexPath;
            cell.textField.text = dicTextFieldInfo[section0KeysArr[indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:classCell forIndexPath:indexPath];
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
            [imageView setImage:[UIImage imageNamed:section0ImageArr[row]]];
            UILabel *nameLabel = (UILabel *)[cell viewWithTag:2];
            nameLabel.text = @"分类";
            UILabel *mustLabel = (UILabel *)[cell viewWithTag:3];
            mustLabel.hidden = NO;
            UILabel *CategoryLabel = (UILabel *)[cell viewWithTag:4];
            if (categoryName) {
                CategoryLabel.text = categoryName;
            } else
                CategoryLabel.text = @"选择分类";
            return cell;
        }
    } else if(section == 1) {
        if (row != 4) {
            ImageLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:nameCell];
            if (!cell) {
                cell = (ImageLabelCell *)[[[NSBundle mainBundle] loadNibNamed:@"ImageLabelCell" owner:self options:nil] objectAtIndex:0];
                cell.textField.delegate = self;
            }
            [cell.titleImage setImage:[UIImage imageNamed:section1ImageArr[row]]];
            cell.textField.indexPath = indexPath;
            cell.titleLabel.text = section1TitleArray[row];
            if (row == 0 || row == 1 || row == 3) {
                cell.textField.text = [dicTextFieldInfo[section1KeysArr[row]] stringValue];
            } else
                cell.textField.text = dicTextFieldInfo[section1KeysArr[row]];
            if (row == 1) {
                cell.mustLable.hidden = NO;
            } else
                cell.mustLable.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:classCell forIndexPath:indexPath];
            UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
            [imageView setImage:[UIImage imageNamed:section1ImageArr[row]]];
            UILabel *nameLabel = (UILabel *)[cell viewWithTag:2];
            nameLabel.text = @"供应商";
            UILabel *mustLabel = (UILabel *)[cell viewWithTag:3];
            mustLabel.hidden = YES;
            
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:4];
            if (_authorName && ![_authorName isEqualToString:@""]) {
                titleLabel.text = _authorName;
            } else
                titleLabel.text = @"选择供应商";
            return cell;
        }
    } else if(section == 2) {////备注
        cell = [tableView dequeueReusableCellWithIdentifier:noteCell forIndexPath:indexPath];
        UITextView *text = (UITextView *)[cell viewWithTag:1];
        text.layer.borderWidth = 1;
        text.layer.borderColor = [UIColor grayColor].CGColor;
        text.layer.cornerRadius = 3;
        text.text = dicTextFieldInfo[section2KeysArr[indexPath.row]];
        
    }else if(section == 3) {/////添加图片
        cell = [tableView dequeueReusableCellWithIdentifier:imagesCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *button1 = (UIButton *)[cell viewWithTag:1];
        UIButton *button2 = (UIButton *)[cell viewWithTag:2];
        UIButton *button3 = (UIButton *)[cell viewWithTag:3];
        [button1 addTarget:self action:@selector(fristButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button2 addTarget:self action:@selector(secondButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button3 addTarget:self action:@selector(thirdButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [button1 setBackgroundImage:(([imageDictionary objectForKey:@"0"])?[imageDictionary objectForKey:@"0"]:[UIImage imageNamed:@"NOPhoto"]) forState:UIControlStateNormal];
        [button2 setBackgroundImage:(([imageDictionary objectForKey:@"1"])?[imageDictionary objectForKey:@"1"]:[UIImage imageNamed:@"NOPhoto"]) forState:UIControlStateNormal];
        [button3 setBackgroundImage:(([imageDictionary objectForKey:@"2"])?[imageDictionary objectForKey:@"2"]:[UIImage imageNamed:@"NOPhoto"]) forState:UIControlStateNormal];
        
        
        return cell;
    }
   return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self performSegueWithIdentifier:@"pushToAddCategoryVC" sender:self];
    } else if (indexPath.section == 1 && indexPath.row == 4) {
        [self performSegueWithIdentifier:@"pushToSelectAuthor" sender:self];
    }  else if (indexPath.section == 3 && indexPath.row == 0) {
        if (imageDictionary.allKeys.count != 0) {
              NSMutableArray *photos = [NSMutableArray array];
            NSString *imageDocumetPath = [AppData getCachesDirectoryBigDocumentPath:imageDocument];
            NSArray *sourceArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imageDocumetPath error:nil];
            for (NSString *sourceStr in sourceArray) {
                NSString *bigImagePath = [imageDocumetPath stringByAppendingPathComponent:sourceStr];
                UIImage *image = [UIImage imageWithContentsOfFile:bigImagePath];
                [photos addObject:[MWPhoto photoWithImage:image]];
            }
            _photos = photos;
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = NO;
            browser.displayNavArrows = NO;
            browser.displaySelectionButtons = NO;
            browser.alwaysShowControls = NO;
            browser.zoomPhotosToFill = YES;
            browser.enableGrid = NO;
            browser.startOnGrid = NO;
            browser.enableSwipeToDismiss = YES;
            browser.autoPlayOnAppear = NO;
            [browser setCurrentPhotoIndex:0];
            [self.navigationController pushViewController:browser animated:YES];
        }
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
    } else if ([segue.identifier isEqualToString:@"pushToSelectAuthor"]) {/////分类
        EditCategoryViewController *authorLiseVC = (EditCategoryViewController *)[segue destinationViewController];
        authorLiseVC.categoryType = author;
        authorLiseVC.updateOrDeleteBlock = ^(BOOL isDelete, NSString *authorName) {
            _authorName = authorName;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
//    return [[_selections objectAtIndex:index] boolValue];
//}
//
//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}
//
//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
//    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
//}
//
//- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
//    // If we subscribe to this method we must dismiss the view controller ourselves
//    NSLog(@"Did finish modal presentation");
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CellTextField *cellTextField = nil;
    if ([textField isKindOfClass:[CellTextField class]]) {
        cellTextField = (CellTextField *)textField;
        NSIndexPath *indexPath = cellTextField.indexPath;
        _editingIndexPath = indexPath;
        if ((indexPath.section == 1) && (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3)) {
            [textField setKeyboardType:UIKeyboardTypeDecimalPad];
            return  YES;
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
            if ([textField.text isEqualToString:@"0"] && [string isEqualToString:@"0"]) {
                return NO;
            }
            if (textField.text.length == 0 && [string isEqualToString:@"."]) {
                return NO;
            }
            if ([textField.text rangeOfString:@"."].location != NSNotFound) {////has point
                if ([string isEqualToString:@"."]) {
                    return  NO;
                }
                if ((textField.text.length - 3 == [textField.text rangeOfString:@"."].location) && ![string isEqualToString:@""]) {
                    [[UITools shareInstance] showMessageToView:self.view message:@"最多输入两位小数"];
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
        if (row == 0 || row == 1 || row == 3) {
            valueNum = [NSNumber numberWithDouble:textfield.text.doubleValue];
            dicTextFieldInfo[dictionKey] = valueNum;
            return ;
        }
    }
    dicTextFieldInfo[dictionKey] = textfield.text;
}

#pragma mark - UITextViewDelegate 
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _editingIndexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *dictionKey = section2KeysArr[0];
    dicTextFieldInfo[dictionKey] = textView.text;
    
}

@end
