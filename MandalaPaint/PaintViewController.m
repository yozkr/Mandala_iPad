//
//  DetailViewController.m
//  SplitView
//
//  Created by 岡本　奈緒 on 11/06/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaintViewController.h"
#import "SelectNewPaintViewController.h"

@interface PaintViewController ()
- (void)configureView;
@end

@implementation PaintViewController

@synthesize popoverController;
@synthesize barButton;
@synthesize toolbar;
@synthesize detailItem;

@synthesize selectURL;
@synthesize currentPenColorView;
@synthesize colorPickerView;

#pragma mark - Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem
{
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
        // Update the view.
        [self configureView];
    }

    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    grayColor = [[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
	darkGrayColor = [[UIColor alloc] initWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
	blackColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
	whiteColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	greenColor = [[UIColor alloc] initWithRed:0.0 green:0.75 blue:0.3 alpha:1.0];
	wineColor = [[UIColor alloc] initWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
    NSLog(@"aaaaa");
    // Update the user interface for the detail item.
    selectURL = self.detailItem;
    
    UIImage *image = [UIImage imageWithContentsOfFile:[self selectURL]];
	[paintedView setImage:image];
    [paintedView reloadInputViews];
    NSLog(@"painted");

    
    ///////////////////////////////
    
	
	

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 一時保存処理
	if (paintedView.isChanged)
	{
		UIAlertView *alertView = [[UIAlertView alloc] 
								  initWithTitle:NSLocalizedString(@"SaveTempTitle", @"save dialog title")
								  message:NSLocalizedString(@"SaveTempFile", @"")
								  delegate:self
								  cancelButtonTitle:NSLocalizedString(@"NO", @"")
								  otherButtonTitles:NSLocalizedString(@"YES", @""), nil];
		[alertView show];
		[alertView release];
	}
	else
	{
		[self refreshPreviousTableView];	
	}

	//[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    /*barButtonItem.title = @"Events";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;*/
    self.barButton = barButtonItem;
    [self addBarButtonItem:barButtonItem forPopoverController:pc];
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
   /* NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;*/
    self.barButton = barButtonItem;
    [self removeButton];
}


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    ///////////////////////////////
    // タイトル
	self.title = NSLocalizedString(@"Paint", @"");
	UIBarButtonItem *button = [[UIBarButtonItem alloc]
							   initWithTitle:NSLocalizedString(@"DefaultSize", @"")
							   style:UIBarButtonItemStylePlain
							   target:self
							   action:@selector(recoverDefaultZoomSize)
							   ];
	self.navigationItem.rightBarButtonItem = button;
	
    // 自分のNavigationControllerを保存（戻ったときに反映されるようにするため）
	previousNavigationController = self.navigationController;
	
    //イメージセット
    // ぬりえ画面
    NSBundle *mainBundle = [NSBundle mainBundle];
	NSString *filename1 = [mainBundle pathForResource:@"image1" ofType:@"png"];
	UIImage *image = [UIImage imageWithContentsOfFile:filename1];
	paintedView = [[PaintedView alloc] 
				   initWithFrame:CGRectMake(0, 45, image.size.width, image.size.height)];
	[paintedView setImage:image];
	
    // ぬりえ画面のスクロール用
	scrollView = [[UIScrollView alloc] 
				  initWithFrame:CGRectMake(0, 0, SIZE_SCROLLVIEW_UP_DOWN_W, SIZE_SCROLLVIEW_UP_DOWN_H)];
	scrollView.pagingEnabled = NO;
	scrollView.maximumZoomScale = ZOOM_MAX_SIZE;
	scrollView.minimumZoomScale = ZOOM_MIN_SIZE;
    scrollView.contentSize = CGSizeMake(500, 500);  
    scrollView.showsHorizontalScrollIndicator = YES;  
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
	scrollView.zoomScale = ZOOM_DEFAULT_SIZE; // デフォルトサイズ
	[self.view addSubview:scrollView];
	[scrollView addSubview:paintedView];
		
	// パレット
    palette = [[PaletteView alloc]
			   initWithFrame:CGRectMake(POS_PALETTE_MAINMODE_X, 
										POS_PALETTE_MAINMODE_Y, 
										SIZE_PALLETE_W, 
										SIZE_PALLETE_H)];  
    [palette setUserInteractionEnabled:YES];  
    [palette setImage:[UIImage imageNamed:@"palette.png"]];  
    [self.view addSubview:palette];  
	
	NSArray *colors = [[NSArray alloc] 
					   initWithObjects:[UIColor redColor],
					   [UIColor purpleColor],
					   [UIColor yellowColor],
					   [UIColor cyanColor],
					   [UIColor greenColor],
					   whiteColor,
					   nil];
	CGSize size = CGSizeMake(SIZE_COLOR_ON_PALETTE, SIZE_COLOR_ON_PALETTE);
	NSArray *origins = [[NSArray alloc] 
						initWithObjects:[NSValue valueWithCGRect:CGRectMake(75, 5, size.width, size.height)],
						[NSValue valueWithCGRect:CGRectMake(30, 15, size.width, size.height)],
						[NSValue valueWithCGRect:CGRectMake(15, 60, size.width, size.height)],
						[NSValue valueWithCGRect:CGRectMake(35, 100, size.width, size.height)],
						[NSValue valueWithCGRect:CGRectMake(80, 100, size.width, size.height)],
						[NSValue valueWithCGRect:CGRectMake(120, 90, size.width, size.height)],
						nil];
	NSArray *paths = [[NSArray alloc]
					  initWithObjects:@"mask4.png", @"mask1.png", @"mask2.png",
					  @"mask4.png", @"mask3.png", @"mask5.png", nil];
	ColorView *color;
	for (int i = 0; i < [colors count]; i++)
	{
		CGRect origin = [[origins objectAtIndex:i] CGRectValue];
		color = [[ColorView alloc] initWithFrame:origin];
		color.delegate = self;
		[color
		 createColor:[colors objectAtIndex:i] 
		 maskImagePath:[paths objectAtIndex:i]];
		[palette addSubview:color];
		[palette.colors addObject:color];
		[color release];
	}
	// パレットの色の最終状態をロード
	[palette restorePersistentColors];
	
	[colors release];
	[origins release];
	[paths release];
	
	// カラーピッカー画面 -- ColorPickerViewは初期状態で隠す (表示は最前面) --
	colorPickerBaseView = [[ColorPickerBaseView alloc]
						   initWithFrame:self.view.bounds];
	colorPickerBaseView.backgroundColor = [[UIColor alloc] 
										   initWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
	[self.view addSubview:colorPickerBaseView];
	[self.view bringSubviewToFront:colorPickerBaseView];
	colorPickerBaseView.hidden = YES;
	
	hue = 0.5;
	saturation = 0.5;
	brightness = 0.5;
	colorPickerBackGoundView = [[UIImageView alloc] 
								initWithFrame:colorPickerBaseView.bounds];
	//colorPickerBackGoundView.image = [UIImage imageNamed:@"background2.png"]; // 背景
	[colorPickerBaseView addSubview:colorPickerBackGoundView];
	colorPickerView = [[ColorPickerView alloc]
					   initWithFrame:CGRectMake(POS_PICKER_CONNER_X, 
												POS_PICKER_CONNER_Y, 
												SIZE_PICKER_RAI_W,
												SIZE_PICKER_RAI_H)];
	[colorPickerView // レインボーピッカー
	 setColorAndMask:nil 
	 end:nil 
	 maskImagePath:@"mask_kakumaru_l.png"];
	[colorPickerBaseView addSubview:colorPickerView];
	colorPickerView.delegate = self;
	
	brightnessPickerView = [[ColorPickerView alloc]
							initWithFrame:CGRectMake(POS_PICKER_CONNER_X + SIZE_PICKER_RAI_W + SIZE_PICKER_SPACE,
													 POS_PICKER_CONNER_Y,
													 SIZE_PICKER_SAT_W,
													 SIZE_PICKER_SAT_H)];
	[colorPickerBaseView addSubview:brightnessPickerView];
	[brightnessPickerView // 明るさピッカー
	 setColorAndMask:[UIColor colorWithHue:hue saturation:saturation brightness:1.0 alpha:1.0]
	 end:[UIColor colorWithHue:hue saturation:saturation brightness:0.0 alpha:1.0]
	 maskImagePath:@"mask_kakumaru_s.png"];
	brightnessPickerView.delegate = self;
	
	NSArray *miniPickerColors = [[NSArray alloc] 
								 initWithObjects:[UIColor redColor], 
								 [UIColor cyanColor],
								 [UIColor blueColor],
								 grayColor,
								 darkGrayColor,
								 blackColor,
								 whiteColor,
								 nil];
	ColorPickerView *miniPicker; // ミニピッカー
	CGRect miniPickerRect = CGRectMake(POS_MINI_PICKER_X, 
									   POS_MINI_PICKER_Y, 
									   SIZE_MINI_PICKER, 
									   SIZE_MINI_PICKER);
	for (UIColor *color in miniPickerColors)
	{
		miniPicker = [[ColorPickerView alloc]
					  initWithFrame:CGRectMake(miniPickerRect.origin.x, 
											   miniPickerRect.origin.y, 
											   miniPickerRect.size.width, 
											   miniPickerRect.size.height)];
		[miniPicker setColorAndMask:color end:color maskImagePath:@"mask_slim.png"];
		miniPicker.delegate = self;
		[colorPickerBaseView addSubview:miniPicker];
		miniPickerRect.origin.x += SIZE_COLOR_ON_PALETTE;
		[miniPicker release];
	}
	[miniPickerColors release];
	
	miniPickerRect.origin = CGPointMake(POS_MINI_PICKER_X, 
										POS_MINI_PICKER_Y + SIZE_MINI_PICKER + SIZE_PICKER_SPACE);
	miniPickerColors = [[NSArray alloc] 
						initWithObjects:[UIColor orangeColor], 
						[UIColor yellowColor],
						[UIColor greenColor],
						greenColor,
						[UIColor purpleColor],
						wineColor,
						[UIColor brownColor],
						nil];
	for (UIColor *color in miniPickerColors)
	{
		miniPicker = [[ColorPickerView alloc]
					  initWithFrame:CGRectMake(miniPickerRect.origin.x, 
											   miniPickerRect.origin.y, 
											   miniPickerRect.size.width, 
											   miniPickerRect.size.height)];
		[miniPicker setColorAndMask:color end:color maskImagePath:@"mask_slim.png"];
		miniPicker.delegate = self;
		[colorPickerBaseView addSubview:miniPicker];
		miniPickerRect.origin.x += SIZE_COLOR_ON_PALETTE;
		[miniPicker release];
	}
	[miniPickerColors release];
	
	// close button
	closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[closeButton setImage:[UIImage imageNamed:@"close.png"]
				 forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(closeColorPicker:)
		  forControlEvents:UIControlEventTouchDown];
	closeButton.frame = CGRectMake(10, 10, 35, 35);
	[colorPickerBaseView addSubview:closeButton];
	
	// その他のsettings
	selectedColorView = [palette.colors objectAtIndex:0];
	currentPenColorView.backgroundColor = paintedView.penColor;
    [super viewDidLoad];
}


- (void)viewDidUnload
{
	[super viewDidUnload];

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [popoverController release];
    [toolbar release];
    [detailItem release];

    
    [selectURL release];
	[currentPenColorView release];
	for (ColorView *colorView in palette.colors)
	{
		[colorView release];
	}
	[scrollView release];
	[paintedView release];
	[palette release];
	[colorPickerBackGoundView release];
	[colorPickerBaseView release];
	//[toInterfaceOrientation release];	
	[colorPickerView release];
	[brightnessPickerView release];
	[selectedColorView release];
	[previousNavigationController release];
	
	[grayColor release];
	[darkGrayColor release];
	[blackColor release];
	[whiteColor release];
	[greenColor release];
	[wineColor release];

    [super dealloc];
}

- (void)addBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    UIBarButtonItem *first = nil;
    if (toolbar.items.count > 0) {
        first = [toolbar.items objectAtIndex:0];
    }
    if (![first.title isEqual:barButtonItem.title])  {
        barButtonItem.title = @"Root List";
        NSMutableArray *items = [[toolbar items] mutableCopy];
        [items insertObject:barButtonItem atIndex:0];
        [toolbar setItems:items animated:YES];
        [items release];
        self.popoverController = pc;
    }
}

- (void)removeButton {
    if (toolbar.items.count > 0) {
        NSMutableArray *items = [[toolbar items] mutableCopy];
        [items removeObjectAtIndex:0];
        [toolbar setItems:items animated:YES];
        [items release];
        self.popoverController = nil;
    }
}

// 一時保存
- (void) saveTemporaryImage
{
	// ファイルを一時保存する（変更済みなら）
	NSString *path = [NSString 
					  stringWithFormat:@"%@/%@", 
					  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],
					  [selectURL lastPathComponent]]; 
	[paintedView savePNGImage:path];
	
	// パレットの色の最終状態を保存
	[palette savePersistentColors];
}

// 前画面のテーブルビューの画像を更新
- (void) refreshPreviousTableView
{
	// tableViewの更新
	/*if ([previousNavigationController.topViewController isKindOfClass:[SelectSavePaintViewController class]])
	{
		SelectSavePaintViewController *tableController = (SelectSavePaintViewController *)previousNavigationController.topViewController;
		[tableController reload];
	}	*/
}

// ファイル一時保存か否かのアラートビュー処理
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if (buttonIndex == 1) 
	{
		[self saveTemporaryImage];
		[self refreshPreviousTableView];
	}
}

