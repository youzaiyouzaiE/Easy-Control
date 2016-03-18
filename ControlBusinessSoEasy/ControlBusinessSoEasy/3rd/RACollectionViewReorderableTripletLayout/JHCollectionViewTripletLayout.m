//
//  JHCollectionViewTripletLayout.m
//  SmartLife
//
//  Created by jiahui on 15/4/22.
//  Copyright (c) 2015年 GDT. All rights reserved.
//

#import "JHCollectionViewTripletLayout.h"


@interface JHCollectionViewTripletLayout()

@property (nonatomic, assign) NSInteger numberOfCells;
@property (nonatomic, assign) CGFloat numberOfLines;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat sectionSpacing;
@property (nonatomic, assign) CGSize collectionViewSize;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGRect oldRect;
@property (nonatomic, strong) NSArray *oldArray;
@property (nonatomic, strong) NSMutableArray *largeCellSizeArray;
@property (nonatomic, strong) NSMutableArray *smallCellSizeArray;

@end

@implementation JHCollectionViewTripletLayout

#pragma mark - Over ride flow layout methods

- (void)prepareLayout
{
    [super prepareLayout];
    
    //delegate
    self.delegate = (id<JHCollectionViewDelegateTripletLayout>)self.collectionView.delegate;
    //collection view size
    _collectionViewSize = self.collectionView.bounds.size;
    //some values
    _itemSpacing = 0;
    _lineSpacing = 0;
    _sectionSpacing = 0;
    _insets = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self.delegate respondsToSelector:@selector(minimumInteritemSpacingForCollectionView:)]) {
        _itemSpacing = [self.delegate minimumInteritemSpacingForCollectionView:self.collectionView];
    }
    if ([self.delegate respondsToSelector:@selector(minimumLineSpacingForCollectionView:)]) {
        _lineSpacing = [self.delegate minimumLineSpacingForCollectionView:self.collectionView];
    }
    if ([self.delegate respondsToSelector:@selector(sectionSpacingForCollectionView:)]) {
        _sectionSpacing = [self.delegate sectionSpacingForCollectionView:self.collectionView];
    }
    if ([self.delegate respondsToSelector:@selector(insetsForCollectionView:)]) {
        _insets = [self.delegate insetsForCollectionView:self.collectionView];
    }
}

- (CGFloat)contentHeight
{
    CGFloat contentHeight = 0;
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    CGSize collectionViewSize = self.collectionView.bounds.size;
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if ([self.delegate respondsToSelector:@selector(insetsForCollectionView:)]) {
        insets = [self.delegate insetsForCollectionView:self.collectionView];
    }
    CGFloat sectionSpacing = 0;
    if ([self.delegate respondsToSelector:@selector(sectionSpacingForCollectionView:)]) {
        sectionSpacing = [self.delegate sectionSpacingForCollectionView:self.collectionView];
    }
    CGFloat itemSpacing = 0;
    if ([self.delegate respondsToSelector:@selector(minimumInteritemSpacingForCollectionView:)]) {
        itemSpacing = [self.delegate minimumInteritemSpacingForCollectionView:self.collectionView];
    }
    CGFloat lineSpacing = 0;
    if ([self.delegate respondsToSelector:@selector(minimumLineSpacingForCollectionView:)]) {
        lineSpacing = [self.delegate minimumLineSpacingForCollectionView:self.collectionView];
    }
    
    contentHeight += insets.top + insets.bottom + sectionSpacing * (numberOfSections - 1);
    
    CGFloat lastSmallCellHeight = 0;
    for (NSInteger i = 0; i < numberOfSections; i++) {
        NSInteger numberOfLines = ceil((CGFloat)[self.collectionView numberOfItemsInSection:i] / 3.f);
        
        CGFloat largeCellSideLength = (2.f * (collectionViewSize.width - insets.left - insets.right) - itemSpacing) / 3.f;
        CGFloat smallCellSideLength = (largeCellSideLength - itemSpacing) / 2.f;
        CGSize largeCellSize = CGSizeMake(largeCellSideLength, largeCellSideLength);
        CGSize smallCellSize = CGSizeMake(smallCellSideLength, smallCellSideLength);
        if ([self.delegate respondsToSelector:@selector(collectionView:sizeForLargeItemsInSection:)]) {
            if (!CGSizeEqualToSize([self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:i], JHCollectionViewTripletLayoutStyleSquare)) {
                largeCellSize = [self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:i];
                smallCellSize = CGSizeMake(collectionViewSize.width - largeCellSize.width - itemSpacing - insets.left - insets.right, (largeCellSize.height / 2.f) - (itemSpacing / 2.f));
            }
        }
        lastSmallCellHeight = smallCellSize.height;
        CGFloat largeCellHeight = largeCellSize.height;
        CGFloat lineHeight = numberOfLines * (largeCellHeight + lineSpacing) - lineSpacing;
        contentHeight += lineHeight;
    }
    
    NSInteger numberOfItemsInLastSection = [self.collectionView numberOfItemsInSection:numberOfSections -1];
    if ((numberOfItemsInLastSection - 1) % 3 == 0 && (numberOfItemsInLastSection - 1) % 6 != 0) {
        contentHeight -= lastSmallCellHeight + itemSpacing;
    }
    return contentHeight;
}

