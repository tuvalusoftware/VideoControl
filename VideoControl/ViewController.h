//
//  ViewController.h
//  VideoControl
//
//  Created by TouchROI on 2/15/14.
//   Copyright (c) 2014 Tim O'Brien. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoControls;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet VideoControls *customControl;

@end
