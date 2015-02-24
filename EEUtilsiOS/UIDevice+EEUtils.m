#import "UIDevice+EEUtils.h"

@implementation UIDevice (EEUtils)

+ (NSString *)stringFromBatteryState:(UIDeviceBatteryState)batteryState
{
  NSString *string = @"";
  switch(batteryState) {
    case UIDeviceBatteryStateUnknown:
      string = @"Unknown";
      break;
    case UIDeviceBatteryStateUnplugged:
      string = @"Unplugged";
      break;
    case UIDeviceBatteryStateCharging:
      string = @"Charging";
      break;
    case UIDeviceBatteryStateFull:
      string = @"Full";
      break;
  }
  return string;
}

@end