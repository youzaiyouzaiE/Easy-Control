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

+ (void)navigationRightBarButtonForController:(UIViewController *)controller forAction:(SEL)select normalTitle:(NSString *)normal selectedTitle:(NSString *)selected
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:controller action:select forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:normal forState:UIControlStateNormal];
    [button setTitle:selected forState:UIControlStateSelected];
    button.frame = CGRectMake(0, 0, 40, 40);
    controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (void)navigationRightBarButtonForController:(UIViewController *)controller forAction:(SEL)select normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:controller action:select forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    button.frame = CGRectMake(0, 0, 40, 40);
    controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)popViewController:(UIBarButtonItem *)item{
    [[APPLICATION_SHARE getCurrentNavigationController] popViewControllerAnimated:YES];
}

- (void)showMessageToView:(UIView *)view message:(NSString *)message {
    [self showMessageToView:view message:message autoHide:YES];
}

- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHideTime:(NSTimeInterval )interval {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:interval];
    return hud;
}

- (MBProgressHUD *)showMessageToView:(UIView *)view message:(NSString *)message autoHide:(BOOL)autoHide {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    if (autoHide) {
        [hud hide:YES afterDelay:1.0f];
    }
    return hud;
}

- (MBProgressHUD *)showLoadingViewAddToView:(UIView *)view autoHide:(BOOL)autoHide {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //    hud.mode = MBProgressHUDModeIndeterminate;
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

 + (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
     // Create a graphics image context
     UIGraphicsBeginImageContext(newSize);
     // Tell the old image to draw in this new context, with the desired
     // new size
     [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
     // Get the new image from the context
     UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
     // End the context
     UIGraphicsEndImageContext();// Return the new image.
     return newImage;
 }



@end
