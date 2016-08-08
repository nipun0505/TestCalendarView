//
//  THiPhoneCalendarYearViewController.m
//  HelixCalendarYearView
//
//  Created by Nipun Rajput on 05/08/16.
//  Copyright © 2016 Nipun Rajput. All rights reserved.
//


#define kCollectionViewMonthCellID @"kCollectionViewMonthCellID"
#define kCollectionViewYearHeaderID @"kCollectionViewYearHeaderID"
#define kCollectionViewMinCellSpacing 5

#define kCollectionViewMonthHeaderID @"kCollectionViewMonthHeaderID"
#define kCollectionViewDayCellID @"kCollectionViewDayCellID"
#define kCollectionViewMinCellSpacingDay 0
#define kCollectionViewMonthCustomProperty @"indexPath"


#import "THiPhoneCalendarYearViewController.h"
#import "THiPhoneMonthCollectionViewCell.h"
#import "THiPhoneYearHeaderCollectionReusableView.h"
#import "THiPhoneDayCollectionViewCell.h"
#import "THiPhoneMonthHeaderCollectionReusableView.h"


@interface THiPhoneCalendarYearViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    
}


@property (weak, nonatomic) IBOutlet UICollectionView *yearCollectionView;

@property (nonatomic) NSMutableDictionary *calendarDictionary;

@property (nonatomic) NSMutableArray *yearArray;

@property (nonatomic) NSMutableArray *monthArray;

@property (nonatomic, assign) double numberOfPastFutureYears;

@property (nonatomic, readonly) NSDateFormatter *dayFormatter;

@property (nonatomic, readonly) NSDateFormatter *dateCompareFormatter;


@end


@implementation THiPhoneCalendarYearViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerXIBsForCollectionView];
    
    [self initVariables];
    
    [self setupDatesDatasource];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Init

- (void) initVariables
{
    _dayFormatter = [[NSDateFormatter alloc] init];
    
    _dayFormatter.dateFormat = @"d";
    
    _dateCompareFormatter = [[NSDateFormatter alloc] init];
    
    _dateCompareFormatter.dateFormat = @"ddMMYYYY";
}



#pragma mark - View Datasource & Delegates

- (void) setupDatesDatasource
{
    _calendarDictionary = [NSMutableDictionary dictionary];
    
    _numberOfPastFutureYears = 2;
    
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSInteger calendarUnitsYYYY = NSCalendarUnitYear;
    
    NSDateComponents *currentDateComponents = [currentCalendar components:calendarUnitsYYYY fromDate:currentDate];
    
    NSInteger currentYear = [currentDateComponents year];
    
    NSInteger changingYear = currentYear;
    
    [_calendarDictionary setObject:@"" forKey:[NSNumber numberWithInteger:currentYear]];
    
    _yearArray = [NSMutableArray array];
    
    [_yearArray addObject:[NSNumber numberWithInteger:changingYear]];
    
    for (int i = 0; i < _numberOfPastFutureYears; i ++)
    {
        changingYear ++;
        
        [_calendarDictionary setObject:@"" forKey:[NSNumber numberWithInteger:changingYear]];
        
        [_yearArray addObject:[NSNumber numberWithInteger:changingYear]];
    }
    
    changingYear = currentYear;
    
    for (int i = _numberOfPastFutureYears; i > 0; i --)
    {
        changingYear --;
        
        [_calendarDictionary setObject:@"" forKey:[NSNumber numberWithInteger:changingYear]];
        
        [_yearArray addObject:[NSNumber numberWithInteger:changingYear]];
    }
    
    [_yearArray sortUsingSelector:@selector(compare:)];
    
    NSDateFormatter *monthsFormatter = [[NSDateFormatter alloc] init];
    
    _monthArray = [[monthsFormatter shortMonthSymbols] mutableCopy];
    
    for (NSNumber *year in _yearArray)
    {
        NSMutableDictionary *monthsDictionary = [NSMutableDictionary dictionary];
        
        for (NSString *month in _monthArray)
        {
            //Get dates in a month
            NSInteger yearUnit = [year integerValue];
            
            NSInteger monthUnit = [_monthArray indexOfObject:month];
            
            NSInteger calendarUnitsMMYYYY = (NSCalendarUnitYear | NSCalendarUnitMonth);
            
            NSDateComponents *monthYearComponents = [currentCalendar components:calendarUnitsMMYYYY fromDate:[NSDate date]];
            [monthYearComponents setDay:1];
            [monthYearComponents setMonth:monthUnit+1];
            [monthYearComponents setYear:yearUnit];
            
            NSDate *firstDayOfMonth = [currentCalendar dateFromComponents:monthYearComponents];
            
            NSRange rangeOfDaysInAMonth = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDayOfMonth];
            
            NSDateComponents *resetComponents = [currentCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra) fromDate:firstDayOfMonth];
            [resetComponents setHour:0];
            [resetComponents setMinute:0];
            [resetComponents setSecond:0];
            
            NSMutableArray *datesArrayInMonth = [NSMutableArray array];
            
            for (NSInteger i = rangeOfDaysInAMonth.location; i < NSMaxRange(rangeOfDaysInAMonth); i ++)
            {
                [resetComponents setDay:i];
                NSDate *monthDate = [currentCalendar dateFromComponents:resetComponents];
                [datesArrayInMonth addObject:monthDate];
            }
            
            [monthsDictionary setObject:datesArrayInMonth forKey:[NSNumber numberWithInteger:monthUnit]];
        }
        
        [_calendarDictionary setObject:monthsDictionary forKey:year];
    }
    
    [_yearCollectionView reloadData];
}



