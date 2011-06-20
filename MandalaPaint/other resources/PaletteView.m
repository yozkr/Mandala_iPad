//
//  PaletteView.m
//  MyOpenCV
//
//  Created by 岡田 一志 on 10/06/09.
//  Copyright 2010 xHills. All rights reserved.
//

#import "PaletteView.h"
#import "ColorView.h"

//
// PaletteView
//
@implementation PaletteView

@synthesize colors;
@synthesize mode;

// init
- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
		colors = [[NSMutableArray alloc] init];
		startLocation = CGPointMake(frame.origin.x, frame.origin.y);
		endLocation = CGPointMake(frame.origin.x, frame.origin.y);
	}
    return self;
}

// dealloc
- (void) dealloc
{
	[colors release];
    [super dealloc];
}

// setPosition
- (void) setPosition:(CGPoint)point
{
	CGRect frame = [self frame];  
	frame.origin.x = point.x;
	frame.origin.y = point.y;
	[self setFrame:frame];	
}

// recoverToPreviousPosition
- (void) recoverToPreviousPosition
{
	CGRect frame = [self frame];  
	frame.origin.x = endLocation.x;
	frame.origin.y = endLocation.y;
	[self setFrame:frame];
}

// 色設定の保存
- (void) savePersistentColors
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	for (int i = 0; i < [colors count]; i++)
	{
		ColorView *colorView = [colors objectAtIndex:i];
		NSString *key = [NSString stringWithFormat:@"xhills-color-%d", i];
		[defaults 
		 setObject:[NSKeyedArchiver archivedDataWithRootObject:colorView.color]
		 forKey:key];
	}
	[defaults synchronize];
}

// 保存した色設定を戻す
- (void) restorePersistentColors
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	for (int i = 0; i < [colors count]; i++)
	{
		ColorView *colorView = [colors objectAtIndex:i];
		NSString *key = [NSString stringWithFormat:@"xhills-color-%d", i];
		NSData *value = [defaults objectForKey:key];
		if (!value)
		{
			continue; // 初回起動時はスキップする
		}
		UIColor *color = [NSKeyedUnarchiver 
						  unarchiveObjectWithData:value];
		// HACK! UIColorを再作成する。
		const CGFloat *cs = CGColorGetComponents(color.CGColor);
		color = [[UIColor alloc] initWithRed:cs[0]
									   green:cs[1] 
										blue:cs[2]
									   alpha:1.0];
		[colorView updateColor:color];
		[color release];
	}
}

// 色設定をクリアする
- (void) removePersistentColors
{
	// NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	// TODO: 削除コード
}

// touch events
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event  
{
	startLocation = [[touches anyObject] locationInView:self];  
}  

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event  
{ 
	CGPoint pt = [[touches anyObject] locationInView:self];  
	CGRect frame = [self frame];  
	frame.origin.x += pt.x - startLocation.x;  
	frame.origin.y += pt.y - startLocation.y;  
	[self setFrame:frame];  
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGRect frame = [self frame];
	switch (mode)
	{
		case VIEW_MODE_MAIN:
			endLocation.x = frame.origin.x;  
			endLocation.y = frame.origin.y;
			break;
		default:
			break;
	}
}

@end
