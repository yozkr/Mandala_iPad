//
//  IplImageUtil.h
//  MyOpenCV
//
//  Created by 岡田 一志 on 10/05/29.
//  Copyright 2010 xHills. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv/cv.h>

//
// IplImageUtil
//
@interface IplImageUtil : NSObject
{
	// do nothing
}
+ (IplImage*) createIplImageFromUIImage:(UIImage*)image;
+ (UIImage*) createUIImageFromIplImage:(IplImage*)image;
@end
