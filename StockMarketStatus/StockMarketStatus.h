//
//  StockMarketStatus.h
//  StockMarketStatus
//
//  Created by Damien Del Russo on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockMarketStatus : NSObject

+ (BOOL)stockMarketIsOpen;
+ (BOOL)stockMarketIsOpenToday; // not necessarily right now.
+ (BOOL)stockMarketIsClosed;
+ (BOOL)stockMarketIsAHoliday;
+ (BOOL)stockMarketOpenOnDate:(NSDate*)aDate;
+ (BOOL)stockMarketClosedOnDate:(NSDate*)aDate;
+ (BOOL)stockMarketHolidayOnDate:(NSDate*)aDate;
+ (NSDate*)stockMarketClose:(NSDate*)aDate;
+ (NSArray*)stockMarketHolidays;
+ (NSDateFormatter*)stockMarketStandardDateFormatter;

@end
