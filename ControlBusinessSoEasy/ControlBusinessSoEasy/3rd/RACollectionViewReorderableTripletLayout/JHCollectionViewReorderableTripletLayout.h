//
//  JHCollectionViewReorderableTripletLayout.h
//  SmartLife
//
//  Created by jiahui on 15/4/22.
//  Copyright (c) 2015年 GDT. All rights reserved.
//

#import "JHCollectionViewTripletLayout.h"

@protocol JHCollectionViewReorderableTripletLayoutDataSource <JHCollectionViewTripletLayoutDatasource>

@optional

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath;
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath;

@end

@protocol JHCollectionViewDelegateReorderableTripletLayout <JHCollectionViewDelegateTripletLayout>

@optional

- (CGFloat)reorderingItemAlpha:(UICollectionView * )collectionview; //Default 0.
- (UIEdgeInsets)autoScrollTrigerEdgeInsets:(UICollectionView *)collectionView; //Sorry, has not supported horizontal scroll.
- (UIEdgeInsets)autoScrollTrigerPadding:(UICollectionView *)collectionView;

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;

@end



@interface JHCollectionViewReorderableTripletLayout : JHCollectionViewTripletLayout <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<JHCollectionViewDelegateReorderableTripletLayout> delegate;
@property (nonatomic, assign) id<JHCollectionViewReorderableTripletLayoutDataSource> datasource;
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGesture;


@end
