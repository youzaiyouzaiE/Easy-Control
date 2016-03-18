//
//  JHCollectionViewTripletLayout.h
//  SmartLife
//
//  Created by jiahui on 15/4/22.
//  Copyright (c) 2015年 GDT. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JHCollectionViewTripletLayoutStyleSquare CGSizeZero

@protocol JHCollectionViewDelegateTripletLayout <UICollectionViewDelegateFlowLayout>

@optional

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForLargeItemsInSection:(NSInteger)section; //Default to automaticaly grow square !
- (UIEdgeInsets)insetsForCollectionView:(UICollectionView *)collectionView;
- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView;
- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView;
- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView;

@end

@protocol JHCollectionViewTripletLayoutDatasource <UICollectionViewDataSource>

@end

@interface JHCollectionViewTripletLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) id<JHCollectionViewDelegateTripletLayout> delegate;
@property (nonatomic, assign) id<JHCollectionViewTripletLayoutDatasource> datasource;
@property (nonatomic, assign, readonly) CGSize largeCellSize;

- (BOOL)shouldUpdateAttributesArray; //needs override
- (CGFloat)contentHeight;
@end
