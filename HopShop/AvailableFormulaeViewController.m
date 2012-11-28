

#import "VisualControllers.h"
#import "HopShopAppDelegate.h"
#import "HopShopConstants.h"
#import "Formula.h"
#import <AtoZ/AtoZ.h>


#define kAvailableFormulaeFile @"available_formulae.plist"

@interface AvailableFormulaeViewController ()
- (void)updateAvailableFormulae;
@end

@implementation AvailableFormulaeViewController
@synthesize tableView, arrayController, searchField, availableFormulae, loading;

NSPredicate *formulaePredicate;

- (void)awakeFromNib
{
	loading = YES;		// Set up search
	formulaePredicate = [NSPredicate predicateWithFormat:@"name beginswith[cd] $searchString"];
	// Read in stored list
	NSData *formulaeData = [[NSData alloc] initWithContentsOfFile:[[[HopShopAppDelegate delegate] pathForAppData] stringByAppendingPathComponent:kAvailableFormulaeFile]];
	self.availableFormulae = formulaeData 	   ?  ((NSA*)[NSKeyedUnarchiver unarchiveObjectWithData:formulaeData]).mutableCopy
						   : availableFormulae ?: [NSMA array];
	[self updateAvailableFormulae];
}

- (void)updateAvailableFormulae
{
	loading = YES;
	Brew *brew = [[Brew alloc] initWithDelegate:self];
	[brew search:nil];
}

#pragma mark - BrewDelegate methods

- (void)searchDidComplete:(NSA*)formulae
{
	[availableFormulae removeAllObjects];
	[arrayController         addObjects:[formulae map:^id(id formulaName) {	return [[Formula alloc] initWithName:formulaName];	}]];
	NSS* savePath  = [[[HopShopAppDelegate delegate] pathForAppData] stringByAppendingPathComponent:kAvailableFormulaeFile];
	[[NSKeyedArchiver archivedDataWithRootObject:[arrayController arrangedObjects]] writeToFile:savePath atomically:YES];
	[AtoZ plistToXML:savePath];
	[self.tableView    deselectAll:self];
	[arrayController removeSelectedObjects:arrayController.selectedObjects];
	loading = NO;
	Brew *brew = [[Brew alloc]initWithDelegate:self];
	[brew list:nil];
}

- (void)listDidComplete:(NSA*)formulae
{
	NSLog(@"list xompleted %@", formulae);
//	} addObjects:[formulae map:^id(id formulaName) {
//		Formula *formula = [[Formula alloc] initWithName:formulaName];
	[[[arrayController arrangedObjects]filter:^BOOL(Formula *object) {
		return [formulae containsObject:object.name]; }] each:^(Formula *formula) {
			formula.installed = YES;
	}];
	
	[self.tableView reloadData];
//	[self.tableView deselectAll:self];
//	[arrayController removeSelectedObjects:arrayController.selectedObjects];
//	loading = NO;
}


#pragma mark - Action methods

- (IBAction)updateFilter:(id)sender
{
	NSS *searchString = [searchField stringValue];
	[arrayController setFilterPredicate: !isEmpty(searchString) ? [formulaePredicate predicateWithSubstitutionVariables:@{@"searchString":searchString}] : nil ];
}

#pragma mark - NSTableViewDelegate methods

- (void)tableViewSelectionDidChange: (NSNOT*)note 
{
	loading ?: ^{
		[[[arrayController selectedObjects]filter:^BOOL(Formula* object) {
			return object.desc == nil;
		}]each:^(Formula* obj) {
			obj.desc = [FormulaDescriptions googleSearchFor:obj.name];
		}];
		[AZNOTCENTER postNotificationName:NotificationClearOutput object:nil];
		![[arrayController selectedObjects] count] > 0 ?:
			[AZNOTCENTER postNotificationName:NotificationFormulaeSelected object:[arrayController selectedObjects]];
	}();
}

@end
