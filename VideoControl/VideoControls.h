//
//   VideoControl.h
//
//
//  Created by TouchROI on 1/24/14.
//   Copyright (c) 2014 Tim O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoControls : UIControl

@property  CGPoint point;
@property  BOOL    didInit;
@property  BOOL    isPlay;

-(void) setVideoProgress:(float) offsetPercent;

@end

