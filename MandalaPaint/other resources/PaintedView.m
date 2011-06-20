//
//  PaintedView.m
//  MyOpenCV
//
//  Created by 岡田 一志 on 10/05/29.
//  Copyright 2010 xHills. All rights reserved.
//

#import "PaintedView.h"
#import "IplImageUtil.h"
#import <opencv/highgui.h>

//
// XHFillPoint
//
@implementation XHFillPoint
@synthesize point;
@synthesize color;
- (void)dealloc
{
	[color release];
	[super dealloc];
}
@end

//
// XHHistImage
//
@implementation XHHistImage
@synthesize image;
- (void)dealloc
{
	cvReleaseImage(&image);
	[super dealloc];
}
@end

//
// PaintedView
//
@implementation PaintedView

@synthesize penColor;
@synthesize isChanged;

// init
- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
		penColor = [UIColor redColor];
		points = [[NSMutableArray alloc] init];
		hisotries = [[NSMutableArray alloc] init];
		maxHistory = 5; // 元に戻せる最大数
		isChanged = NO;
		
		// 音声
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"sound_default" ofType:@"aif"];
        NSURL *url = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundID_paint);
        
		path = [bundle pathForResource:@"sound_cat" ofType:@"aif"];
        url = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundID_cat);
		
		path = [bundle pathForResource:@"sound_delete" ofType:@"aif"];
        url = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundID_delete);		
	}
    return self;
}


// dealloc
- (void) dealloc
{
	AudioServicesDisposeSystemSoundID(soundID_paint);
	AudioServicesDisposeSystemSoundID(soundID_cat);
	AudioServicesDisposeSystemSoundID(soundID_delete);
	cvReleaseImage(&rawImage);
	[penColor release];
	[points release];
	[hisotries release];
    [super dealloc];
}


// タッチevents
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event 
{
	if ([touches count] == 1)
	{
		// タッチしたところを塗る
		UITouch *touch = [touches anyObject];
		XHFillPoint *fillPoint = [[XHFillPoint alloc] init];
		fillPoint.point = [touch locationInView:self];
		fillPoint.color = [[UIColor alloc] initWithCGColor:penColor.CGColor];
		[points addObject:fillPoint];
		[self setNeedsDisplay];
		[fillPoint release];
		
		// 音声の再生
		int r = rand() % 15; // 15回に1回に変な音
		if (r == 0)
		{
			AudioServicesPlaySystemSound(soundID_cat);
		}
		else 
		{
			AudioServicesPlaySystemSound(soundID_paint);
		}
		
		// タッチされたら「変更された」というステータスになる
		isChanged = YES;
	}
}


// imageをセット
- (void) setImage:(UIImage*)image
{
	if (rawImage != nil)
		cvReleaseImage(&rawImage);
	rawImage = [IplImageUtil createIplImageFromUIImage:image];
}


//
// Edge検出
//
/*
- (void) changeToEdgeImage
{
	// Create grayscale IplImage from UIImage
	IplImage *grayImage = cvCreateImage(cvGetSize(rawImage), IPL_DEPTH_8U, 1);
	cvCvtColor(rawImage, grayImage, CV_BGR2GRAY);
	
	// Edgeの検出
	IplImage *cannyImage = cvCreateImage(cvGetSize(grayImage), IPL_DEPTH_8U, 1);
	cvCanny(grayImage, cannyImage, 64, 128, 3);
	
	// Convert black and whilte to 24bit image then convert to UIImage to show
	cvReleaseImage(&rawImage);
	rawImage = cvCreateImage(cvGetSize(cannyImage), IPL_DEPTH_8U, 3);
	for (int y = 0; y < cannyImage->height; y++)
	{
		for (int x = 0; x < cannyImage->width; x++)
		{
			char *p = rawImage->imageData + y * rawImage->widthStep + x * 3;
			// HACK: 白黒を反転させるため、０と-1を入れ替える
			if (cannyImage->imageData[y * cannyImage->widthStep + x] == 0)
			{// 0 -> -1
				*(p + 2) = -1;
			}
			else 
			{// -1 -> 0
				*(p + 2) = 0;
			}
			*p = *(p + 1) = *(p + 2);
		}
	}
	cvReleaseImage(&grayImage);
	cvReleaseImage(&cannyImage);
	
	[self setNeedsDisplay];
}
 */



