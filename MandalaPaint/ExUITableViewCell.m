//
//  ExUITableViewCell.m
//  MandaraPaint
//
//  Created by 岡本　奈緒 on 10/07/05.
//  Copyright 2010 xHills. All rights reserved.
//

#import "ExUITableViewCell.h"


@implementation ExUITableViewCell

@synthesize paintImage;
@synthesize level1;
@synthesize level2;
@synthesize level3;
@synthesize level4;
@synthesize level5;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
