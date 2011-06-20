//
//  ColorPickerView.h
//  MyOpenCV
//
//  Created by 岡田 一志 on 10/06/11.
//  Copyright 2010 xHills. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorPickerView;

//
// Delegator
//
@protocol ColorPickerViewDelegate
// notify
-(void)pickColorFromColorPickerView:(ColorPickerView*)view color:(UIColor*)color value:(double)value;

@end

//
// カラーピッカー（レインボーなど）
//
@interface ColorPickerView : UIView 
{
	//	ユーザタッチによる色選択を通知する相手
	id<ColorPickerViewDelegate, NSObject> delegate;
	
	// グラデーション色
	UIImage *image; // グラデーション画像
	UIImage *maskImage; // マスク用イメージ
	UIColor *startColor; // グラデーションの開始色
	UIColor *endColor; // グラデーションの終了色	
}

@property (nonatomic, assign) id<ColorPickerViewDelegate, NSObject>	delegate;

//	両端の色を指定する。
-(void)setColorAndMask:(UIColor*)inStartColor end:(UIColor*)inEndColor maskImagePath:(NSString*)path;

@end
