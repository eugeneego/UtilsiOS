#import <Foundation/Foundation.h>

@interface EEDeviceInfo : NSObject

@property (nonatomic, copy) NSString *machineName;
@property (nonatomic, copy) NSString *machineDisplayName;

@property (nonatomic, copy) NSString *system;
@property (nonatomic, copy) NSString *systemVersion;

@property (nonatomic, copy) NSString *bundleIdentifier;
@property (nonatomic, copy) NSString *bundleVersion;
@property (nonatomic, copy) NSString *bundleVersionShortString;

+ (instancetype)deviceInfo;

+ (NSString *)machineName;
+ (NSString *)machineDisplayName;

+ (NSString *)system;
+ (NSString *)systemVersion;

+ (NSString *)bundleIdentifier;
+ (NSString *)bundleVersion;
+ (NSString *)bundleVersionShortString;

@end