// 回転モードをチェック（縦向きか否か）
- (BOOL) isUpsideDown
{
	if (!toInterfaceOrientation)
	{
		return TRUE;
	}
	return (toInterfaceOrientation == UIInterfaceOrientationPortrait || 
			toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

// パレットを隠す
- (IBAction) showPalette:(id)sender
{
	palette.hidden = !palette.hidden;
}

// パレットの位置変更
- (void) changePalettePosition
{
	CGPoint point;
	if (palette.mode == VIEW_MODE_MAIN)
	{
		point = ([self isUpsideDown] ? 
				 CGPointMake(POS_PALETTE_MAINMODE_X, POS_PALETTE_MAINMODE_Y) :
				 CGPointMake(POS_PALETTE_PICKMODE_X, POS_PALETTE_PICKMODE_Y));
	}
	else
	{
		point = ([self isUpsideDown] ? 
				 CGPointMake(POS_PALETTE_UP_DOWN_X, POS_PALETTE_UP_DOWN_Y) :
				 CGPointMake(POS_PALETTE_LEFT_RIGHT_X, POS_PALETTE_LEFT_RIGHT_Y));
	}
	[palette setPosition:point];		
}

// ColorPicker画面を閉じる
- (void) closeColorPicker:(id)sender
{
	// 非表示
	palette.mode = VIEW_MODE_MAIN;
	[self.view addSubview:palette];
	for (ColorView *colorView in palette.colors)
		colorView.mode = VIEW_MODE_MAIN;
	[palette recoverToPreviousPosition];
	
	colorPickerBaseView.hidden = !colorPickerBaseView.hidden;
	// パレットの位置変更
	[self changePalettePosition];
    
}

// 塗り絵画像を元のサイズに戻す
- (void) recoverDefaultZoomSize
{
	scrollView.zoomScale = ZOOM_DEFAULT_SIZE;
}

// スクロールのためのイベント (override)
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return paintedView;
	
}
- (void) scrollViewDidEndZooming:(UIScrollView*)scrollView 
						withView:(UIView*)view 
						 atScale:(float)scale
{
	// do nothing
}

// 色選択のViewを表示 (Delegator)
- (IBAction) showColorPickerView:(id)sender
{
	[palette removeFromSuperview];
	if (colorPickerBaseView.hidden)
	{
		// パレットをColorPickerBaseViewに移動して表示
		palette.mode = VIEW_MODE_COLOR_PICKER;
		[colorPickerBaseView addSubview:palette];
		for (ColorView *colorView in palette.colors)
			colorView.mode = VIEW_MODE_COLOR_PICKER;
		if (palette.hidden) palette.hidden = NO;
	}
	else
	{
		// 非表示
		palette.mode = VIEW_MODE_MAIN;
		[self.view addSubview:palette];
		for (ColorView *colorView in palette.colors)
			colorView.mode = VIEW_MODE_MAIN;
		[palette recoverToPreviousPosition];
	}
	colorPickerBaseView.hidden = !colorPickerBaseView.hidden;
	// パレットの位置変更
	[self changePalettePosition];
}

// 塗った操作を一個もとに戻す
- (IBAction) onUndo:(id)sender
{
	[paintedView undoPreviousFill];
}

// 保存
- (IBAction) onSave:(id)sender
{
	saveAlertType = 0;
	// 一時保存かカメラロール保存かを選択
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:NSLocalizedString(@"SaveTitle", @"save dialog title")
								  delegate:self
								  cancelButtonTitle:@"Cancel"
								  destructiveButtonTitle:nil
								  otherButtonTitles:NSLocalizedString(@"SaveTempTitle", @""), NSLocalizedString(@"SaveTitle", @""), nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

// カメラロールへ保存した後の確認画面
- (void) localSavedImage:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void *)contextInfo
{
	saveAlertType = 1;
	UIAlertView *alertView;
    if(!error)
	{
        alertView = [[UIAlertView alloc] 
					 initWithTitle:NSLocalizedString(@"SaveTitle", @"save dialog title")
					 message:NSLocalizedString(@"SaveSucceeded", @"")
					 delegate:self
					 cancelButtonTitle:nil
					 otherButtonTitles:@"OK", nil];
    }
	else
	{
        alertView = [[UIAlertView alloc] 
					 initWithTitle:NSLocalizedString(@"SaveTitle", @"save dialog title")
					 message:NSLocalizedString(@"SaveFailed", @"")
					 delegate:self
					 cancelButtonTitle:nil
					 otherButtonTitles:@"OK", nil];
    }
	[alertView show];
	[alertView release];
}

// 保存時のアラート
- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	NSLog(@"kiteruyo:%d, :%d", buttonIndex, saveAlertType);
	NSString *path = [NSString 
					  stringWithFormat:@"%@/%@", 
					  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],
					  [selectURL lastPathComponent]];
	switch (saveAlertType)
	{
		case 0: // 保存ボタン
			switch (buttonIndex) 
		{
			case 0:
				[self saveTemporaryImage];
				break;
			case 1:
				[paintedView saveImageToCameraRoll:path caller:self];
				break;
			case 2:
				// キャンセル（スキップ）
				break;
			default:
				break;
		}
			break;
		case 1: // 上記で保存を選択したらポップアップで保存成功か否かを表示
			if ([actionSheet.title compare:NSLocalizedString(@"SaveTitle", @"")] == 0) 
			{
				[self.navigationController popViewControllerAnimated:YES];
			}
			break;			
		default:
			break;
	}
}

