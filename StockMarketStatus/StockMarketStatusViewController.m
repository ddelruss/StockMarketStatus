//
//  StockMarketStatusViewController.m
//  StockMarketStatus
//
//  Created by Damien Del Russo on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StockMarketStatusViewController.h"
#import "StockMarketStatus.h"

@interface StockMarketStatusViewController ()

@end

@implementation StockMarketStatusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    BOOL stockMarketOpen = [StockMarketStatus stockMarketIsOpen];
    if (stockMarketOpen) {
    NSLog(@"viewDidLoad reports stock market is open.");
    } else {
        NSLog(@"viewDidLoad reports stock market closed.");
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    [df setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSDate *testDate = [df dateFromString:@"2012.07.04 12:00"];
    stockMarketOpen = [StockMarketStatus stockMarketOpenOnDate:testDate];
    if (stockMarketOpen) {
        NSLog(@"viewDidLoad reports stock market is open.");
    } else {
        NSLog(@"viewDidLoad reports stock market closed.");
    }

    testDate = [df dateFromString:@"2012.07.03 9:31"];
    stockMarketOpen = [StockMarketStatus stockMarketOpenOnDate:testDate];
    if (stockMarketOpen) {
        NSLog(@"viewDidLoad reports stock market is open.");
    } else {
        NSLog(@"viewDidLoad reports stock market closed.");
    }
    testDate = [df dateFromString:@"2012.07.03 14:01"];
    stockMarketOpen = [StockMarketStatus stockMarketOpenOnDate:testDate];
    if (stockMarketOpen) {
        NSLog(@"viewDidLoad reports stock market is open.");
    } else {
        NSLog(@"viewDidLoad reports stock market closed.");
    }
    testDate = [df dateFromString:@"2012.07.03 9:29"];
    stockMarketOpen = [StockMarketStatus stockMarketOpenOnDate:testDate];
    if (stockMarketOpen) {
        NSLog(@"viewDidLoad reports stock market is open.");
    } else {
        NSLog(@"viewDidLoad reports stock market closed.");
    }
    
    testDate = [df dateFromString:@"2013.12.28 9:45"];
    BOOL stockMarketHoliday = [StockMarketStatus stockMarketHolidayOnDate:testDate];
    if (stockMarketHoliday) {
        NSLog(@"viewDidLoad reports stock market is on holiday.");
    } else {
        NSLog(@"viewDidLoad reports stock market is NOT on holiday");
    }

    
    
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
