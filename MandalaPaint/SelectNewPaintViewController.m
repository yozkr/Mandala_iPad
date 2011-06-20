//
//  RootViewController.m
//  SplitView
//
//  Created by 岡本　奈緒 on 11/06/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectNewPaintViewController.h"

#import "PaintViewController.h"

@implementation SelectNewPaintViewController
		
@synthesize detailViewController;
@synthesize imageList;
@synthesize urlList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    
    //edit 
    self.title = NSLocalizedString(@"SelectImageNew", @"");
    
    imageList = [[NSMutableArray alloc] init];
	urlList = [[NSMutableArray alloc] init];
    
    [imageList addObject:@"image1_s.png"];
	[imageList addObject:@"image10_s.png"];
	[imageList addObject:@"image11_s.png"];
	[imageList addObject:@"image5_s.png"];
	[imageList addObject:@"image6_s.png"];
	[imageList addObject:@"image12_s.png"];
	[imageList addObject:@"image3_s.png"];
	[imageList addObject:@"image9_s.png"];
	[imageList addObject:@"image14_s.png"];
	[imageList addObject:@"image2_s.png"];
	[imageList addObject:@"image7_s.png"];
	[imageList addObject:@"image13_s.png"];
	[imageList addObject:@"image4_s.png"];
	[imageList addObject:@"image8_s.png"];
	[imageList addObject:@"image15_s.png"];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
	NSString *filename1 = [mainBundle pathForResource:@"image1" ofType:@"png"];
	NSString *filename2 = [mainBundle pathForResource:@"image10" ofType:@"png"];
	NSString *filename3 = [mainBundle pathForResource:@"image11" ofType:@"png"];
	NSString *filename4 = [mainBundle pathForResource:@"image5" ofType:@"png"];
	NSString *filename5 = [mainBundle pathForResource:@"image6" ofType:@"png"];
	NSString *filename6 = [mainBundle pathForResource:@"image12" ofType:@"png"];
	NSString *filename7 = [mainBundle pathForResource:@"image3" ofType:@"png"];
	NSString *filename8 = [mainBundle pathForResource:@"image9" ofType:@"png"];
	NSString *filename9 = [mainBundle pathForResource:@"image14" ofType:@"png"];
	NSString *filename10 = [mainBundle pathForResource:@"image2" ofType:@"png"];
	NSString *filename11 = [mainBundle pathForResource:@"image7" ofType:@"png"];
	NSString *filename12 = [mainBundle pathForResource:@"image13" ofType:@"png"];
	NSString *filename13 = [mainBundle pathForResource:@"image4" ofType:@"png"];
	NSString *filename14 = [mainBundle pathForResource:@"image8" ofType:@"png"];
	NSString *filename15 = [mainBundle pathForResource:@"image15" ofType:@"png"];
	
	[urlList addObject:filename1];
	[urlList addObject:filename2];
	[urlList addObject:filename3];
	[urlList addObject:filename4];
	[urlList addObject:filename5];
	[urlList addObject:filename6];
	[urlList addObject:filename7];
	[urlList addObject:filename8];
	[urlList addObject:filename9];
	[urlList addObject:filename10];
	[urlList addObject:filename11];
	[urlList addObject:filename12];
	[urlList addObject:filename13];
	[urlList addObject:filename14];
	[urlList addObject:filename15];
    
    [super viewDidLoad];
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.navigationController.toolbar.hidden = YES;
    //self.navigationController.navigationBar.top = 0;
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
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    		
}

		
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return urlList.count;
    		
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//NSLog(@"height");
	return 82;
	
}

		
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExUITableViewCell";
    /*static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.*/
    
    UIImage *image = [UIImage imageNamed:[imageList objectAtIndex: indexPath.row]];
	//  リサイズサイズ
	CGSize size = CGSizeMake(300, 300);
	
	UIImage *resultImage;
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//cell.imageView.image = resultImage;
	
	
	ExUITableViewCell *cell = (ExUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        UIViewController *controller = [[UIViewController alloc] initWithNibName:CellIdentifier bundle:nil];
        cell = (ExUITableViewCell *)controller.view;
		[controller release];
    }
	
	UIImage *levelimage = [UIImage imageNamed:@"level.png"];
	switch (indexPath.row) {
		case 0: 
        case 1: 
        case 2:
			cell.level1.image = levelimage;
            
			break;
		case 3:  case 4: case 5:
			cell.level1.image = levelimage;
			cell.level2.image = levelimage;
			break;
		case 6: case 7: case 8:
			cell.level1.image = levelimage;
			cell.level2.image = levelimage;
			cell.level3.image = levelimage;
            
			break;
		case 9: case 10: case 11:
			cell.level1.image = levelimage;
			cell.level2.image = levelimage;
			cell.level3.image = levelimage;
			cell.level4.image = levelimage;
			break;
		case 12: case 13: case 14:
			cell.level1.image = levelimage;
			cell.level2.image = levelimage;
			cell.level3.image = levelimage;
			cell.level4.image = levelimage;
			cell.level5.image = levelimage;
            break;
            
		default:
			break;
	}
    cell.paintImage.image = resultImage;

    		
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlSelected = [urlList objectAtIndex: indexPath.row];
	detailViewController.detailItem = urlSelected;
    
    // Navigation logic may go here -- for example, create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [detailViewController release];
    [imageList release];
	[urlList release];
    [super dealloc];
}

@end
