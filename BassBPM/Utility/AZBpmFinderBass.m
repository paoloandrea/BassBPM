//
//  AZBpmFinder.m
//  BassBPM
//
//  Created by Paolo Rossignoli on 14/11/13.
//  Copyright (c) 2013 Paolo Rossignoli. All rights reserved.
//
// VAR TO BASS_FX_DecodeGet
//BASS_FX_BPM_DEFAULT
//BASS_FX_BPM_MULT2 ** DEFAULT
//BASS_FX_BPM_BKGRND
//BASS_FX_FREESOURCE
//
//

#import "AZBpmFinderBass.h"

#define kOFFSET_START   0
#define DWORDminMax     MAKELONG(70, 180) //MAKELONG(45,256)
#define DWORDmax        180

@interface AZBpmFinderBass()

@property (nonatomic, assign) float percentAnalized;
@property (nonatomic, readwrite) float bpm;

static void CALLBACK BMPProc (DWORD handle, float percent, void*user);
static void CALLBACK BPMCallback (DWORD handle, float bpm, void *user);
static void CALLBACK BPMBEATProc(DWORD chan, double beatpos, void *user);

@end


@implementation AZBpmFinderBass

@synthesize delegate = _delegate;
@synthesize bpm = _bpm;

- (void) getBpmFromSong:(NSString *)songTitle{
    
    if(!BASS_Init(-1, 44100, 0, NULL, NULL)){
        NSLog(@"BASS NOT INIT");
        BASS_Init(-1, 44100, 0, 0, NULL);
       
    }

    int ver = BASS_FX_GetVersion();
    NSLog(@"VERSION: %i",ver);
   
    
    NSString *fname = [[NSBundle mainBundle] pathForResource:songTitle ofType:@"mp3"];//mp3 //m4a
    
    HSTREAM bpmChan = BASS_StreamCreateFile(FALSE,[fname UTF8String], 0, 0, BASS_SAMPLE_FLOAT|BASS_STREAM_DECODE);
    if (bpmChan == 0)
        NSLog(@"BPM CHAN FAILED %d", BASS_ErrorGetCode());
    
    QWORD len = BASS_ChannelGetLength(bpmChan, BASS_POS_BYTE);
    double len_sec = BASS_ChannelBytes2Seconds(bpmChan, len);
    //BASS_GetBPM_Process
   
    BASS_FX_BPM_BeatDecodeGet(bpmChan, kOFFSET_START, len_sec, BASS_FX_BPM_MULT2, (BPMBEATPROC*)BPMBEATProc, (__bridge void *)(self));
    
    BASS_FX_BPM_CallbackSet(bpmChan, (BPMPROC*)BPMCallback, 1., DWORDminMax, BASS_FX_BPM_MULT2, (__bridge void *)(self));
    
    BASS_FX_BPM_DecodeGet(bpmChan,
                          kOFFSET_START,
                          len_sec,
                          DWORDminMax,
                          BASS_FX_BPM_BKGRND | BASS_FX_FREESOURCE | BASS_FX_BPM_MULT2,
                          (BPMPROCESSPROC*)BMPProc,
                          (__bridge void *)(self));
    
    BASS_FX_BPM_Free(bpmChan);
    
    //int bassHandle = BASS_FX_TempoCreate(bpmChan, BASS_FX_FREESOURCE);
    
    NSLog(@"len_sec %f",len_sec);
    
    BOOL val = BASS_FX_BPM_Free(bpmChan);
    if (val == FALSE)
        NSLog(@"BPM FREE FAILED %d", BASS_ErrorGetCode());
    
}


#pragma mark CALLBACK
#pragma mark END
void CALLBACK BPMCallback(DWORD handle, float bpm, void *user)
{
	AZBpmFinderBass* self = (__bridge AZBpmFinderBass *)(user);
    NSLog(@"BPMCallback is %f",bpm);
    
    self.bpm = bpm;
    //Appena concluso, delego i BMP
    
}

#pragma mark LOADING
void CALLBACK BMPProc (DWORD handle, float percent, void*user)   {
    
    //NSLog(@"BMPProc percent %.f",percent);
    AZBpmFinderBass* self = (__bridge AZBpmFinderBass*)user;
    
    self.percentAnalized = percent;
    
    if( self.delegate != nil && [ self.delegate respondsToSelector: @selector(totalAnalizedSong:) ] )
    {
        [self.delegate totalAnalizedSong:percent];
        
    }
    //BPM found
    if (percent >= 100) {
        if( self.delegate != nil && [ self.delegate respondsToSelector: @selector( beatsPerMinutes: ) ] )
        {
            [self.delegate beatsPerMinutes:self.bpm];
            NSLog(@"**** self.bpm %f",self.bpm);
        }
    }
}

#pragma mark BEATPOS
void CALLBACK BPMBEATProc(DWORD chan, double beatpos, void *user) {
    //NSLog(@"BPMBEATProc beatpos %f",beatpos);
}


#pragma mark USE LATER
//Verify BMP
- (float)analyserBPM:(float)BPM withMin:(int)min andMax:(int)max withAboveRange:(int)aboveRange {
    if ( BPM == 0 ) return BPM;
    
    if (aboveRange == 0) {
        if( BPM*2 < max ) BPM *= 2;
        while ( BPM > max ) BPM /= 2;
    }
    while ( BPM < min ) BPM *= 2;
    
    return BPM;
    
}


@end
