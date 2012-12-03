

#import <Cocoa/Cocoa.h>
#import "Brew.h"


@interface AvailableFormulaeViewController : NSViewController
										   < BrewDelegate,
											 NSTableViewDelegate >

@property (strong) IBOutlet NSTableView 		*tableView;
@property (strong) IBOutlet NSArrayController 	*arrayController;
@property (strong) IBOutlet NSSearchField 		*searchField;
@property (strong) 			NSMutableArray 		*availableFormulae;
@property (assign) 			BOOL 				loading;

@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet AZBackgroundProgressBar *bgPBar;

- (IBAction)updateFilter:(id)sender;

@end

@interface OutputWindowViewController : NSViewController

@property (strong) IBOutlet NSTextView *outputView;

- (void) clearOutput: 		  (NSNOT*)note;
- (void) outputReceived: 	  (NSNOT*)note;
- (void) formulaInfoReceived: (NSNOT*)note;
- (void) formulaeSelected: 	  (NSNOT*)note;
- (void) updateCompleted:  	  (NSNOT*)note;
- (void) refreshViewWithFormulae;

- (void) append:(NSS*) text;
- (void) appendAttributedText:(NSAS*)attributedText;

@end
