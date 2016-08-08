//
//  THiPhoneYearCollectionReusableView.m
//  HelixCalendarYearView
//
//  Created by Nipun Rajput on 05/08/16.
//  Copyright © 2016 Nipun Rajput. All rights reserved.
//


#import "THiPhoneYearHeaderCollectionReusableView.h"


@implementation THiPhoneYearHeaderCollectionReusableView


- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _yearLabel.text = @"";
}

@end
