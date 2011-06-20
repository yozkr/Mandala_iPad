//
//  DetailViewController.h
//  SplitView
//
//  Created by 岡本　奈緒 on 11/06/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintedView.h"
#import "PaletteView.h"
#import "ColorPickerBaseView.h"
#import "ColorPickerView.h"
#import "ColorView.h"
#import "enums.h"

// ３つのうちの最大／最小を計算する関数
#define MIN3(x,y,z)  ((y) <= (z) ? \
((x) <= (y) ? (x) : (y)) \
: \
((x) <= (z) ? (x) : (z)))

#define MAX3(x,y,z)  ((y) >= (z) ? \
((x) >= (y) ? (x) : (y)) \
: \
((x) >= (z) ? (x) : (z)))

/* ズームのサイズ */
#define ZOOM_DEFAULT_SIZE 0.6 // 初期サイズ
#define ZOOM_MAX_SIZE 5.0 // 最大ズームサイズ
#define ZOOM_MIN_SIZE 0.2 // 最小ズームサイズ

/* スクロールビューのサイズ（縦モード版） */
#define SIZE_SCROLLVIEW_UP_DOWN_W 500 // 横幅
#define SIZE_SCROLLVIEW_UP_DOWN_H 480 // 縦幅
/* スクロールビューのサイズ（横モード版） */
#define SIZE_SCROLLVIEW_LEFT_RIGHT_W 500 // 横幅
#define SIZE_SCROLLVIEW_LEFT_RIGHT_H 800 // 縦幅

/* パレットのポジション（縦モード版） */
#define POS_PALETTE_UP_DOWN_X 70 // X座標
#define POS_PALETTE_UP_DOWN_Y 250 // Y座標
/* パレットのポジション（横モード版） */
#define POS_PALETTE_LEFT_RIGHT_X 290
#define POS_PALETTE_LEFT_RIGHT_Y 120

/* パレットのポジション（メイン画面時） */
#define POS_PALETTE_MAINMODE_X 520
#define POS_PALETTE_MAINMODE_Y 540
/* パレットのポジション（カラーピッカービュー画面時） */
#define POS_PALETTE_PICKMODE_X 290
#define POS_PALETTE_PICKMODE_Y 100
/* パレットのサイズ */
#define SIZE_PALLETE_W 200
#define SIZE_PALLETE_H 150
/* パレット上の色の幅サイズ */
#define SIZE_COLOR_ON_PALETTE 40

/* カラーピッカービュー */
#define SIZE_PICKER_SPACE 10 // ピッカー間の幅
#define POS_PICKER_CONNER_X 20 // ピッカーの端位置（起点）
#define POS_PICKER_CONNER_Y 50 // 同上（起点）
#define SIZE_PICKER_RAI_W 190 // レインボーピッカーサイズ
#define SIZE_PICKER_RAI_H 100 // 同上
#define SIZE_PICKER_SAT_W 70 // 採光ピッカーのサイズ
#define SIZE_PICKER_SAT_H SIZE_PICKER_RAI_H // 同上
#define POS_MINI_PICKER_X POS_PICKER_CONNER_X // ミニピッカー（単色のやつ）
#define POS_MINI_PICKER_Y POS_PICKER_CONNER_Y + SIZE_PICKER_RAI_H + SIZE_PICKER_SPACE // 同上
#define SIZE_MINI_PICKER 30 // ミニピッカーの幅サイズ

@interface PaintViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIScrollViewDelegate, ColorViewDelegate, ColorPickerViewDelegate, UIActionSheetDelegate> {
    
    UIPopoverController *popoverController;
    UIBarButtonItem *barButton;
    UIToolbar *toolbar;
    id detailItem;
    
    //塗り絵用
    // ファイルURL
	NSString *selectURL;
	
	// 現在選択中の色を表示するところ
	UIView *currentPenColorView;
	
	// 塗り絵の本体
	PaintedView *paintedView;
	
	// 画面スクロール用
	UIScrollView *scrollView;
	
	// パレット
	PaletteView *palette;
	
	// 色選択画面
	ColorPickerBaseView *colorPickerBaseView;
	
	// 色選択画面背景
	UIImageView *colorPickerBackGoundView;
	
	// iPhone回転用
	UIInterfaceOrientation toInterfaceOrientation;
	
	// 色選択グラデーション
	ColorPickerView *colorPickerView;
	ColorPickerView *brightnessPickerView;
	double hue;
	double saturation;
	double brightness;
	
	// 閉じるボタン
	UIButton *closeButton;
	
	// 選択されたColorView
	ColorView *selectedColorView;
	
	// 色
	UIColor *grayColor;
	UIColor *darkGrayColor;
	UIColor *blackColor;
	UIColor *whiteColor;
	UIColor *greenColor;
	UIColor *wineColor;
	
	// UITableViewController
	UINavigationController *previousNavigationController;
	
	// 保存時alertの識別
	int saveAlertType;


}

@property (nonatomic, retain) IBOutlet UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *barButton;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;


@property (nonatomic, retain) NSString *selectURL;
@property (nonatomic, retain) IBOutlet UIView *currentPenColorView;
@property (nonatomic, retain) IBOutlet ColorPickerView *colorPickerView;

- (IBAction)showPalette:(id)sender;
- (IBAction)showColorPickerView:(id)sender;
- (IBAction)onUndo:(id)sender;
- (IBAction)onSave:(id)sender;

- (void)addBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc;
- (void)removeButton;

- (void)showPalette:(id)sender;
- (void)showColorPickerView:(id)sender;
- (void)onUndo:(id)sender;
- (void)onSave:(id)sender;

@end
