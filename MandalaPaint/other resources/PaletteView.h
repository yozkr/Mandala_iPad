//
//  PaletteView.h
//  MyOpenCV
//
//  Created by 岡田 一志 on 10/06/09.
//  Copyright 2010 xHills. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "enums.h"

//
// PaletteView
//
@interface PaletteView : UIImageView 
{
	// パレットの位置
	CGPoint startLocation;
	CGPoint endLocation;
	
	// パレット上の色（複数）
	NSMutableArray *colors;
	
	// モード（ペイントビュー or カラーピッカービュー）
	int mode;
}

@property (nonatomic, retain) NSMutableArray *colors;
@property (nonatomic) int mode;

- (void) setPosition:(CGPoint)point;
- (void) recoverToPreviousPosition;
- (void) savePersistentColors;
- (void) restorePersistentColors;
- (void) removePersistentColors;

@end
