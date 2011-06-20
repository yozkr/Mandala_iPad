//
//  RootViewController.h
//  SplitView
//
//  Created by 岡本　奈緒 on 11/06/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExUITableViewCell.h"

@class PaintViewController;

@interface SelectNewPaintViewController : UITableViewController {
	NSMutableArray *imageList;
	NSMutableArray *urlList;
	PaintViewController *detailViewController; 
}

@property (nonatomic, retain) NSMutableArray *imageList;
@property (nonatomic, retain) NSMutableArray *urlList;		
@property (nonatomic, retain) IBOutlet PaintViewController *detailViewController;

@end
