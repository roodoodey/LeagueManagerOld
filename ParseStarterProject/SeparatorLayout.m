//
//  SeparatorLayout.m
//  LeagueManager
//
//  Created by Mathieu Skulason on 17/07/15.
//  Copyright (c) 2015 Mathieu Skulason. All rights reserved.
//

#import "SeparatorLayout.h"

@implementation SeparatorLayout

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *baseLayoutAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * layoutAttributes = [baseLayoutAttributes mutableCopy];
    
    NSArray *visibleIndexPaths = [self indexPathsOfSeparatorsInRect:rect]; // will implement below
    
    NSMutableArray *decorationAttributes = [NSMutableArray array];
    
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForDecorationViewOfKind:@"Separator" atIndexPath:indexPath];
        [layoutAttributes addObject:attributes];
    }
    
    return layoutAttributes;
}

- (NSArray*)indexPathsOfSeparatorsInRect:(CGRect)rect {
    NSInteger firstCellIndexToShow = floorf(rect.origin.y / self.itemSize.height);
    NSInteger lastCellIndexToShow = floorf((rect.origin.y + CGRectGetHeight(rect)) / self.itemSize.height);
    NSInteger countOfItems = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    
    NSMutableArray* indexPaths = [NSMutableArray new];
    for (int i = MAX(firstCellIndexToShow, 0); i <= lastCellIndexToShow; i++) {
        if (i < countOfItems) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    return indexPaths;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    CGFloat decorationOffset = (indexPath.row + 1) * self.itemSize.height + indexPath.row * self.minimumLineSpacing;
    layoutAttributes.frame = CGRectMake(0.0, decorationOffset, self.collectionViewContentSize.width, self.minimumLineSpacing);
    layoutAttributes.zIndex = 1000;
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath {
    UICollectionViewLayoutAttributes *layoutAttributes =  [self layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:decorationIndexPath];
    return layoutAttributes;
}

@end
