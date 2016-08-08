//
//  THiPhoneMonthCollectionViewCell.m
//  HelixCalendarYearView
//
//  Created by Nipun Rajput on 05/08/16.
//  Copyright © 2016 Nipun Rajput. All rights reserved.
//


#define kCollectionViewMonthHeaderID @"kCollectionViewMonthHeaderID"
#define kCollectionViewDayCellID @"kCollectionViewDayCellID"
#define kCollectionViewMinCellSpacing 0


#import "THiPhoneMonthCollectionViewCell.h"
#import "THiPhoneMonthHeaderCollectionReusableView.h"
#import "THiPhoneDayCollectionViewCell.h"


@implementation THiPhoneMonthCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self registerXIBsForCollectionView];
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _monthCollectionView.indexPath = nil;
    
    _monthCollectionView.dataSource = nil;
    
    _monthCollectionView.delegate = nil;
}



#pragma mark - UICollectionViewXIBRegister

- (void) registerXIBsForCollectionView
{
    UINib *monthHeaderView = [UINib nibWithNibName:@"THiPhoneMonthHeaderCollectionReusableView" bundle:[NSBundle mainBundle]];
    
    [_monthCollectionView registerNib:monthHeaderView forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewMonthHeaderID];
    
    UINib *dayViewCell = [UINib nibWithNibName:@"THiPhoneDayCollectionViewCell" bundle:[NSBundle mainBundle]];
    
    [_monthCollectionView registerNib:dayViewCell forCellWithReuseIdentifier:kCollectionViewDayCellID];
}


- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    _monthCollectionView.dataSource = dataSourceDelegate;
    _monthCollectionView.delegate = dataSourceDelegate;
    _monthCollectionView.indexPath = indexPath;
//    [_monthCollectionView reloadData];
}


- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    return layoutAttributes;
}





@end
