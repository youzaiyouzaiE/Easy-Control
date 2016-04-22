//
//  PhotoGridCell.h
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/22.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoGridCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *selectButton;
@property (nonatomic) NSUInteger index;
@property (nonatomic) BOOL isSelected;


@end
