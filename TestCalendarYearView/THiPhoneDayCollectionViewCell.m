//
//  THiPhoneDayCollectionViewCell.m
//  HelixCalendarYearView
//
//  Created by Nipun Rajput on 08/08/16.
//  Copyright © 2016 Nipun Rajput. All rights reserved.
//


#import "THiPhoneDayCollectionViewCell.h"


@implementation THiPhoneDayCollectionViewCell


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _dayLabel.text = @"";
}



@end
