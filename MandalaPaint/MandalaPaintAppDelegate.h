//
//  MandalaPaintAppDelegate.h
//  MandalaPaint
//
//  Created by 岡本　奈緒 on 11/06/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectNewPaintViewController;
@class PaintViewController;

@interface MandalaPaintAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

    UIWindow *window;
    UITabBarController *tabBarController;
    UISplitViewController *splitViewController;
    SelectNewPaintViewController *selctNewPaintViewController;
    PaintViewController *paintViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet SelectNewPaintViewController *selectNewPaintViewController;
@property (nonatomic, retain) IBOutlet PaintViewController *paintViewController;

@end

   
