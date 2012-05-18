//
//  StockMarketStatus.m
//  StockMarketStatus
//
//  Created by Damien Del Russo on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StockMarketStatus.h"

#define kStockMarketStatusTimeAllDay @"01"

@implementation StockMarketStatus

+ (NSDateFormatter*)stockMarketStandardDateFormatter {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
    df.dateFormat = @"yyyy.MM.dd HH:mm";
    return  df;
}

+ (NSArray*)stockMarketHolidays { // needs to occasionally be updated for variable holidays
    NSDateFormatter *df = [self stockMarketStandardDateFormatter];
    return [NSArray arrayWithObjects:
            [df dateFromString:@"2012.12.25 01:00"],
            [df dateFromString:@"2012.05.28 01:00"],
            [df dateFromString:@"2012.07.03 13:00"],
            [df dateFromString:@"2012.07.04 01:00"],
            [df dateFromString:@"2012.09.03 01:00"],
            [df dateFromString:@"2012.11.22 01:00"],
            [df dateFromString:@"2012.11.23 13:00"],
            [df dateFromString:@"2012.12.24 13:00"],
            [df dateFromString:@"2012.12.25 01:00"],
            [df dateFromString:@"2013.01.01 01:00"],
            [df dateFromString:@"2013.01.21 01:00"],
            [df dateFromString:@"2013.02.18 01:00"],
            [df dateFromString:@"2013.03.29 01:00"],
            [df dateFromString:@"2013.05.27 01:00"],
            [df dateFromString:@"2013.07.03 13:00"],
            [df dateFromString:@"2013.07.04 01:00"],
            [df dateFromString:@"2013.09.02 01:00"],
            [df dateFromString:@"2013.11.28 01:00"],
            [df dateFromString:@"2013.11.29 13:00"],
            [df dateFromString:@"2013.12.24 13:00"],
            [df dateFromString:@"2013.12.25 01:00"],
            nil];
}

+ (BOOL)passTimeThreshold:(NSDate *)aDate { // returns true if between 9:30 am and 4 pm EST.
    NSDateFormatter *df = [self stockMarketStandardDateFormatter];
    [df setDateFormat:@"HH"];
    int hours = [[df stringFromDate:aDate] intValue];
    if (hours < 16) {
        if (hours > 9) {
            return YES;
        } else { // ==9
            [df setDateFormat:@"mm"];
            int minutes = [[df stringFromDate:aDate] intValue];
            if (minutes >= 30) {
                return YES;
            }
        }
    }
    return NO;
}

+ (BOOL)dayOfWeekTest:(NSDate *)aDate { // returns YES on M-F
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:aDate];
    
    NSInteger weekday = [weekdayComponents weekday];
    // weekday 1 = Sunday for Gregorian calendar
    return weekday != 1 && weekday != 7;
}

+ (BOOL)holidayTest:(NSDate *)aDate {
    NSDateFormatter *df = [self stockMarketStandardDateFormatter];
    
    BOOL __block answer = YES;

    [[self stockMarketHolidays] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [df setDateFormat:@"yyyy.MM.dd"];
        if ([[df stringFromDate:obj] isEqualToString:[df stringFromDate:aDate]]) {  // holiday tests positive
            [df setDateFormat:@"HH"];
            if ([[df stringFromDate:obj] isEqualToString:kStockMarketStatusTimeAllDay]) {  // all day holiday
                answer = NO;
                *stop = YES;
            } else {  // this is a holiday
                *stop = YES;
                int hours = [[df stringFromDate:aDate] intValue];
                if (hours < 13) {
                    if (hours > 9) {
                    } else { // ==9
                        [df setDateFormat:@"mm"];
                        int minutes = [[df stringFromDate:aDate] intValue];
                        if (minutes < 30) {
                            answer = NO;
                        }
                    }
                } else {
                    answer = NO;
                }
            }
        }
    }];
    return answer;
}

+ (BOOL)stockMarketOpenOnDate:(NSDate *)aDate {
    return [self passTimeThreshold:aDate] && [self dayOfWeekTest:aDate] && [self holidayTest:aDate];
}

+ (BOOL)stockMarketIsOpen {
    return [self stockMarketOpenOnDate:[NSDate date]];
}
  
+ (BOOL)stockMarketIsOpenToday {
    NSDateFormatter *df = [self stockMarketStandardDateFormatter];
    [df setDateFormat:@"yyyy.MM.dd"];
    NSString *today = [[df stringFromDate:[NSDate date]] stringByAppendingString:@" 12:00"]; // always open at noon
    [df setDateFormat:@"yyyy.MM.dd HH:mm"];

    return [self stockMarketOpenOnDate:[df dateFromString:today]];
}

+ (BOOL)stockMarketIsClosed {
    return ![self stockMarketIsOpen];
}

+ (BOOL)stockMarketClosedOnDate:(NSDate *)aDate {
    return ![self stockMarketOpenOnDate:aDate];
}

+ (BOOL)stockMarketHolidayOnDate:(NSDate *)aDate {
    NSDateFormatter *df = [self stockMarketStandardDateFormatter];
    [df setDateFormat:@"yyyy.MM.dd"];
    
    BOOL __block answer = NO;
    
    [[self stockMarketHolidays] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[df stringFromDate:obj] isEqualToString:[df stringFromDate:aDate]]) {  // holiday tests positive
            answer = YES;
            *stop = YES;
        }
    }];
    return answer;
}

+ (BOOL)stockMarketIsAHoliday {
    return [self stockMarketHolidayOnDate:[NSDate date]];
}

+ (NSDate*)stockMarketClose:(NSDate *)aDate {
    NSDateFormatter *df = [self stockMarketStandardDateFormatter];
    df.dateFormat = @"yyyy.MM.dd";
    NSString *theDate = [df stringFromDate:aDate];
    NSString *hours = @"00";
    NSString *minutes = @"00";
    if ([self dayOfWeekTest:aDate]) {
        BOOL __block earlyClose = NO;
        BOOL __block holiday = NO;
        [[self stockMarketHolidays] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            df.dateFormat = @"yyyy.MM.dd";
            if ([[df stringFromDate:obj] isEqualToString:theDate]) {  // holiday tests positive
                [df setDateFormat:@"HH"];
                holiday = YES;
                if (![[df stringFromDate:obj] isEqualToString:kStockMarketStatusTimeAllDay]) {
                    earlyClose = YES;
                } 
                *stop = YES;
            }
        }];
        if (earlyClose) {
            hours = @"13";
            minutes = @"15"; // account for delayed quotes            
        }
        if (!holiday) {
            hours = @"16";
            minutes = @"15";           
        }
    }
    df.dateFormat = @"yyyy.MM.dd HH:mm";
    return [df dateFromString:[theDate stringByAppendingFormat:@" %@:%@",hours,minutes]];
}

@end