// ------- Delegator -------

// hue値を計算する。 see Wikipedia.
// http://ja.wikipedia.org/wiki/HSV%E8%89%B2%E7%A9%BA%E9%96%93
- (float) calHueColor:(UIColor *)c
{
	const CGFloat *cs = CGColorGetComponents(c.CGColor);
	float r = cs[0];
	float g = cs[1];
	float b = cs[2];
	float max = MAX3(r, g, b);
	float min = MIN3(r, g, b);
	float h = 0;
	if (max == r)
		h = 60 * ((g - b) / (max - min)) + 0;
	else if (max == g)
		h = 60 * ((b - r) / (max - min)) + 120;
	else
		h = 60 * ((r - g) / (max - min)) + 240;
	if (h < 0) h += 360;
	return h;
}

// brightness(ColorPickerView)の色変更
- (void) changeBrightnessPickerView:(UIColor *)color
{
	// HSV colorの計算
	float value = [self calHueColor:color] / 360;
	if (isnan(value) || isinf(value))
	{
		[brightnessPickerView
		 setColorAndMask:[UIColor colorWithHue:0.0 saturation:0.0 brightness:1.0 alpha:1.0]
		 end:[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.0 alpha:1.0]
		 maskImagePath:@"mask_kakumaru_s.png"];
	}
	else
	{
		hue = value;
		[brightnessPickerView
		 setColorAndMask:[UIColor colorWithHue:hue saturation:saturation brightness:1.0 alpha:1.0]
		 end:[UIColor colorWithHue:hue saturation:saturation brightness:0.0 alpha:1.0]
		 maskImagePath:@"mask_kakumaru_s.png"];
	}
}

