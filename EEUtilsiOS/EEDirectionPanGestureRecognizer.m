#import "EEDirectionPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

const int DirectionPanThreshold = 5;

@implementation EEDirectionPanGestureRecognizer
{
  BOOL _drag;
  int _moveX;
  int _moveY;
}

- (id)init
{
  self = [super init];
  [self setup];
  return self;
}

- (id)initWithTarget:(id)target action:(SEL)action
{
  self = [super initWithTarget:target action:action];
  [self setup];
  return self;
}

- (void)awakeFromNib
{
  [self setup];
}

- (void)setup
{
  self.direction = EEDirectionPanGestureRecognizerHorizontal;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesMoved:touches withEvent:event];

  if(self.state == UIGestureRecognizerStateFailed)
    return;

  CGPoint nowPoint = [touches.anyObject locationInView:self.view];
  CGPoint prevPoint = [touches.anyObject previousLocationInView:self.view];
  _moveX += prevPoint.x - nowPoint.x;
  _moveY += prevPoint.y - nowPoint.y;
  if(!_drag) {
    if((abs(_moveX) > abs(_moveY)) && (abs(_moveX) > DirectionPanThreshold)) {
      if(_direction == EEDirectionPanGestureRecognizerVertical)
        self.state = UIGestureRecognizerStateFailed;
      else
        _drag = YES;
    } else if((abs(_moveY) > abs(_moveX)) && (abs(_moveY) > DirectionPanThreshold)) {
      if(_direction == EEDirectionPanGestureRecognizerHorizontal)
        self.state = UIGestureRecognizerStateFailed;
      else
        _drag = YES;
    }
  }
}

- (void)reset
{
  [super reset];
  _drag = NO;
  _moveX = 0;
  _moveY = 0;
}

@end