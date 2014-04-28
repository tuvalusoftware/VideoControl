//
//   VideoControl.m
//   
//
//  Created by TouchROI on 1/24/14.
//   Copyright (c) 2014 Tim O'Brien. All rights reserved.
//



#import "VideoControls.h"
#import <QuartzCore/QuartzCore.h>


const float kLineWidth = 1.7;
const float kLineOffsetFromStart = 30;
const float kLineOffsetFromEnd = 10;
const float kControlOffsetFromEnd = 5;
const float kLineOffsetFromTop = .3;
const float kBackgroundAlpha = .6;
const float kControlButtonHorizontalDistance =7;

#define COLOR_TRACK [UIColor blueColor]
#define COLOR_TRACK_BEFORE_SLIDER_BUTTON  [UIColor yellowColor]
#define COLOR_BACKGROUND   [UIColor lightGrayColor]
#define MESSAGE_NAME_PROGRESS @"VidoeProgress"
#define MESSAGE_NAME_OPERATION @"operation"
#define MESSAGE_KEY @"offset"
#define OPERATION_KEY @"operation"

const float kHeightOfSlidingBarButtonAsFractionOfControllerHeight =4;
 
@implementation VideoControls

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.backgroundColor = COLOR_BACKGROUND;
        self.alpha = kBackgroundAlpha;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoProgressNotification:)
                                                     name:MESSAGE_NAME_PROGRESS
                                                object:nil];
    }
    return self;
    
}


- (void)videoProgressNotification:(NSNotification *)notification
{
    
    NSDictionary *dict =notification.userInfo;
    NSNumber * progress = [dict objectForKey:MESSAGE_KEY];
    float newLength = [self getTotalDistance]*progress.floatValue;
    float x =kLineOffsetFromStart + newLength;
    self.point =CGPointMake(x, 10);
    [self setNeedsDisplay];
 
}

-(void) setVideoProgress:(float) offsetPercent
{

    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:offsetPercent],
                           MESSAGE_KEY, nil];
    id sender;
    NSNotification *notification = [NSNotification notificationWithName:MESSAGE_NAME_PROGRESS object:sender userInfo:dict];
    [[NSNotificationQueue defaultQueue]
     enqueueNotification:notification
     postingStyle:NSPostNow];
 
}



-(void) sendNotification:(int) messageType
{
    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:messageType],
                          OPERATION_KEY, nil];
    id sender;
    NSNotification *notification = [NSNotification notificationWithName:MESSAGE_NAME_PROGRESS object:sender userInfo:dict];
    [[NSNotificationQueue defaultQueue]
     enqueueNotification:notification
     postingStyle:NSPostNow];
    
}


-(float) getTotalDistance
{
    return (self.frame.size.width-kLineOffsetFromEnd-kLineOffsetFromStart);
    
}


-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    BOOL retValue = NO;
    
    int x = [touch locationInView:self].x;
    
    if(x < kLineOffsetFromStart)
    {
        if(_isPlay)
            _isPlay=NO;
        else
            _isPlay=YES;
        
        [self setNeedsDisplayInRect:CGRectMake(0,0, kLineOffsetFromStart, self.frame.size.height)];
        
    }
    else if(  x > self.frame.size.width-kLineOffsetFromEnd)
    {
        // do nothing
        
    }
    else
    {
        
        self.point = [touch locationInView:self];
        [self setNeedsDisplay];
        retValue = YES;
        
    }

    return retValue;
}




-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    long x = [touch locationInView:self].x;
    BOOL retValue = NO;
    if(x  > kLineOffsetFromStart &&  x < self.frame.size.width-kLineOffsetFromEnd)
    {
        NSLog(@"my log file %li, %f, %f", x, self.frame.size.width-kLineOffsetFromEnd,kLineOffsetFromStart);
        self.point = [touch locationInView:self];
        [self setNeedsDisplay];
        retValue = YES;
        
    }
   
    //[self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return retValue;
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{

    self.point = [touch locationInView:self];
    [self setNeedsDisplay];

}



