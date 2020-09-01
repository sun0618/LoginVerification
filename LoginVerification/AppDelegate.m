//
//  AppDelegate.m
//  LoginVerification
//
//  Created by yang.sun on 2020/8/28.
//  Copyright © 2020 sun. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
     [self.window setRootViewController:[[ViewController alloc] init]];
     
     [self.window makeKeyAndVisible];
    
    return YES;
}



@end