#pragma mark - UICollectionViewXIBRegister

- (void) registerXIBsForCollectionView
{
    UINib *monthCellXIB = [UINib nibWithNibName:@"THiPhoneMonthCollectionViewCell" bundle:[NSBundle mainBundle]];
    
    [_yearCollectionView registerNib:monthCellXIB forCellWithReuseIdentifier:kCollectionViewMonthCellID];
    
    UINib *yearHeaderXIB = [UINib nibWithNibName:@"THiPhoneYearHeaderCollectionReusableView" bundle:[NSBundle mainBundle]];
    
    [_yearCollectionView registerNib:yearHeaderXIB forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewYearHeaderID];
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    if ([collectionView isEqual:_yearCollectionView])
    {
        return _yearArray.count;
    }
    
    else
    {
        return 1;
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //Count of months in an year.
    
    if ([collectionView isEqual:_yearCollectionView])
    {
        return [[[_calendarDictionary objectForKey:[_yearArray objectAtIndex:section]] allKeys] count];
    }
    
    else
    {
        return [[[_calendarDictionary objectForKey:[_yearArray objectAtIndex:section]] objectForKey:[NSNumber numberWithInteger:[[(THiPhoneCustomCalendarCollectionView *)collectionView indexPath] row]]] count];
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_yearCollectionView])
    {
        THiPhoneMonthCollectionViewCell *monthCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewMonthCellID forIndexPath:indexPath];
        
        return monthCell;
    }
    
    else
    {
        THiPhoneDayCollectionViewCell *dayCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewDayCellID forIndexPath:indexPath];
        
        NSDate *date = [[[_calendarDictionary objectForKey:[_yearArray objectAtIndex:[[(THiPhoneCustomCalendarCollectionView *)collectionView indexPath] section]]] objectForKey:[NSNumber numberWithInteger:[[(THiPhoneCustomCalendarCollectionView *)collectionView indexPath] row]]] objectAtIndex:indexPath.row];
        
        dayCell.dayLabel.text = [_dayFormatter stringFromDate:date];
        
        if ([[_dateCompareFormatter stringFromDate:date] isEqualToString:[_dateCompareFormatter stringFromDate:[NSDate date]]])
        {
            dayCell.dayLabel.backgroundColor = [UIColor cyanColor];
        }
        
        else
        {
            dayCell.dayLabel.backgroundColor = [UIColor clearColor];
        }
        
        return dayCell;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_yearCollectionView])
    {
        double oneThirdWidth = collectionView.bounds.size.width/3;
        
        if (((oneThirdWidth * 3) + (kCollectionViewMinCellSpacing * 2)) > collectionView.bounds.size.width)
        {
            double howLarge = ((oneThirdWidth * 3) + (kCollectionViewMinCellSpacing * 2)) - collectionView.bounds.size.width;
            
            oneThirdWidth -= howLarge/3;
        }
        
        return CGSizeMake(oneThirdWidth, oneThirdWidth);
    }
    
    else
    {
        return CGSizeMake(collectionView.bounds.size.width/7, collectionView.bounds.size.width/7);
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_yearCollectionView])
    {
        THiPhoneYearHeaderCollectionReusableView *reusableHeader;
        
        if (kind == UICollectionElementKindSectionHeader)
        {
            reusableHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewYearHeaderID forIndexPath:indexPath];
        }
        
        reusableHeader.yearLabel.text = [NSString stringWithFormat:@"%ld", [[_yearArray objectAtIndex:indexPath.section] integerValue]];
        
        return reusableHeader;
    }
    
    else
    {
        THiPhoneMonthHeaderCollectionReusableView *reusableHeader;
        
        if (kind == UICollectionElementKindSectionHeader)
        {
            reusableHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionViewMonthHeaderID forIndexPath:indexPath];
            
            NSDate *anyDateInThisMonth = [[[_calendarDictionary objectForKey:[_yearArray objectAtIndex:[[(THiPhoneCustomCalendarCollectionView *)collectionView indexPath] section]]] objectForKey:[NSNumber numberWithInteger:[[(THiPhoneCustomCalendarCollectionView *)collectionView indexPath] row]]] objectAtIndex:0];
            
            NSCalendar *currentCalendar = [NSCalendar currentCalendar];
            
            NSInteger monthComponent = NSCalendarUnitMonth;
            
            NSDateComponents *mmComponents = [currentCalendar components:monthComponent fromDate:anyDateInThisMonth];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            
            reusableHeader.monthLabel.text = [[[df shortMonthSymbols] objectAtIndex:[mmComponents month]-1] uppercaseString];
        }
        
        return reusableHeader;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if ([collectionView isEqual:_yearCollectionView])
    {
        return CGSizeMake(collectionView.bounds.size.width, 40);
    }
    
    else
    {
        return CGSizeMake(collectionView.bounds.size.width, 25);
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if ([collectionView isEqual:_yearCollectionView])
    {
        return kCollectionViewMinCellSpacing;
    }
    
    else
    {
        return kCollectionViewMinCellSpacingDay;
    }
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual: _yearCollectionView])
    {
        [(THiPhoneMonthCollectionViewCell *) cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
        
//        [[(THiPhoneMonthCollectionViewCell *) cell monthCollectionView] reloadData];
    }
    
    else
    {
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
