//
//  MandalaPaintAppDelegate.m
//  MandalaPaint
//
//  Created by 岡本　奈緒 on 11/06/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MandalaPaintAppDelegate.h"
#import "SelectNewPaintViewController.h"
#import "PaintViewController.h"

@implementation MandalaPaintAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize splitViewController;
@synthesize selectNewPaintViewController;
@synthesize paintViewController;

#pragma mark -
#pragma mark Application lifecycle

-(void) makeSplitViewController {
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:tabBarController.viewControllers];
    int index = 0; 
    for (UIViewController *controller in tabBarController.viewControllers) {
        if (index == 0) {
            paintViewController = [[PaintViewController alloc] initWithNibName:@"PaintView" bundle:nil];
            selectNewPaintViewController = [[SelectNewPaintViewController alloc] initWithStyle:UITableViewStylePlain];
            selectNewPaintViewController.detailViewController = paintViewController;
            selectNewPaintViewController.navigationItem.title = @"List";
            UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:selectNewPaintViewController] autorelease];
            splitViewController = [[UISplitViewController alloc] init];
            splitViewController.tabBarItem = controller.tabBarItem;
            splitViewController.viewControllers = [NSArray arrayWithObjects:nav, paintViewController, nil];
            splitViewController.delegate = paintViewController;
            [controllers replaceObjectAtIndex:index withObject:splitViewController];
        }
        index++;
    }
    
    tabBarController.delegate = self;
    tabBarController.viewControllers = controllers;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch.
    [self makeSplitViewController];
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)isPortrait {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    return orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([self isPortrait]) {
        if (viewController != splitViewController) {
            [paintViewController removeButton];
        }
        else {
            [paintViewController addBarButtonItem:paintViewController.barButton forPopoverController:paintViewController.popoverController];
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [window release];
    [tabBarController release];
    //[splitViewController release];
    //[selectNewPaintViewController release];
    //[paintViewController release];
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
