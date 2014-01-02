//
//  AZBpmFinder.h
//  BassBPM
//
//  Created by Paolo Rossignoli on 29/12/13.
//  Copyright (c) 2013 Paolo Rossignoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AZBpmFinder : NSObject

- (void) getBpmFromSong:(NSString *)songTitle;

@end
