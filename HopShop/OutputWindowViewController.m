

#import "VisualControllers.h"
#import "Formula.h"

@interface OutputWindowViewController ()
@end

@implementation OutputWindowViewController

@synthesize outputView;

NSArray *formulae;

- (void)awakeFromNib
{
	[AZNOTCENTER addObserver:self selector:@selector( clearOutput:         ) name:NotificationClearOutput 		object:nil];
	[AZNOTCENTER addObserver:self selector:@selector( formulaeSelected:    ) name:NotificationFormulaeSelected 	object:nil];
	[AZNOTCENTER addObserver:self selector:@selector( formulaInfoReceived: ) name:NotificationInfoReceived 		object:nil];
	[AZNOTCENTER addObserver:self selector:@selector( updateCompleted:     ) name:NotificationUpdateCompleted 	object:nil];
	[AZNOTCENTER addObserver:self selector:@selector( outputReceived:      ) name:NotificationOutputReceived 	object:nil];
}

- (void)clearOutput: (NSNOT*)note
{
	[self.outputView setString:@""];
}

- (void)outputReceived: (NSNOT*)note	{	[self append:note.object];	}

- (void)append:(NSS*)text { [self appendAttributedText:[NSAS.alloc initWithString:text]];
}

- (void)appendAttributedText:(NSAttributedString *)attributedText
{
	if (!attributedText) return;
	NSMAS *attr = [NSMAS.alloc initWithAttributedString:self.outputView.attributedString];
	[attr appendAttributedString:attributedText];
	self.outputView.textStorage.attributedString = attr;
}

- (void) formulaInfoReceived:(NSNOT*)note {	[self refreshViewWithFormulae]; }

- (void) formulaeSelected:(NSNOT*)note    {	formulae = [note.object copy];
											[self refreshViewWithFormulae]; }

- (void) updateCompleted:(NSNOT*)note	  {	!outputView   ?: ^{
											[self clearOutput:nil];
											[self append:[note.object copy]]; }(); }

- (void) refreshViewWithFormulae			  {	!outputView && !formulae ?: ^{
											[self clearOutput:nil];
											[formulae do:^(Formula *formula){   [self appendAttributedText:formula.fancyDesc]; }];  }();   }



- (BOOL)textView:(NSTextView *)aTextView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex
{
	NSLog(@"TV did click on link : %@", link);
	return YES;
}

@end
