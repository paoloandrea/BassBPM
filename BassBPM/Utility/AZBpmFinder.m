//
//  AZBpmFinder.m
//  BassBPM
//
//  Created by Paolo Rossignoli on 29/12/13.
//  Copyright (c) 2013 Paolo Rossignoli. All rights reserved.
//

#import "AZBpmFinder.h"
#include <SoundTouch/SoundTouch.h>

@implementation AZBpmFinder

- (void) getBpmFromSong:(NSString *)songTitle{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:songTitle ofType:@"m4a"];
    NSData *data = [NSData dataWithContentsOfFile:path];


    AVAudioPlayer *player =[[AVAudioPlayer alloc] initWithData:data error:NULL];
    
    NSUInteger len = [player.data length];
    int numChannels = player.numberOfChannels;
    
    soundtouch::SAMPLETYPE sampleBuffer[1024];
    
    soundtouch::BPMDetect *BPM = new soundtouch::BPMDetect(player.numberOfChannels, [[player.settings valueForKey:@"AVSampleRateKey"] longValue]);
    
    
    for (NSUInteger i = 0; i <= len - 1024; i = i + 1024) {
        
        NSRange r = NSMakeRange(i, 1024);
        //NSData *temp = [player.data subdataWithRange:r];
        [player.data getBytes:sampleBuffer range:r];
        
        int samples = sizeof(sampleBuffer) / numChannels;
        
        BPM->inputSamples(sampleBuffer, samples); // Send the samples to the BPM class
        
    }
    
    NSLog(@"Beats Per Minute = %f", BPM->getBpm());
}
@end
