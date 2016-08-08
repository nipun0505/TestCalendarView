//
//  THiPhoneMonthCollectionViewCell.h
//  HelixCalendarYearView
//
//  Created by Nipun Rajput on 05/08/16.
//  Copyright © 2016 Nipun Rajput. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "THiPhoneCustomCalendarCollectionView.h"


@interface THiPhoneMonthCollectionViewCell : UICollectionViewCell /*<UICollectionViewDelegate, UICollectionViewDataSource>*/
{
    
}


@property (nonatomic, weak) IBOutlet THiPhoneCustomCalendarCollectionView *monthCollectionView;


- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;
@end
