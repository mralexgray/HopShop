
#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>



@interface FormulaeViewController : NSViewController
										   < NSTableViewDelegate >

@property (strong, nonatomic) AZHomeBrew *keg;
@property (RONLY, NATOM) NSNumber *pendingOps;
@property IBOutlet NSScrollView 		*scrollView;
@property IBOutlet NSTableView 		*tableView;
@property IBOutlet NSArrayController 	*arrayController;
@property IBOutlet NSSearchField 		*searchField;
@property (strong) 	NSMA 				*descriptors;
@property 			BOOL 				loading;

@property IBOutlet WebView *webView;
@property IBOutlet AZBackgroundProgressBar *bgPBar;

- (IBAction)updateFilter:(id)sender;

@end
