#import "EEDeviceInfo.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>

@implementation EEDeviceInfo

+ (instancetype)deviceInfo
{
  static EEDeviceInfo *deviceInfo = nil;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    deviceInfo = [[self alloc] init];
    [deviceInfo fill];
  });
  return deviceInfo;
}

- (void)fill
{
  self.machineName = [EEDeviceInfo machineName];
  self.machineDisplayName = [EEDeviceInfo machineDisplayName];

  self.system = [EEDeviceInfo system];
  self.systemVersion = [EEDeviceInfo systemVersion];

  self.bundleIdentifier = [EEDeviceInfo bundleIdentifier];
  self.bundleVersion = [EEDeviceInfo bundleVersion];
  self.bundleVersionShortString = [EEDeviceInfo bundleVersionShortString];
}

+ (NSString *)machineName
{
  static NSString *name = nil;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    struct utsname systemInfo;
    uname(&systemInfo);
    name = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
  });
  return name;
}

+ (NSString *)machineDisplayName
{
  static NSString *displayName = nil;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    NSString *machineName = self.machineName;
    NSDictionary *const displayNames = @{
      @"i386" : @"iOS Simulator",
      @"x86_64" : @"iOS Simulator (64 bit)",

      @"iPod1,1" : @"iPod Touch",
      @"iPod2,1" : @"iPod Touch 2nd Generation",
      @"iPod3,1" : @"iPod Touch 3rd Generation",
      @"iPod4,1" : @"iPod Touch 4th Generation",
      @"iPod5,1" : @"iPod Touch 5th Generation",

      @"iPhone1,1" : @"iPhone",
      @"iPhone1,2" : @"iPhone 3G",
      @"iPhone2,1" : @"iPhone 3GS",
      @"iPhone3,1" : @"iPhone 4 (GSM)",
      @"iPhone3,2" : @"iPhone 4 (GSM Rev A)",
      @"iPhone3,3" : @"iPhone 4 (CDMA)",
      @"iPhone4,1" : @"iPhone 4S",
      @"iPhone5,1" : @"iPhone 5 (GSM, LTE)",
      @"iPhone5,2" : @"iPhone 5 (GSM, CDMA, LTE)",
      @"iPhone5,3" : @"iPhone 5C (GSM, CDMA, LTE)",
      @"iPhone5,4" : @"iPhone 5C (GSM, LTE)",
      @"iPhone6,1" : @"iPhone 5S (GSM, CDMA, LTE)",
      @"iPhone6,2" : @"iPhone 5S (GSM, LTE)",
      @"iPhone7,1" : @"iPhone 6 Plus",
      @"iPhone7,2" : @"iPhone 6",

      @"iPad1,1" : @"iPad",
      @"iPad2,1" : @"iPad 2 (Wi-Fi)",
      @"iPad2,2" : @"iPad 2 (Wi-Fi, GSM)",
      @"iPad2,3" : @"iPad 2 (Wi-Fi, CDMA)",
      @"iPad2,4" : @"iPad 2 (Wi-Fi)",
      @"iPad3,1" : @"iPad 3 (Wi-Fi)",
      @"iPad3,2" : @"iPad 3 (Wi-Fi, GSM, CDMA, LTE)",
      @"iPad3,3" : @"iPad 3 (Wi-Fi, GSM, LTE)",
      @"iPad3,4" : @"iPad 4 (Wi-Fi)",
      @"iPad3,5" : @"iPad 4 (Wi-Fi, GSM, LTE)",
      @"iPad3,6" : @"iPad 4 (Wi-Fi, GSM, CDMA, LTE)",
      @"iPad4,1" : @"iPad Air (Wi-Fi)",
      @"iPad4,2" : @"iPad Air (Wi-Fi, Cellular)",
      @"iPad4,3" : @"iPad Air (Wi-Fi, Cellular, China)",
      @"iPad5,3" : @"iPad Air 2 (Wi-Fi)",
      @"iPad5,4" : @"iPad Air 2 (Wi-Fi, Cellular)",
      @"iPad5,5" : @"iPad Air 2 (Wi-Fi, Cellular, China)",

      @"iPad2,5" : @"iPad mini (Wi-Fi)",
      @"iPad2,6" : @"iPad mini (Wi-Fi, GSM, LTE)",
      @"iPad2,7" : @"iPad mini (Wi-Fi, GSM, CDMA, LTE)",
      @"iPad4,4" : @"iPad mini 2 (Wi-Fi)",
      @"iPad4,5" : @"iPad mini 2 (Wi-Fi, Cellular)",
      @"iPad4,6" : @"iPad mini 2 (Wi-Fi, Cellular, China)",
      @"iPad4,7" : @"iPad mini 3 (Wi-Fi)",
      @"iPad4,8" : @"iPad mini 3 (Wi-Fi, Cellular)",
      @"iPad4,9" : @"iPad mini 3 (Wi-Fi, Cellular, China)",
    };
    displayName = displayNames[machineName];
    if(!displayName)
      displayName = machineName;
  });
  return displayName;
}

+ (NSString *)system
{
  return [UIDevice currentDevice].systemName;
}

+ (NSString *)systemVersion
{
  return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)bundleIdentifier
{
  return [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleIdentifierKey];
}

+ (NSString *)bundleVersion
{
  return [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleVersionKey];
}

+ (NSString *)bundleVersionShortString
{
  return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

@end