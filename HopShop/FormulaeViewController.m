

#import "FormulaeViewController.h"
#import "HopShopAppDelegate.h"

#define kAvailableFormulaeFile @"available_formulae.plist"

@interface FormulaeViewController ()
- (void)updateAvailableFormulae;
@end

@implementation FormulaeViewController
@synthesize tableView, arrayController, searchField, loading;

- (NSN*) pendingOps { return @(AZSSOQ.operationCount +AZSOQ.operationCount); }

NSPredicate *formulaePredicate;

- (void)awakeFromNib
{
	[_scrollView.contentView setPostsBoundsChangedNotifications:YES];
	[_scrollView.contentView observeName:NSViewBoundsDidChangeNotification usingBlock:^(NSNotification *n) {
		[AZSSOQ cancelAllOperations];
		NSRNG r = [tableView rowsInRect:[_scrollView.documentView visibleRect]];
		NSLog(@"visibleRows %@",NSStringFromRange(r));
		[[arrayController.arrangedObjects subarrayWithRange:r] each:^(id obj) {
			[self.keg setInfoForFormula:obj];
		}];
//		[[self.keg.available filter:^BOOL(AZBrewFormula* object) {
//			return object.version == nil;
//		}] do:^(AZBrewFormula* forumla) { [self.keg setInfoForFormula:forumla]; }];
//		NSLog(@"visibleRows %@",NSStringFromRange());
	}];

//	  addObserver:self selector:@selector(boundsDidChange:) name:NSViewBoundsDidChangeNotification object:_scrollView.contentView];


	_webView.frameLoadDelegate = self;
	_webView.preferences.standardFontFamily 	= @"Ubuntu Mono Bold";
	_webView.preferences.defaultFixedFontSize	= 14;
	_webView.preferences.fixedFontFamily		= @"Ubuntu Mono Bold";
	_webView.preferences.minimumFontSize		= 14;
	_webView.preferences.serifFontFamily		= @"Ubuntu Mono Bold";

	NSURL*		home	= [NSURL URLWithString: @"http://mrgray.com"];
	NSURLREQ*	homeReq	= [NSURLRequest requestWithURL:home cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60.0];

	[_webView.mainFrame loadRequest: homeReq];

//	[[_webView preferences] setDefaultFontSize:14];
//	[_webView.mainFrame.frameView.documentView scaleUnitSquareToSize:NSMakeSize(4, 4)];
//  [[[[_webView mainFrame] frameView] documentView] setNeedsDisplay:YES];
//	[NSAppleEventManager.sharedAppleEventManager setEventHandler:self  andSelector:@selector(getUrl:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
//	static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{ [NSURLProtocol registerClass:[AZHTTPURLProtocol class]]; });

//	loading = YES;		// Set up search
	formulaePredicate = [NSPredicate predicateWithFormat:@"name beginswith[cd] $searchString"];

	NSSortDescriptor *status, *name;
	status = [NSSortDescriptor.alloc initWithKey: @"installStatus" ascending: YES selector: @selector(compare:)];
	[tableView tableColumnWithIdentifier:@"status"].sortDescriptorPrototype = status;
	name = [NSSortDescriptor.alloc initWithKey: @"name" ascending: YES selector: @selector(compare:)];
	[tableView tableColumnWithIdentifier:@"name"].sortDescriptorPrototype = name;
	_descriptors = @[status, name].mutableCopy;


	//	descriptor = [[NSSortDescriptor alloc] initWithKey: @ "piyo" ascending: YES selector: @ selector (compare :)];
	//	[[SampleTableView tableColumnWithIdentifier: @ "piyo"] setSortDescriptorPrototype: descriptor];
	//	[Descriptors addObject: descriptor];
	[tableView setSortDescriptors: _descriptors];


}

- (AZHomeBrew*)keg { return AZHomeBrew.sharedInstance; }

//	[tableView setColumnWithIdentifier:@"status" toClass:AZInstallStatusCell.class];
//	AZLOG(_keg.propertiesPlease);
//	AZLOG(_keg.installed);
//	[tableView reloadData];
	// Read in stored list
//	NSData *formulaeData = [NSData.alloc initWithContentsOfFile:[HopShopAppDelegate.delegate.pathForAppData withPath:kAvailableFormulaeFile]];
//	self.availableFormulae = formulaeData 	   ?  ((NSA*)[NSKeyedUnarchiver unarchiveObjectWithData:formulaeData]).mutableCopy
//						   : availableFormulae ?: NSMA.array;
//	[self updateAvailableFormulae];



- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
	[_bgPBar startProgressAnimation];

}
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	[_bgPBar stopProgressAnimation];

}

//- (void)updateAvailableFormulae
//{
//	loading = YES;
//	[AZSharedSingleOperationQueue() addOperation:[Brew.alloc initWithDelegate:self operation:BrewOperationList]];
////	[brew search:nil];
//}
/*
#pragma mark - BrewDelegate methods

- (void)searchDidComplete:(NSA*)formulae
{
	[availableFormulae removeAllObjects];
	[arrayController  addObjects:[formulae map:^id(id formulaName) {
		return [[Formula alloc] initWithName:formulaName];
	}]];
	NSS* savePath  = [HopShopAppDelegate.delegate.pathForAppData withPath:kAvailableFormulaeFile];
	NSLog(@"savepath: %@", savePath);
	[[NSKeyedArchiver archivedDataWithRootObject:[arrayController arrangedObjects]] writeToFile:savePath atomically:YES];
	[AtoZ plistToXML:savePath];
//	[self.tableView    deselectAll:self];
	[arrayController removeSelectedObjects:arrayController.selectedObjects];
	loading = NO;
//	Brew *brew = [Brew.alloc initWithDelegate:self];
//	[brew list:nil];
}

- (void)listDidComplete:(NSA*)formulae
{
	NSLog(@"list xompleted %@", formulae);
//	} addObjects:[formulae map:^id(id formulaName) {
//		Formula *formula = [[Formula alloc] initWithName:formulaName];
	[[[arrayController arrangedObjects]filter:^BOOL(Formula *object) {
		return [formulae containsObject:object.name]; }] each:^(Formula *formula) {
			formula.installStatus = (formula.installStatus | AZInstalled);
	}];
	
	[self.tableView reloadData];
//	[self.tableView deselectAll:self];
//	[arrayController removeSelectedObjects:arrayController.selectedObjects];
//	loading = NO;
}


#pragma mark - Action methods
*/
- (IBAction)updateFilter:(id)sender
{
	NSS *searchString = [searchField stringValue];
	[arrayController setFilterPredicate: !isEmpty(searchString) ? [formulaePredicate predicateWithSubstitutionVariables:@{@"searchString":searchString}] : nil ];
}

#pragma mark - NSTableViewDelegate methods

- (void)tableView:(NSTableView *)tableView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn
{
	NSLog(@"mouse down in: %@", [tableColumn identifier]);
}
- (void)tableViewSelectionDidChange: (NSNOT*)note 
{

	NSI row = [tableView selectedRow];
//	[_keg.available each:^(id obj) {
//		[obj removeAllObservers];
//	}];
    if (row == -1) {
//        do stuff for the no-rows-selected case
	} else {
		AZBrewFormula* f = (AZBrewFormula*)arrayController.arrangedObjects[row];

		NSLog(@"Selected f: %@", f);
//		if (!f.info) [self.keg setInfoForFormula:f];
		if (f.url) [[_webView mainFrame]loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:f.url]]];
		else [f addObserver:self keyPath:@"url" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
			[[_webView mainFrame]loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:notification.newValue]]];
		}];
	}
}

//	loading ?: ^{
//		[[[arrayController selectedObjects]filter:^BOOL(Formula* object) {
//			return object.desc == nil;
//		}]each:^(Formula* obj) {
//			[obj setDescFromGoogle: [FormulaDescriptions googleSearchFor:obj.name]];
//		}];
//		Formula *f = (Formula*)[arrayController.arrangedObjects filterOne:^BOOL(id object) {
//			return [[object valueForKey:@"name"] isEqualToString:arrayController.selectedObjects[0]];
//			}];
//		NSURL   *theU = [NSURL URLWithString:f.url];
//		NSURLREQ *req = [NSURLRequest requestWithURL:theU cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60.0];
//		NSLog(@"request: %@", f);
//		[[_webView mainFrame] loadRequest:req];
//
//		[AZNOTCENTER postNotificationName:NotificationClearOutput object:nil];
//		![[arrayController selectedObjects] count] > 0 ?:
//			[AZNOTCENTER postNotificationName:NotificationFormulaeSelected object:[arrayController selectedObjects]];
//	}();


/*
- (void) getUrl:(NSURL*)url withReplyEvent:(id)event{

	NSLog(@"event: %@", url);
}
*/
@end

