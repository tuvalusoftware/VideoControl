//
//  ViewController.m
//  VideoControl
//
//  Created by TouchROI on 2/15/14.
//   Copyright (c) 2014 Tim O'Brien. All rights reserved.
//

#import "ViewController.h"
#import "VideoControls.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)newValue:(UISlider*)slider {
    
    NSLog(@"float value %f", slider.value);
    [_customControl setVideoProgress:slider.value];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
