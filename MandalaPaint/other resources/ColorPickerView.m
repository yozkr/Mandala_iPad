//
//  ColorPickerView.m
//  MyOpenCV
//
//  Created by 岡田 一志 on 10/06/11.
//  Copyright 2010 xHills. All rights reserved.
//

#import "ColorPickerView.h"

//
// ColorPickerView （カラーピッカー（レインボーや色の薄さを選択するビュー））
//
@implementation ColorPickerView

@synthesize delegate;

// initWithFrame(override)
- (id) initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// dealloc
- (void) dealloc 
{
	[image release];
	[maskImage release];
	[startColor release];
	[endColor release];
    [super dealloc];
}

// create Gradient image
static CGImageRef createGradientImage(int inWidth,
									  int inHeight,
									  UIColor *inStartColor,
									  UIColor *inEndColor)
{
	// グラデーション画像
	CGImageRef theCGImage = NULL;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	// 画像バッファ
	CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL, 
															   inWidth, 
															   inHeight,
															   8,
															   0,
															   colorSpace, 
															   kCGImageAlphaPremultipliedLast);
	const int COLOR_SIZE = 12;
	if (gradientBitmapContext != NULL) 
	{
		// グラデーション
		CGFloat locations[COLOR_SIZE];
		CGColorRef colors[COLOR_SIZE];
		int count = COLOR_SIZE;
		if (inStartColor)
		{
			count = 2;
			locations[0] = 0.0;
			locations[1] = 1.0;
			colors[0] = inStartColor.CGColor;
			colors[1] = inEndColor.CGColor;
		} 
		else 
		{
			for (int i = 0; i < COLOR_SIZE; i++)
			{
				locations[i] = (double)i / (COLOR_SIZE - 1);
				UIColor* color = [UIColor 
								  colorWithHue:locations[i] 
								  saturation:1.0 
								  brightness:1.0 
								  alpha:1.0];
				colors[i] = color.CGColor;
			}
		}
		CFArrayRef array = CFArrayCreate(kCFAllocatorDefault, 
										 (const void **)colors,
										 count,
										 NULL);
		
		// グラデーション情報の作成
		CGGradientRef colorGradient	= CGGradientCreateWithColors(colorSpace,
																 array,
																 locations);
		CFRelease(array);
		// このグラデーションを、画像バッファのどの範囲に割り付けるかを設定
		CGPoint gradientStartPoint = CGPointMake(0, inHeight);
		CGPoint gradientEndPoint = CGPointZero;
		// 描画
		CGContextDrawLinearGradient(gradientBitmapContext,
									colorGradient, 
									gradientStartPoint,
									gradientEndPoint,
									kCGGradientDrawsAfterEndLocation);
		CGGradientRelease(colorGradient);
		CGContextSetRGBStrokeColor(gradientBitmapContext, 1.0, 1.0, 1.0, 1.0);
		CGContextSetLineWidth(gradientBitmapContext, 2.0);
		
		// 画像バッファをCGImageRefに変換
		theCGImage = CGBitmapContextCreateImage(gradientBitmapContext);
		CGContextRelease(gradientBitmapContext);
		
	}
	CGColorSpaceRelease(colorSpace);
    return theCGImage;
}


// 描画
- (void) drawRect:(CGRect)rect
{
	if (image == nil)
	{
		CGRect r = self.bounds;
		CGImageRef gradientRef = createGradientImage(r.size.width, 
													 r.size.height, 
													 startColor, 
													 endColor);
		if (maskImage != nil)
		{
			// マスク処理
			UIImage *iconImage = [[UIImage imageWithCGImage:gradientRef] retain];
			CGImageRef maskRef = maskImage.CGImage;
			CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
												CGImageGetHeight(maskRef),
												CGImageGetBitsPerComponent(maskRef),
												CGImageGetBitsPerPixel(maskRef),
												CGImageGetBytesPerRow(maskRef),
												CGImageGetDataProvider(maskRef), 
												NULL,
												FALSE);
			
			CGImageRef masked = CGImageCreateWithMask([iconImage CGImage], mask);
			UIImage *maskedImage = [UIImage imageWithCGImage:masked];
			image = [maskedImage retain];
			CGImageRelease(mask);
			CGImageRelease(masked);
			[iconImage release];
		}
		else 
		{
			image = [[UIImage imageWithCGImage:gradientRef] retain];
		}
		CGImageRelease(gradientRef);
	}
	[image drawAtPoint:CGPointMake(0, 0)];
}


// events
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event 
{
	[self touchesMoved:touches withEvent:event];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event 
{
    if ([delegate respondsToSelector:@selector(pickColorFromColorPickerView:color:value:)])
	{
		UITouch *touch = [touches anyObject];
		CGPoint loc = [touch locationInView:self];
		CGRect r = self.bounds;
		
		double value = loc.y / r.size.height; // 0.0〜1.0の範囲に正規化
		UIColor* color;
		if (startColor == nil) 
		{
			color = [UIColor colorWithHue:value saturation:1.0 brightness:1.0 alpha:1.0];
		} 
		else
		{
			// startColor、endColorの色要素取り出し。
			const CGFloat* startComponents = CGColorGetComponents(startColor.CGColor);
			const CGFloat* endComponents = CGColorGetComponents(endColor.CGColor);
			color = [UIColor colorWithRed:(endComponents[0] - startComponents[0]) * value + startComponents[0]
									green:(endComponents[1] - startComponents[1]) * value + startComponents[1]
									 blue:(endComponents[2] - startComponents[2]) * value + startComponents[2]
									alpha:1.0];
		}
		[delegate pickColorFromColorPickerView:self color:color value:value];
	}
}

// 両端の色を指定する。このタイミングでいったんimageをnilに戻す。
-(void)setColorAndMask:(UIColor*)inStartColor end:(UIColor*)inEndColor maskImagePath:(NSString*)path;
{
	maskImage = (path != nil ? [UIImage imageNamed:path] : nil);
	[image release];
	image = nil;
	[startColor release];
	startColor = [inStartColor retain];
	[endColor release];
	endColor = [inEndColor retain];
	[self setNeedsDisplay];
}

@end