// 現在の色ペンを取得（設定）(notify from ColorView)
- (void) pickColor:(ColorView*)view
{
	paintedView.penColor = view.color;
	currentPenColorView.backgroundColor = view.color;
	if (!selectedColorView) [selectedColorView release];
	selectedColorView = view;
    
	// HSV colorの計算
	[self changeBrightnessPickerView:view.color];
}

// カラーピッカーで色選択中 (notify from ColorPickerView)
- (void) pickColorFromColorPickerView:(ColorPickerView*)view color:(UIColor*)color value:(double)value
{
	if (value < 0 || value > 1) return;
	if (view == colorPickerView) 
	{
		hue = value;
		[brightnessPickerView
		 setColorAndMask:[UIColor colorWithHue:hue saturation:saturation brightness:1.0 alpha:1.0]
		 end:[UIColor colorWithHue:hue saturation:saturation brightness:0.0 alpha:1.0]
		 maskImagePath:@"mask_kakumaru_s.png"];
	}
	else if (view == brightnessPickerView) 
	{
		brightness = value;
	}
	else
	{
		[self changeBrightnessPickerView:color];
	}
    
	const CGFloat *cs = CGColorGetComponents(color.CGColor);
	UIColor *updatedColor = [[UIColor alloc] initWithRed:cs[0] green:cs[1] blue:cs[2] alpha:cs[3]];
	[selectedColorView updateColor:updatedColor];
	[updatedColor release];
	paintedView.penColor = color;
	currentPenColorView.backgroundColor = color;
}


