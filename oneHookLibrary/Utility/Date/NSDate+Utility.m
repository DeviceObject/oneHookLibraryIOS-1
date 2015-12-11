//
//  NSDate+Utility.m
//  oneHookLibrary
//
//  Created by Eagle Diao on 2015-05-18.
//  Copyright (c) 2015 oneHook inc. All rights reserved.
//

#import "NSDate+Utility.h"

@implementation NSDate (Utility)

+ (NSDate *)beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:[[NSDate alloc] init]];

    return [calendar dateFromComponents:components];
}

+ (NSDate *)endOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *components = [NSDateComponents new];
    components.day = 1;

    NSDate *date = [calendar dateByAddingComponents:components
                                             toDate:[NSDate beginningOfDay]
                                            options:0];

    date = [date dateByAddingTimeInterval:-1];

    return date;
}

+ (NSDateFormatter*)isoDateFormatter
{
    static NSDateFormatter* isoDateFormatter;
    if(!isoDateFormatter) {
        isoDateFormatter = [[NSDateFormatter alloc] init];
        [isoDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    }
    return isoDateFormatter;
}

const int SECOND = 1;
const int MINUTE = 60*SECOND;
const int HOUR = 60*MINUTE;
const int DAY = HOUR*24;
const int WEEK = DAY*7;
const int MONTH = WEEK*4;
const int YEAR = DAY*365;

-(NSString *)relativeTime
{
    NSDate *currentDate = [NSDate date];
    long deltaSeconds = labs(lroundf([self timeIntervalSinceDate:currentDate]));
    BOOL dateInFuture = ([self timeIntervalSinceDate:currentDate] > 0);
    
    if(deltaSeconds < 2*SECOND) {
        return [self localizedString: @"Now"];
    } else if(deltaSeconds < MINUTE) {
        return [self formattedStringForCurrentDate:currentDate count:deltaSeconds past:@"%d seconds ago" future:@"%d seconds from now"];
    } else if(deltaSeconds < 1.5*MINUTE) {
        return !dateInFuture ? [self localizedString: @"A minute ago"] : [self localizedString: @"A minute from now"];
    } else if(deltaSeconds < HOUR) {
        int minutes = (int)lroundf((float)deltaSeconds/(float)MINUTE);
        return [self formattedStringForCurrentDate:currentDate count:minutes past:@"%d minutes ago" future:@"%d minutes from now"];
    } else if(deltaSeconds < 1.5*HOUR) {
        return !dateInFuture ? [self localizedString: @"An hour ago"] : [self localizedString: @"An hour from now"];
    } else if(deltaSeconds < DAY) {
        int hours = (int)lroundf((float)deltaSeconds/(float)HOUR);
        return [self formattedStringForCurrentDate:currentDate count:hours past:@"%d hours ago" future:@"%d hours from now"];
    } else if(deltaSeconds < 1.5*DAY) {
        return !dateInFuture ? [self localizedString: @"A day ago"] : [self localizedString: @"A day from now"];
    } else if(deltaSeconds < WEEK) {
        int days = (int)lroundf((float)deltaSeconds/(float)DAY);
        return [self formattedStringForCurrentDate:currentDate count:days past:@"%d days ago" future:@"%d days from now"];
    } else if(deltaSeconds < 1.5*WEEK) {
        return !dateInFuture ? [self localizedString: @"A week ago"] : [self localizedString: @"A week from now"];
    } else if(deltaSeconds < MONTH) {
        int weeks = (int)lroundf((float)deltaSeconds/(float)WEEK);
        return [self formattedStringForCurrentDate:currentDate count:weeks past:@"%d weeks ago" future:@"%d weeks from now"];
    } else if(deltaSeconds < 1.5*MONTH) {
        return !dateInFuture ? [self localizedString: @"A month ago"] : [self localizedString: @"A month from now"];
    } else if(deltaSeconds < YEAR) {
        int months = (int)lroundf((float)deltaSeconds/(float)MONTH);
        return [self formattedStringForCurrentDate:currentDate count:months past:@"%d months ago" future:@"%d months from now"];
    } else if(deltaSeconds < 1.5*YEAR) {
        return !dateInFuture ? [self localizedString: @"A year ago"] : [self localizedString: @"A year from now"];
    } else {
        int years = (int)lroundf((float)deltaSeconds/(float)YEAR);
        return [self formattedStringForCurrentDate:currentDate count:years past:@"%d years ago" future:@"%d years from now"];
    }
}

-(NSString *)formattedStringForCurrentDate:(NSDate *)currentDate count:(long)count past:(NSString *)past future:(NSString *)future
{
    if ([self timeIntervalSinceDate:currentDate] > 0) {
        return [NSString stringWithFormat: [self localizedString: future], count];
    } else {
        return [NSString stringWithFormat: [self localizedString: past], count];
    }
}

-(NSString *)localizedString:(NSString *)key
{
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:
                  [[[NSBundle mainBundle] resourcePath]
                                           stringByAppendingPathComponent:@"/NSDate+Utility.bundle"]];
        NSLog(@"budnel %@ %@",
              [[[NSBundle mainBundle] resourcePath]
               stringByAppendingPathComponent:@"/NSDate+Utility.bundle"], bundle);
    });
    return NSLocalizedStringFromTableInBundle(key, @"NSDate+Utility", bundle, nil);
}

@end
