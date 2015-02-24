#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIDevice (EEUtils)

+ (NSString *)stringFromBatteryState:(UIDeviceBatteryState)batteryState;

@end