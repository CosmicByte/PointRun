//
//  Functions.m
//  PointRun
//
//  Created by Jack Cook on 8/18/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

#import "Functions.h"

@implementation Functions

+ (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
