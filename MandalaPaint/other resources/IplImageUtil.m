//
//  IplImageUtil.m
//  MyOpenCV
//
//  Created by 岡田 一志 on 10/05/29.
//  Copyright 2010 xHills. All rights reserved.
//

#import "IplImageUtil.h"
#import "opencv/cv.h"

//
// UIImageとIplImage(OpenCV)を変換するユーティリティ
//
@implementation IplImageUtil

// NOTE 戻り値は利用後cvReleaseImage()で解放してください
+ (IplImage*) createIplImageFromUIImage:(UIImage*)image
{
	// CGImageをUIImageから取得
	CGImageRef imageRef = image.CGImage;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	// 一時的なIplImageを作成
	IplImage *iplimage = cvCreateImage(cvSize(image.size.width, image.size.height), 
									   IPL_DEPTH_8U, 
									   4);
	// CGContextを一時的なIplImageから作成
	CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData,
													iplimage->width, 
													iplimage->height,
													iplimage->depth,
													iplimage->widthStep,
													colorSpace,
													kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
	// CGImageをCGContextに描画
	CGContextDrawImage(contextRef,
					   CGRectMake(0, 0, image.size.width, image.size.height),
					   imageRef);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(colorSpace);
	
	// 最終的なIplImageを作成
	IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
//	cvCvtColor(iplimage, ret, CV_RGBA2BGR);
	cvCvtColor(iplimage, ret, CV_RGBA2RGB);
	cvReleaseImage(&iplimage);
	
	return ret;
}

// NOTE IplImageは事前にRGBモードにしておいてください。
+ (UIImage*) createUIImageFromIplImage:(IplImage*)image 
{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	// CGImageのためのバッファを確保
	NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
	CGDataProviderRef provider =
    CGDataProviderCreateWithCFData((CFDataRef)data);
	// IplImageのデータからCGImageを作成
	CGImageRef imageRef = CGImageCreate(image->width, 
										image->height,
										image->depth, 
										image->depth * image->nChannels, 
										image->widthStep,
										colorSpace,
										kCGImageAlphaNone|kCGBitmapByteOrderDefault,
										provider, 
										NULL, 
										false,
										kCGRenderingIntentDefault);
	// UIImageをCGImageから取得
	UIImage *ret = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	return ret;
}

@end
