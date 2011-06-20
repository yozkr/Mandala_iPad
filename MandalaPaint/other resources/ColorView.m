//
//  ColorView.m
//  MyOpenCV
//
//  Created by 岡田 一志 on 10/06/09.
//  Copyright 2010 xHills. All rights reserved.
//

#import "ColorView.h"


//
// ColorView　（パレット上の色）
//
@implementation ColorView

@synthesize delegate;
@synthesize color;
@synthesize mode;

- (void) dealloc 
{
	[delegate release];
	[color release];
	[maskImage release];
	AudioServicesDisposeSystemSoundID(sound_default);

	[super dealloc];
}

// 四角の色のUIImageを作成
- (UIImage*) createColorUIImage:(UIColor*)col
{
	color = [col retain];
	const int height = self.bounds.size.height;
	const int width = self.bounds.size.width;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL,
												 width, 
												 height,
												 8, 
												 width * 4,
												 colorSpaceRef, 
												 kCGImageAlphaPremultipliedLast);
	
	const CGFloat *cs = CGColorGetComponents(col.CGColor);
	CGContextSetRGBFillColor(context, cs[0], cs[1], cs[2], cs[3]);
	CGContextFillRect(context, CGRectMake (0, 0, width, height));
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage *image = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpaceRef);
	return image;
}

// マスク処理でパレット上の色を作成
- (void) createColor:(UIColor*)col maskImagePath:(NSString*)path
{
	// 音声
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *soundPath = [bundle pathForResource:@"sound_default" ofType:@"aif"];
	NSURL *url = [NSURL fileURLWithPath:soundPath];
	AudioServicesCreateSystemSoundID((CFURLRef)url, &sound_default);
	
	// マスク処理
	[self setUserInteractionEnabled:YES];
	if (maskImage == nil)
		maskImage = [UIImage imageNamed:path];
	UIImage *iconImage = [self createColorUIImage:col];
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
	self.image = maskedImage;
	
	CGImageRelease(mask);
	CGImageRelease(masked);
}

// update color
- (void) updateColor:(UIColor*)col
{
	[self createColor:col maskImagePath:NULL];
}

// タッチイベント
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event  
{
	// 音声再生
	AudioServicesPlaySystemSound(sound_default);	
	
	// 色選択
	if ([delegate respondsToSelector:@selector(pickColor:)])
	{
		[delegate pickColor:self];
	}
	[super touchesBegan:touches withEvent:event];
}


- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event  
{
	switch (mode) 
	{
		case VIEW_MODE_MAIN:
			[super touchesMoved:touches withEvent:event];
			break;
		default:
			break;
	}
}

@end
