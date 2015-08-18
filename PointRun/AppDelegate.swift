//
//  AppDelegate.swift
//  PointRun
//
//  Created by Jack Cook on 7/31/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import GCHelper
import GoogleMaps
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        GCHelper.sharedInstance.authenticateLocalUser()
        GMSServices.provideAPIKey("AIzaSyBTxTpBslCxwVNOjOLM9IyoaoX8Vovw0Dw")
        
        return true
    }
}
