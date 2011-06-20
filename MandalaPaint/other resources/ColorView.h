//
//  ColorView.h
//  MyOpenCV
//
//  Created by 岡田 一志 on 10/06/09.
//  Copyright 2010 xHills. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "enums.h"
#import <AudioToolbox/AudioToolbox.h>

@class ColorView;

//
// Delegator
//
@protocol ColorViewDelegate
// notify
- (void)pickColor:(ColorView*)view;
@end

//
// ColorView
//
@interface ColorView : UIImageView
{
	// Delegate
	id<ColorViewDelegate, NSObject> delegate;
	
	// 色
	UIColor *color;
	
	// マスク画像
	UIImage *maskImage;
	
	// モード（ペイントビュー or カラーピッカービュー）
	int mode;
	
	// 音声ファイル
	SystemSoundID sound_default;
}
@property (nonatomic, assign) id<ColorViewDelegate, NSObject> delegate;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic) int mode;

- (void) createColor:(UIColor*)col maskImagePath:(NSString*)path;
- (void) updateColor:(UIColor*)col;

@end
