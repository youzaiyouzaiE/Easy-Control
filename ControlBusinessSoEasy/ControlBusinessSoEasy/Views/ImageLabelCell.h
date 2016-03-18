//
//  ImageLabelCell.h
//  EasyBusiness
//
//  Created by jiahui on 16/3/17.
//  Copyright © 2016年 YouZai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellTextField.h"
@interface ImageLabelCell : UITableViewCell


@property (weak, nonatomic) IBOutlet CellTextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *mustLable;

@end
