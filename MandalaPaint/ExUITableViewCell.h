//
//  ExUITableViewCell.h
//  MandaraPaint
//
//  Created by 岡本　奈緒 on 10/07/05.
//  Copyright 2010 xHills. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ExUITableViewCell : UITableViewCell {
	
	IBOutlet UIImageView *paintImage;
	IBOutlet UIImageView *level1;
	IBOutlet UIImageView *level2;
	IBOutlet UIImageView *level3;
	IBOutlet UIImageView *level4;
	IBOutlet UIImageView *level5;

}

@property (nonatomic, retain) UIImageView *paintImage;
@property (nonatomic, retain) UIImageView *level1;
@property (nonatomic, retain) UIImageView *level2;
@property (nonatomic, retain) UIImageView *level3;
@property (nonatomic, retain) UIImageView *level4;
@property (nonatomic, retain) UIImageView *level5;

@end
