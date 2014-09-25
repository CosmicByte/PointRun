//
//  GCHelper.m
//  CatRace
//
//  Created by Ray Wenderlich on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GCHelper.h"

@implementation GCHelper
@synthesize gameCenterAvailable;
@synthesize presentingViewController;
@synthesize match;
@synthesize delegate;
@synthesize playersDict;
@synthesize invitedPlayer;
@synthesize invite;
@synthesize mainViewController;

#pragma mark Initialization

static GCHelper *sharedHelper = nil;
+ (GCHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[GCHelper alloc] init];
    }
    return sharedHelper;
}

- (BOOL)isGameCenterAvailable {
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	return gcClass != nil;
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = 
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
    }
    return self;
}

#pragma mark Internal functions

- (void)authenticationChanged {
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        userAuthenticated = FALSE;
    }
}

- (void)lookupPlayers {
    NSMutableArray *playerIDs = [@[] mutableCopy];
    for (GKPlayer *player in match.players) {
        [playerIDs addObject:player.playerID];
    }
    
    [GKPlayer loadPlayersForIdentifiers:playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
            matchStarted = NO;
            [delegate matchEnded:@""];
        } else {
            self.playersDict = [NSMutableDictionary dictionaryWithCapacity:players.count];
            for (GKPlayer *player in players) {
                NSLog(@"Found player: %@", player.alias);
                [playersDict setObject:player forKey:player.playerID];
            }

            matchStarted = YES;
            [[GKMatchmaker sharedMatchmaker] finishMatchmakingForMatch:self.match];
            [delegate matchStarted];
        }
    }];
}

#pragma mark User functions

- (void)authenticateLocalUser {
    if (!gameCenterAvailable) return;
    NSLog(@"Authenticating local user...");
    if ([GKLocalPlayer localPlayer].authenticated == NO) {     
        [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *view, NSError *error) {
            if (error == nil) {
                self.authenticated = YES;
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    } else {
        NSLog(@"Already authenticated!");
    }
}

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController delegate:(id<GCHelperDelegate>)theDelegate {
    if (!gameCenterAvailable) return;

    matchStarted = NO;
    self.match = nil;
    self.presentingViewController = viewController;
    delegate = theDelegate;
    [presentingViewController dismissViewControllerAnimated:NO completion:nil];

    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;     
    request.maxPlayers = maxPlayers;

    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;

    [presentingViewController presentViewController:mmvc animated:YES completion:nil];
}

- (void)showAchievements:(UIViewController *)viewController {
    self.presentingViewController = viewController;
    [presentingViewController dismissViewControllerAnimated:NO completion:nil];

    GKGameCenterViewController *gcvc = [[GKGameCenterViewController alloc] init];
    gcvc.viewState = GKGameCenterViewControllerStateAchievements;
    if (gcvc != nil) {
        gcvc.gameCenterDelegate = self;
        [presentingViewController presentViewController:gcvc animated:YES completion:nil];
    }
}

- (void)showLeaderboards:(UIViewController *)viewController {
    self.presentingViewController = viewController;
    [presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
    GKGameCenterViewController *gcvc = [[GKGameCenterViewController alloc] init];
    gcvc.viewState = GKGameCenterViewControllerStateLeaderboards;
    if (gcvc != nil) {
        gcvc.gameCenterDelegate = self;
        [presentingViewController presentViewController:gcvc animated:YES completion:nil];
    }
}

- (void)showGameCenter:(UIViewController *)viewController {
    self.presentingViewController = viewController;
    [presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
    GKGameCenterViewController *gcvc = [[GKGameCenterViewController alloc] init];
    if (gcvc != nil) {
        gcvc.gameCenterDelegate = self;
        [presentingViewController presentViewController:gcvc animated:YES completion:nil];
    }
}

- (void)reportAchievementIdentifier:(NSString *)identifier percentComplete:(float)percent {
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
    if (achievement) {
        achievement.percentComplete = percent;
        achievement.showsCompletionBanner = YES;
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Error in reporting achievements: %@", error);
            }
        }];
    }
}

- (void)submitTimedScore:(int)highScore {
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"mosttimedpoints"];
    score.value = [[NSUserDefaults standardUserDefaults] integerForKey:@"mostTimedPoints"];
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark GKGameCenterControllerDelegate

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [presentingViewController.navigationController popViewControllerAnimated:YES];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);    
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    self.match = theMatch;
    match.delegate = self;
    if (!matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match!");
        [self lookupPlayers];
    }
}

#pragma mark GKMatchDelegate

// The match received data sent from the player.
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    if (match != theMatch) return;
    [delegate match:theMatch didReceiveData:data fromPlayer:playerID];
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    if (match != theMatch) return;
    switch (state) {
        case GKPlayerStateConnected: 
            if (!matchStarted && theMatch.expectedPlayerCount == 0) [self lookupPlayers];
            break; 
        case GKPlayerStateDisconnected:
            matchStarted = NO;
            [delegate matchEnded:@""];
            self.match = nil;
            break;
        case GKPlayerStateUnknown:
            break;
    }
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    if (match != theMatch) return;
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded:playerID];
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    if (match != theMatch) return;
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded:@""];
}

#pragma mark GKLocalPlayerListener

- (void)player:(GKPlayer *)player didAcceptInvite:(GKInvite *)inviteToAccept {
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithInvite:inviteToAccept];
    mmvc.matchmakerDelegate = self;
    [mainViewController presentViewController:mmvc animated:YES completion:nil];
}

- (void)player:(GKPlayer *)player didRequestMatchWithOtherPlayers:(NSArray *)playersToInvite {
    
}

@end
