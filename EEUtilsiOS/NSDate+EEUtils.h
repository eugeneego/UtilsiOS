#import <Foundation/Foundation.h>

typedef struct
{
  NSInteger year;
  NSInteger month;
  NSInteger day;
  NSInteger weekDay;
} EEDateParts;

typedef struct
{
  NSInteger hour;
  NSInteger minute;
  NSInteger second;
} EETimeParts;

NSComparisonResult DatePartsCompare(EEDateParts d1, EEDateParts d2);

@interface NSDate (EEUtils)

+ (NSString *)stringMmSsFromTimeInterval:(NSTimeInterval)interval;
+ (NSString *)stringHhMmSsFromTimeInterval:(NSTimeInterval)interval;

- (NSString *)mediumTimeString;
- (NSString *)shortTimeString;
- (NSString *)mediumDateString;
- (NSString *)shortDateString;
- (NSString *)shortDateWith2DigitsYearString;
- (NSString *)shortDateWithoutYearString;
- (NSString *)dayString;
- (NSString *)monthString;
- (NSString *)fullString;
- (NSString *)fullUTCString;

- (EEDateParts)decodeDate;
- (EETimeParts)decodeTime;

@end