//
//  AZViewController.h
//  BassBPM
//
//  Created by Paolo Rossignoli on 28/12/13.
//  Copyright (c) 2013 Paolo Rossignoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <Accelerate/Accelerate.h>

#import "AZBpmFinderBass.h"

@interface AZViewController : UIViewController <AZBpmFinderBassDelegate> {
    AZBpmFinderBass *bpmFinder;
}

@property (weak, nonatomic) IBOutlet UILabel* songName;
@property (weak, nonatomic) IBOutlet UILabel* songPercentAnalized;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel* songBPM;
@property (weak, nonatomic) IBOutlet UIButton* startAnalisysButton;

@property (strong, nonatomic) AZBpmFinderBass *bpmFinder;

@end
