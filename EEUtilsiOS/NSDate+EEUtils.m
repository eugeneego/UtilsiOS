#import "NSDate+EEUtils.h"

NSComparisonResult DatePartsCompare(EEDateParts d1, EEDateParts d2)
{
  if(d1.year < d2.year)
    return NSOrderedAscending;
  if(d1.year > d2.year)
    return NSOrderedDescending;

  if(d1.month < d2.month)
    return NSOrderedAscending;
  if(d1.month > d2.month)
    return NSOrderedDescending;

  if(d1.day < d2.day)
    return NSOrderedAscending;
  if(d1.day > d2.day)
    return NSOrderedDescending;

  return NSOrderedSame;
}

@implementation NSDate (EEUtils)

#pragma mark - Time interval

+ (NSString *)stringMmSsFromTimeInterval:(NSTimeInterval)interval
{
  int ti = (int)interval;
  int seconds = ti % 60;
  int minutes = ti / 60;
  return [NSString stringWithFormat:@"%02i:%02i", minutes, seconds];
}

+ (NSString *)stringHhMmSsFromTimeInterval:(NSTimeInterval)interval
{
  int ti = (int)interval;
  int seconds = ti % 60;
  int minutes = (ti / 60) % 60;
  int hours = (ti / 3600);
  return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
}

#pragma mark - String representation

- (NSString *)mediumTimeString
{
  return [NSDateFormatter localizedStringFromDate:self dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
}

- (NSString *)shortTimeString
{
  return [NSDateFormatter localizedStringFromDate:self dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *)mediumDateString
{
  return [NSDateFormatter localizedStringFromDate:self dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *)shortDateString
{
  static NSDateFormatter *formatter;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    formatter = [NSDateFormatter new];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"ddMMyyyy" options:0 locale:[NSLocale currentLocale]];
  });
  return [formatter stringFromDate:self];
}

- (NSString *)shortDateWith2DigitsYearString
{
  static NSDateFormatter *formatter;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    formatter = [NSDateFormatter new];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"ddMMyy" options:0 locale:[NSLocale currentLocale]];
  });
  return [formatter stringFromDate:self];
}

- (NSString *)shortDateWithoutYearString
{
  static NSDateFormatter *formatter;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    formatter = [NSDateFormatter new];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"ddMM" options:0 locale:[NSLocale currentLocale]];
  });
  return [formatter stringFromDate:self];
}

- (NSString *)dayString
{
  static NSDateFormatter *formatter;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    formatter = [NSDateFormatter new];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"d" options:0 locale:[NSLocale currentLocale]];
  });
  return [formatter stringFromDate:self];
}

- (NSString *)monthString
{
  static NSDateFormatter *formatter;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    formatter = [NSDateFormatter new];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMMM" options:0 locale:[NSLocale currentLocale]];
  });
  return [formatter stringFromDate:self];
}

- (NSString *)fullString
{
  static NSDateFormatter *formatter;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    formatter = [NSDateFormatter new];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss.SSSS Z";
  });
  return [formatter stringFromDate:self];
}

- (NSString *)fullUTCString
{
  static NSDateFormatter *formatter;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    formatter = [NSDateFormatter new];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss.SSSS Z";
  });
  return [formatter stringFromDate:self];
}

#pragma mark - Decoding

- (EEDateParts)decodeDate
{
  EEDateParts dp = { 0 };
  NSCalendarUnit flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
  NSDateComponents *parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  dp.year = parts.year;
  dp.month = parts.month;
  dp.day = parts.day;
  dp.weekDay = parts.weekday;
  return dp;
}

- (EETimeParts)decodeTime
{
  EETimeParts tp = { 0 };
  NSCalendarUnit flags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
  NSDateComponents *parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
  tp.hour = parts.hour;
  tp.minute = parts.minute;
  tp.second = parts.second;
  return tp;
}

@end