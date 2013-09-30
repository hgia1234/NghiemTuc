//
//  NTAppDelegate.m
//  NghiemTuc
//
//  Created by Gia on 9/8/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import "NTAppDelegate.h"

#import "NTViewController.h"
#import "NTSideViewController.h"
#import "NTToolsSideMenuViewController.h"
#import "NTProcessViewController.h"

@interface NTAppDelegate ()

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) MFSideMenuContainerViewController *sideMenuContainer;

@end

@implementation NTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"data"];
    [MagicalRecord setShouldDeleteStoreOnModelMismatch:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.viewController = [[NTViewController alloc] initWithNibName:@"NTViewController" bundle:nil];
    NTToolsSideMenuViewController *toolsVC = [[NTToolsSideMenuViewController alloc] init];
    self.nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    NTSideViewController *sideVC = [[NTSideViewController alloc] init];
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.sideMenuContainer = [MFSideMenuContainerViewController
                              containerWithCenterViewController:self.nav
                              leftMenuViewController:sideVC
                              rightMenuViewController:toolsVC];
    
    [self.sideMenuContainer setMenuSlideAnimationEnabled:YES];
    
    
    self.window.rootViewController = self.sideMenuContainer;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
