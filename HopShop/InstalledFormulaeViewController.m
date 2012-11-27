

#import "VisualControllers.h"
#import "HopShopAppDelegate.h"
#import "HopShopConstants.h"
#import "Formula.h"

@interface InstalledFormulaeViewController ()
- (void)updateInstalledFormulae;
@end

@implementation InstalledFormulaeViewController
@synthesize tableView, arrayController, installedFormulae, loading;

- (void)awakeFromNib
{
	loading = YES;
	self.installedFormulae = [NSMA array];
	[self updateInstalledFormulae];
}

- (void)updateInstalledFormulae
{
	loading = YES;
	Brew *brew = [[Brew alloc] initWithDelegate:self];
	[brew list:nil];
}

#pragma mark - BrewDelegate methods

- (void)listDidComplete:(NSA*)formulae
{
	[installedFormulae removeAllObjects];
	[arrayController addObjects:[formulae map:^id(id formulaName) {
		Formula *formula = [[Formula alloc] initWithName:formulaName];
		formula.installed = YES;
		Brew *brew = [[Brew alloc]initWithDelegate:formula];
		[brew info:@[formula.name]];
		return formula;
	}]];
	[self.tableView deselectAll:self];
	[arrayController removeSelectedObjects:arrayController.selectedObjects];
	loading = NO;
}

#pragma mark - NSTableViewDelegate methods

- (void)tableViewSelectionDidChange: (NSNOT*)note 
{
	loading ?: ^{
		[AZNOTCENTER postNotificationName:NotificationClearOutput object:nil];
		![[arrayController selectedObjects] count] > 0 ?:
			[AZNOTCENTER postNotificationName:NotificationFormulaeSelected object:arrayController.selectedObjects];
	}();
}

@end
