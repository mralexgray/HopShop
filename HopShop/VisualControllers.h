

#import <Cocoa/Cocoa.h>
#import "Brew.h"

@interface InstalledFormulaeViewController : NSViewController<BrewDelegate, NSTableViewDelegate>

@property (strong) IBOutlet NSTableView 		*tableView;
@property (strong) IBOutlet NSArrayController 	*arrayController;
@property (strong) 			NSMutableArray 		*installedFormulae;
@property (assign) 			BOOL loading;

@end

@interface AvailableFormulaeViewController : NSViewController
										   < BrewDelegate,
											 NSTableViewDelegate >

@property (strong) IBOutlet NSTableView 		*tableView;
@property (strong) IBOutlet NSArrayController 	*arrayController;
@property (strong) IBOutlet NSSearchField 		*searchField;
@property (strong) 			NSMutableArray 		*availableFormulae;
@property (assign) 			BOOL 				loading;



- (IBAction)updateFilter:(id)sender;

@end

@interface OutputWindowViewController : NSViewController

@property (strong) IBOutlet NSTextView *outputView;

- (void)append:(NSS *)text;
- (void)appendAttributedText:(NSAttributedString *)attributedText;

@end
