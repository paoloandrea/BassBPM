//
//  AZBpmFinder.h
//  BassBPM
//
//  Created by Paolo Rossignoli on 28/12/13.
//  Copyright (c) 2013 Paolo Rossignoli. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "bass.h"
#import "bass_fx.h"

@protocol AZBpmFinderBassDelegate <NSObject>

@required
- (void)beatsPerMinutes:(float)bpm;
- (void)totalAnalizedSong:(float)percent;

@end

@interface AZBpmFinderBass : NSObject

@property (nonatomic, assign) id<AZBpmFinderBassDelegate>delegate;

- (void) getBpmFromSong:(NSString *)songTitle;

@end