// PNG image保存
- (void) savePNGImage:(NSString*)path
{
	UIImage *fillImage = [IplImageUtil createUIImageFromIplImage:rawImage];
	NSData *data = UIImagePNGRepresentation(fillImage);
	// debug: NSLog(@"saved path = %@ ¥n", path);
	if (![data writeToFile:path atomically:NO])
	{
		// NOTE skip: NSLog(@"error %@ ¥n", path);
	}
	
//	UIImage *thumbnail = [fillImage imageByScalingProportionallyToSize:CGSizeMake(55, 55)];
	UIImage *thumbnail = [fillImage resizeImage:CGSizeMake(300, 300)];
	NSData *thumbnailData = UIImagePNGRepresentation(thumbnail);
	NSString *tpath = [path getThumbnailPath];
	[thumbnailData writeToFile:tpath atomically:NO];

	// 保存後、「変更されていない」というステータスに変更
	isChanged = NO;
}

// カメラロールにファイル保存
- (void) saveImageToCameraRoll:(NSString*)path caller:(id)aCaller
{
	// カメラロールにファイル保存
	UIImage *fillImage = [IplImageUtil createUIImageFromIplImage:rawImage];
	UIImageWriteToSavedPhotosAlbum(fillImage,
								   aCaller,
								   @selector(localSavedImage:didFinishSavingWithError:contextInfo:),
								   nil);
	// 保存後、「変更されていない」というステータスに変更
	isChanged = NO;
	
	// 一時ファイルを削除
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) 
	{
		NSError* error;
		[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
	}
	if ([[NSFileManager defaultManager] fileExistsAtPath:[path getThumbnailPath]]) 
	{
		NSError* error;
		[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
	}
}

// 履歴からUNDOして最新のものを削除
- (void) undoPreviousFill
{
	if ([hisotries count] <= 0) 
		return;

	// 音声再生
	AudioServicesPlaySystemSound(soundID_delete);

	cvReleaseImage(&rawImage);
	XHHistImage *hist = [hisotries lastObject];
	rawImage = cvCloneImage(hist.image);
	[hisotries removeLastObject];
	//[hist release];
	
	[self setNeedsDisplay];
}


// 指定した同色の場所に色を塗る
- (void) fillPointedArea:(IplImage*)image 
					   x:(int)x 
					   y:(int)y 
				   color:(UIColor*)color
				  vertex:(CGPoint)vertex
{
	// 履歴として保存
	XHHistImage *hist;
	if ([hisotries count] >= maxHistory)
	{
		[hisotries removeObjectAtIndex:0];
	}
	hist = [[XHHistImage alloc] init];
	hist.image = cvCloneImage(rawImage);
	[hisotries addObject:hist];
	
	//float xx = x * (1 / sizeRate);
	//float yy = y * (1 / sizeRate);
	//CvPoint seed = cvPoint(xx - vertex.x, yy - vertex.y);
	CvPoint seed = cvPoint(x, y);
	
	int connectivity = 4;
	int new_mask_val = 255;
	int lo = 0; // lo_diff;
	int up = 0; // up_diff;
	int flags = connectivity + (new_mask_val << 8) + CV_FLOODFILL_FIXED_RANGE;
	const CGFloat *cs = CGColorGetComponents(color.CGColor);
	int r = cs[0] * 255;
	int g = cs[1] * 255; 
	int b = cs[2] * 255; 
	CvConnectedComp comp;
	// fill
	cvFloodFill(image,
				seed, 
				CV_RGB(b, g, r), // CV_RGB(r, g, b), 
				CV_RGB(lo, lo, lo),
				CV_RGB(up, up, up),
				&comp,
				flags, 
				NULL);
	[hist release];
}


// 描画 (override)
- (void) drawRect:(CGRect)rect
{
	@try 
	{
		// 塗り絵
		CGPoint vertex = CGPointMake(0, 0);
		//assert([points count] <= 1);
		for (XHFillPoint *fillPoint in points)
		{
			CGPoint point = fillPoint.point;
			[self fillPointedArea:rawImage
								x:point.x 
								y:point.y
							color:fillPoint.color
						   vertex:vertex];
		}
		[points removeAllObjects];
		UIImage *fillImage = [IplImageUtil createUIImageFromIplImage:rawImage];
		[fillImage drawAtPoint:vertex];
	}
	@catch (NSException * e) 
	{
		// ignore
	}
}

@end

@implementation NSString (Extras)

- (NSString *)getThumbnailPath {
	NSString *tpathPrefix = @"_";
	NSString *tpath = [[self stringByDeletingLastPathComponent]
					   stringByAppendingPathComponent:
					   [tpathPrefix stringByAppendingString:[self lastPathComponent]]];
	return tpath;
}

@end


@implementation UIImage (Extras)

- (UIImage *)resizeImage:(CGSize)size {
	UIImage *image = self;
	UIImage *resultImage;
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	
	return resultImage;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0f;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0f, 0.0f);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5f; 
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5f;
        }
    }
    
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    
    [[UIColor blackColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, CGRectMake(0.0f, 0.0f, targetWidth, targetHeight));
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}

@end

