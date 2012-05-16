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

+ (NSArray*)stockMarketHolidays { // needs to occasionally be updated for variable holidays
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    [df setDateFormat:@"yyyy.MM.dd HH:mm"];
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
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    [df setDateFormat:@"yyyy.MM.dd 'at' HH:mm zzz"];
//    NSLog(@"testing date %@.",[df stringFromDate:aDate]);
    [df setDateFormat:@"HH"];
    int hours = [[df stringFromDate:aDate] intValue];
    if (hours < 16) {
        if (hours > 9) {
//            NSLog(@"threshold before 16 and after 9");
            return YES;
        } else { // ==9
            [df setDateFormat:@"mm"];
            int minutes = [[df stringFromDate:aDate] intValue];
            if (minutes >= 30) {
//                NSLog(@"Between 9:30 and 10.");
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

//    NSLog(@"Day of week is %i.",weekday);
    return weekday != 0 && weekday != 1;
}

+ (BOOL)holidayTest:(NSDate *)aDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    [df setDateFormat:@"yyyy.MM.dd HH:mm"];
    
    BOOL __block answer = YES;

    [[self stockMarketHolidays] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [df setDateFormat:@"yyyy.MM.dd"];
//        NSLog(@"comparing input date %@ to holiday %@.",[df stringFromDate:aDate],[df stringFromDate:obj]);
        if ([[df stringFromDate:obj] isEqualToString:[df stringFromDate:aDate]]) {  // holiday tests positive
//            NSLog(@"Holiday tests positive.");
            [df setDateFormat:@"HH"];
            if ([[df stringFromDate:obj] isEqualToString:kStockMarketStatusTimeAllDay]) {  // all day holiday
                answer = NO;
                *stop = YES;
//                NSLog(@"All day holiday.");
            } else {  // this is a holiday
//                NSLog(@"Early market close...");
                *stop = YES;
                int hours = [[df stringFromDate:aDate] intValue];
                if (hours < 13) {
                    if (hours > 9) {
 //                       NSLog(@"holiday threshold before 13 and after 9");
                    } else { // ==9
                        [df setDateFormat:@"mm"];
                        int minutes = [[df stringFromDate:aDate] intValue];
                        if (minutes < 30) {
//                            NSLog(@"Early close, between 9:00 and 9:29.");
                            answer = NO;
//                        } else {
//                            NSLog(@"Early close, between 9:30 and 10.");
                        }
                    }
                } else {
//                    NSLog(@"After 1 pm");
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
  
+ (BOOL)stockMarketIsClosed {
    return ![self stockMarketIsOpen];
}

+ (BOOL)stockMarketClosedOnDate:(NSDate *)aDate {
    return ![self stockMarketOpenOnDate:aDate];
}

+ (BOOL)stockMarketHolidayOnDate:(NSDate *)aDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    [df setDateFormat:@"yyyy.MM.dd HH:mm"];
    
    BOOL __block answer = NO;
    
    [[self stockMarketHolidays] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [df setDateFormat:@"yyyy.MM.dd"];
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

@end
