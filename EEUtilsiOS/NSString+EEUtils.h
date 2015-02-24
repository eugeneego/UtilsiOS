#import <Foundation/Foundation.h>

@interface NSString (EEUtils)

- (BOOL)isAlphaNumericAndSpace;
- (BOOL)isNumeric;

- (NSString *)md5;
- (NSString *)sha1;

- (NSString *)abbreviationWithMaximumLength:(NSUInteger)maximumLength;
+ (NSString *)abbreviationWithFirstName:(NSString *)firstName lastName:(NSString *)lastName fullName:(NSString *)fullName;

+ (NSString *)stringWithHashtags:(NSArray *)hashtags;
- (BOOL)isHashtag;
- (NSArray *)hashtags;

+ (NSString *)stringFromFileSize:(int32_t)fileSize;

@end