//
//  GCHelper.h
//  CatRace
//
//  Created by Ray Wenderlich on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GCHelperDelegate 
- (void)matchStarted;
- (void)matchEnded:(NSString *)playerID;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
@end

@interface GCHelper : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKGameCenterControllerDelegate, GKGameCenterControllerDelegate, UIAlertViewDelegate> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    
    UIViewController *presentingViewController;
    GKMatch *match;
    BOOL matchStarted;
    id <GCHelperDelegate> gcdelegate;
    NSMutableDictionary *playersDict;
}

@property (nonatomic) BOOL authenticated;
@property (retain) NSMutableDictionary *playersDict;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (retain) UIViewController *presentingViewController;
@property (retain) GKMatch *match;
@property (assign) id <GCHelperDelegate> delegate;
@property (retain) GKPlayer *invitedPlayer;
@property (retain) GKInvite *invite;
@property (retain) UIViewController *mainViewController;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GCHelperDelegate>)theDelegate;
- (void)showAchievements:(UIViewController *)viewController;
- (void)showLeaderboards:(UIViewController *)viewController;
- (void)showGameCenter:(UIViewController *)viewController;
- (void)reportAchievementIdentifier:(NSString *)identifier percentComplete:(float)percent;
- (void)submitTimedScore:(int)highScore;

@end
