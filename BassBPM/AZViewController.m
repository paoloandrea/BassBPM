//
//  AZViewController.m
//  BassBPM
//
//  Created by Paolo Rossignoli on 28/12/13.
//  Copyright (c) 2013 Paolo Rossignoli. All rights reserved.
//

#import "AZViewController.h"


@interface AZViewController () 

@end

#define SONG_NAME1  @"midnight-ride-01a"    //Correct: 120bpm    -- RESULTS 0bpm
#define SONG_NAME2  @"heart-of-the-sea-01"  //Correct: 100bpm    -- RESULTS 176bpm
#define SONG_NAME3  @"barn-beat-01"         //Correct: 120bpm    -- RESULTS 113bpm


@implementation AZViewController

@synthesize bpmFinder;
@synthesize songPercentAnalized = _songPercentAnalized;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    bpmFinder = [[AZBpmFinderBass alloc] init];
    [bpmFinder setDelegate:self];
    [self.progress setProgress:0];
}

- (IBAction)startAnalisys:(id)sender{
    
   [_progress setProgress:0];
   [self.songName setText:SONG_NAME3];
   [bpmFinder getBpmFromSong:SONG_NAME3];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DELEGATE

#pragma mark AZBmpFinderBass
- (void)beatsPerMinutes:(float)bpm{
    NSString *bmpString = [NSString stringWithFormat:@"%.f",bpm];
    [self.songBPM setText:bmpString];
}
- (void)totalAnalizedSong:(float)percent{
    NSString *percentString = [NSString stringWithFormat:@"%.f",percent];
    //NSLog(@"percentString %@",percentString);
    
    [_songPercentAnalized setText:percentString];
    [_progress setProgress:percent/100 animated:YES];
}

@end
