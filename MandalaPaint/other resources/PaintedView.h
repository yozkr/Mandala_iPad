//
//  PaintedView.h
//  MyOpenCV
//
//  Created by 岡田 一志 on 10/05/29.
//  Copyright 2010 xHills. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv/cv.h>
#import <AudioToolbox/AudioToolbox.h>

//
// XHFillPoint
//
@interface XHFillPoint : NSObject
{
	CGPoint point;
	UIColor *color;
}
@property (nonatomic) CGPoint point;
@property (nonatomic, retain) UIColor *color;
@end

//
// XHHistImage
//
@interface XHHistImage : NSObject
{
	IplImage *image;
}
@property (nonatomic) IplImage *image;
@end

//
// PaintedView
//
@interface PaintedView : UIView 
{
	// RAWイメージ
	IplImage *rawImage;
	
	// ペンの色
	UIColor	*penColor;
	
	// 履歴の最大数
	int maxHistory;
	
	// クリックしたポイント
	NSMutableArray *points;
	
	// 履歴（UNDOのため）
	NSMutableArray *hisotries;
	
	// 保存後に変更されたか否か 
	BOOL isChanged;
	
	// 音声ファイル
	SystemSoundID soundID_paint;
	SystemSoundID soundID_cat;
	SystemSoundID soundID_delete;
}
@property (nonatomic, retain) UIColor *penColor;
@property (nonatomic) BOOL isChanged;

- (void) setImage:(UIImage*)image;
- (void) undoPreviousFill;
//- (void) changeToEdgeImage;
- (void) savePNGImage:(NSString*)path;
- (void) saveImageToCameraRoll:(NSString*)path caller:(id)aCaller;
@end