- (id<JHCollectionViewDelegateTripletLayout>)delegate
{
    return (id<JHCollectionViewDelegateTripletLayout>)self.collectionView.delegate;
}

- (CGSize)collectionViewContentSize
{
    CGSize contentSize = CGSizeMake(_collectionViewSize.width, 0);
    for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++) {
        NSInteger numberOfLines = ceil((CGFloat)[self.collectionView numberOfItemsInSection:i] / 3.f);
        CGFloat lineHeight = numberOfLines * ([_largeCellSizeArray[i] CGSizeValue].height + _lineSpacing) - _lineSpacing;
        contentSize.height += lineHeight;
    }
    contentSize.height += _insets.top + _insets.bottom + _sectionSpacing * (self.collectionView.numberOfSections - 1);
    NSInteger numberOfItemsInLastSection = [self.collectionView numberOfItemsInSection:self.collectionView.numberOfSections - 1];
    if ((numberOfItemsInLastSection - 1) % 3 == 0 && (numberOfItemsInLastSection - 1) % 6 != 0) {
        contentSize.height -= [_smallCellSizeArray[self.collectionView.numberOfSections - 1] CGSizeValue].height + _itemSpacing;
    }
    return contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect///3333///初始的layout的外观将由该方法返回的
{
    //    BOOL shouldUpdate = [self shouldUpdateAttributesArray];
    //    if (CGRectEqualToRect(_oldRect, rect) && !shouldUpdate) {
    //        return _oldArray;
    //    }
    _oldRect = rect;
    NSMutableArray *attributesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++) {
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < numberOfCellsInSection; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [attributesArray addObject:attributes];
            }
        }
    }
    _oldArray = attributesArray;
    return  attributesArray;
}

//needs override
- (BOOL)shouldUpdateAttributesArray
{
    return NO;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //     NSLog(@"indexPath.section = %d \nindexPath.row = %d",indexPath.section,indexPath.row);
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //cellSize   320 - 20 /3
    CGFloat largeCellSideLength = ((_collectionViewSize.width - _insets.left - _insets.right) - 2.f * _itemSpacing) / 3.f;
    _largeCellSize = CGSizeMake(largeCellSideLength, largeCellSideLength);
    if ([self.delegate respondsToSelector:@selector(collectionView:sizeForLargeItemsInSection:)]) {
        if (!CGSizeEqualToSize([self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:indexPath.section], JHCollectionViewTripletLayoutStyleSquare)) {
            _largeCellSize = [self.delegate collectionView:self.collectionView sizeForLargeItemsInSection:indexPath.section];
        }
    }
    if (!_largeCellSizeArray) {
        _largeCellSizeArray = [NSMutableArray array];
    }
    if (_largeCellSizeArray.count < indexPath.section) {
        _largeCellSizeArray[_largeCellSizeArray.count] = [NSValue valueWithCGSize:_largeCellSize];
    } else
        _largeCellSizeArray[indexPath.section] = [NSValue valueWithCGSize:_largeCellSize];
    
    //section height
    CGFloat sectionHeight = 0;
    for (NSInteger i = 0; i <= indexPath.section - 1; i++) {
        NSInteger cellsCount = [self.collectionView numberOfItemsInSection:i];
        CGFloat largeCellHeight = [_largeCellSizeArray[i] CGSizeValue].height;
        NSInteger lines = ceil((CGFloat)cellsCount / 3.f);
        sectionHeight += lines * (_lineSpacing + largeCellHeight) + _sectionSpacing;
    }
    if (sectionHeight > 0) {
        sectionHeight -= _lineSpacing;
    }
    
    NSInteger line = indexPath.item / 3;
    CGFloat lineSpaceForIndexPath = _lineSpacing * line;
    CGFloat lineOriginY = _largeCellSize.height * line + sectionHeight + lineSpaceForIndexPath + _insets.top;
    CGFloat cellOriginX = _insets.left + (indexPath.item % 3)* (_largeCellSize.width + _itemSpacing);
    attribute.frame =CGRectMake(cellOriginX, lineOriginY, _largeCellSize.width, _largeCellSize.height);
    
    return attribute;
}

@end