-(void)fillCircleCenteredAt:(CGPoint)center
{
    UIBezierPath *path = [UIBezierPath bezierPath];

    [path addArcWithCenter:CGPointMake(center.x, self.frame.size.height/2)
                    radius:self.frame.size.height/kHeightOfSlidingBarButtonAsFractionOfControllerHeight
                startAngle:0.0
                  endAngle:2.0 * M_PI
                 clockwise:NO];
     [path fillWithBlendMode:kCGBlendModeNormal alpha:1.0];
}



-(void) drawPauseButton
{
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    aPath.lineWidth =  4;
    float virticalOffset  =kLineOffsetFromTop * self.frame.size.height;
    UIColor *strokeColor = [UIColor  whiteColor];
    [strokeColor setStroke];
    [strokeColor setFill];
    CGPoint pointOne =CGPointMake(kControlButtonHorizontalDistance, virticalOffset);
    CGPoint pointTwo =CGPointMake(kControlButtonHorizontalDistance, self.frame.size.height -virticalOffset );
    CGPoint pointOnePrme =CGPointMake( kControlButtonHorizontalDistance+8, virticalOffset);
    CGPoint pointTwoPrime =CGPointMake(kControlButtonHorizontalDistance+8, self.frame.size.height -virticalOffset );
    [aPath moveToPoint:pointOne];
    [aPath addLineToPoint:pointTwo];
    [aPath stroke];
    [aPath moveToPoint:pointOnePrme];
    [aPath addLineToPoint:pointTwoPrime];
    [aPath stroke];
 
}


-(void) drawStartButton
{
     UIBezierPath *aPath = [UIBezierPath bezierPath];
     float virticalOffset  =kLineOffsetFromTop * self.frame.size.height;
     float triangleSide = self.frame.size.height-2*virticalOffset;
     float  horizontalDistance = [self calculatedHorizontalDistance:triangleSide];
     aPath.lineWidth = kLineWidth;
    
     UIColor *strokeColor = [UIColor  whiteColor];
     [strokeColor setStroke];
    [strokeColor setFill];
    
    CGPoint pointOne =CGPointMake(kControlButtonHorizontalDistance, virticalOffset);
    CGPoint pointTwo =CGPointMake(kControlButtonHorizontalDistance, self.frame.size.height -virticalOffset );
    CGPoint pointThree =CGPointMake(horizontalDistance+5 , virticalOffset+(self.frame.size.height-2*virticalOffset)/2 );
 
     [aPath moveToPoint:pointOne];
     [aPath addLineToPoint:pointTwo];
      [aPath addLineToPoint:pointThree];
     [aPath addLineToPoint:pointOne];
     [aPath fill];
    
}



-(float) calculatedHorizontalDistance:(float) line;
{
    
    float  lineSquared = line*line;
    float distance =  sqrtf(lineSquared + lineSquared*.25);
    return distance;
}

-(void) drawTrack
{
    
    UIColor *strokeColor = COLOR_TRACK;
    [strokeColor setStroke];
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    [aPath moveToPoint:CGPointMake(kLineOffsetFromStart  ,self.frame.size.height/2)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width-kLineOffsetFromEnd,self.frame.size.height/2)];
    aPath.lineWidth = kLineWidth;
    [aPath stroke];
    
}

-(void) drawTrackBeforeSliderButton
{
    
    UIColor *strokeColor = COLOR_TRACK_BEFORE_SLIDER_BUTTON;
    [strokeColor setStroke];
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    [aPath moveToPoint:CGPointMake(kLineOffsetFromStart  ,self.frame.size.height/2)];
    [aPath addLineToPoint:CGPointMake(self.point.x,self.frame.size.height/2)];
    aPath.lineWidth = kLineWidth;
    [aPath stroke];
    
    
}



-(void) drawRect:(CGRect)rect
{
       self.layer.cornerRadius = 7;
       self.layer.masksToBounds = YES;
    
        if(_isPlay)
         [self drawStartButton];
       else
          [self drawPauseButton];
    
    [self drawTrack];
    
    if( _didInit)
    {
    
        [self fillCircleCenteredAt:self.point];
        [self drawTrackBeforeSliderButton];
    }
    else
    {
        self.point = CGPointMake(kLineOffsetFromStart, 10);
        [self fillCircleCenteredAt:self.point];
        _didInit = YES;
        
    }

}


-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
