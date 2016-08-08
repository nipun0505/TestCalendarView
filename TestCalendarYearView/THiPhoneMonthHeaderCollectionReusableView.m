//
//  THiPhoneDayHeaderCollectionReusableView.m
//  HelixCalendarYearView
//
//  Created by Nipun Rajput on 08/08/16.
//  Copyright © 2016 Nipun Rajput. All rights reserved.
//


#import "THiPhoneMonthHeaderCollectionReusableView.h"


@implementation THiPhoneMonthHeaderCollectionReusableView


- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _monthLabel.text = @"";
}



@end
