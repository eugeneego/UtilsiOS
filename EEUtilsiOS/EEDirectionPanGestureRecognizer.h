#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
  EEDirectionPanGestureRecognizerVertical,
  EEDirectionPanGestureRecognizerHorizontal
} EEDirectionPanGestureRecognizerDirection;

@interface EEDirectionPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, assign) EEDirectionPanGestureRecognizerDirection direction;

@end