// デバイスの向き変更（回転）開始
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)_toInterfaceOrientation duration:(NSTimeInterval)duration 
{
	// toInterfaceOrientationを保存
	toInterfaceOrientation = _toInterfaceOrientation;
	if ([self isUpsideDown])
	{
		scrollView.transform = CGAffineTransformMakeScale(1.0, 1.0); // 縦向き
	} 
	else
	{
		// 300（横モード時の高さ） / 460（縦モード時の高さ） = 0.652
		scrollView.transform = CGAffineTransformMakeScale(0.652, 0.652); // 横向き
	}
	
	// スケーリングで左上の位置がずれるので、(0, 0)座標に移動させる
	CGRect frame = scrollView.frame;
	frame.origin.x = 0;
	frame.origin.y = 0;
	scrollView.frame = frame;
	
	frame = colorPickerBaseView.frame;
	frame.origin.x = 0;
	frame.origin.y = 0;
	colorPickerBaseView.frame = frame;
	frame = colorPickerBackGoundView.frame;
	frame.origin.x = 0;
	frame.origin.y = 0;
	colorPickerBackGoundView.frame = frame;
}


// デバイスの向き変更（回転）完了
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
	CGSize size;
	// fromInterfaceOrientationだけでは縦になったのか横になったのか判断出来ないので
	// 保存しておいたtoInterfaceOrientationを使って判断する
	// 縦／横サイズ
	size = ([self isUpsideDown] ? 
			CGSizeMake(SIZE_SCROLLVIEW_UP_DOWN_W, SIZE_SCROLLVIEW_UP_DOWN_H) : 
			CGSizeMake(SIZE_SCROLLVIEW_LEFT_RIGHT_W, SIZE_SCROLLVIEW_LEFT_RIGHT_H));
	CGRect frame = scrollView.frame;
	frame.size.height = size.height;
	frame.size.width = size.width;
	scrollView.frame = frame;
	
	// カラーピッカーの位置変更
	frame = colorPickerBaseView.frame;
	frame.size.height = self.view.bounds.size.height;
	frame.size.width = self.view.bounds.size.width;
	colorPickerBaseView.frame = frame;
	
	frame = colorPickerBackGoundView.frame;
	frame.size.height = self.view.bounds.size.height;
	frame.size.width = self.view.bounds.size.width;
	[self changePalettePosition];
	colorPickerBackGoundView.frame = frame;
	
}


@end
