//
//  UITools.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/19.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "UITools.h"
#import "MBProgressHUD.h"

@implementation UITools

static UITools *tools = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [UITools new];
    });
    return tools;
}

+ (void)customNavigationBackButtonAndTitle:(NSString *)title forController:(UIViewController *)controller{
    controller.navigationItem.title = title;
    controller.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    controller.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

+ (void)customNavigationBackButtonForController:(UIViewController *)controller{
    controller.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    controller.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

+ (void)customNavigationLeftBarButtonForController:(UIViewController *)controller action:(SEL)select {
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonicon_back.png"] style:UIBarButtonItemStylePlain target:controller action:select];
    controller.navigationItem.leftBarButtonItem = item;
}

- (void)customNavigationLeftBarButtonForController:(UIViewController *)controller {
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonicon_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController:)];
    controller.navigationItem.leftBarButtonItem = item;
}

- (void)popViewController:(UIBarButtonItem *)item{
    [[APPDELEGATE_SHARE getCurrentNavigationController] popViewControllerAnimated:YES];
}

- (void)showMessageToView:(UIView *)view message:(NSString *)message {
    [self showMessageToView:view message:message autoHide:YES];
}

- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    if (autoHide) {
        [hud hide:YES afterDelay:1.5f];
    }
    
    return hud;
}

//获取自适应字的高度？？？
+ (float)getTextViewHeight:(UITextView *)txtView andUIFont:(UIFont *)font andText:(NSString *)txt
{
    float fPadding = 16.0;
    //    CGSize constraint = CGSizeMake(txtView.contentSize.width - 10 - fPadding, CGFLOAT_MAX);
    //    CGSize size = [txt sizeWithFont:font constrainedToSize:constraint lineBreakMode:0];
    //    float fHeight = size.height + 16.0;
    //    return fHeight;
    
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGSize size = [txt boundingRectWithSize:CGSizeMake(txtView.contentSize.width -  10 - fPadding, CGFLOAT_MAX)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:dic
                                    context:nil].size;/////自适应高度
    return size.height;
}



@end
