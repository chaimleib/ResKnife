#import "CronWindowController.h"

@implementation CronWindowController

- (id)initWithResource:(id)newResource
{
	self = [self initWithWindowNibName:@"cron"];
	if( !self ) return nil;
	
	// init fields with data from resource
	startDate = [[NSCalendarDate date] retain];
	endDate = [[[NSCalendarDate date] dateByAddingYears:0 months:1 days:0 hours:0 minutes:0 seconds:0] retain];
	
	// load the window from the nib file and set it's title
	[self window];	// implicitly loads nib
	if( [newResource name] && ![[newResource name] isEqualToString:@""] )
		[[self window] setTitle:[NSString stringWithFormat:@"%@: %@", [[self window] title], [newResource name]]];
	[self update];
	return self;
}

- (void)windowDidLoad
{
	[super windowDidLoad];
	[self showWindow:self];
}

// date format to get month as single digit:
//	%e/%1m/%Y == 1/1/2000

- (void)update
{
	// activation
	[startDayField		setObjectValue:startDate];
	[startMonthField	setObjectValue:startDate];
	[startYearField		setObjectValue:startDate];
	[startDayStepper	setIntValue:[startDate dayOfMonth]];
	[startMonthStepper	setIntValue:[startDate monthOfYear]];
	[startYearStepper	setIntValue:[startDate yearOfCommonEra]];
	
	[endDayField		setObjectValue:startDate];
	[endMonthField		setObjectValue:startDate];
	[endYearField		setObjectValue:startDate];
	[endDayStepper		setIntValue:[endDate dayOfMonth]];
	[endMonthStepper	setIntValue:[endDate monthOfYear]];
	[endYearStepper		setIntValue:[endDate yearOfCommonEra]];
	
	[startField			setObjectValue:startDate];
	[endField			setObjectValue:startDate];
}

- (IBAction)editStart:(id)sender
{
	id old = startDate;
	startDate = [[NSCalendarDate alloc] initWithYear:[startYearField intValue] month:[startMonthField intValue] day:[startDayField intValue] hour:0 minute:0 second:0 timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[old release];
	[self update];
}

- (IBAction)stepStart:(id)sender
{
	id old = startDate;
	startDate = [[NSCalendarDate alloc] initWithYear:[startYearStepper intValue] month:[startMonthStepper intValue] day:[startDayStepper intValue] hour:0 minute:0 second:0 timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[old release];
	[self update];
}

- (IBAction)editEnd:(id)sender
{
	id old = endDate;
	endDate = [[NSCalendarDate alloc] initWithYear:[endYearField intValue] month:[endMonthField intValue] day:[endDayField intValue] hour:0 minute:0 second:0 timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[old release];
	[self update];
}

- (IBAction)stepEnd:(id)sender
{
	id old = endDate;
	endDate = [[NSCalendarDate alloc] initWithYear:[endYearStepper intValue] month:[endMonthStepper intValue] day:[endDayStepper intValue] hour:0 minute:0 second:0 timeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[old release];
	[self update];
}

- (IBAction)editStartField:(id)sender
{
	id old = startDate;
	startDate = [[NSCalendarDate dateWithNaturalLanguageString:[startField stringValue]] retain];
	[old release];
	[self update];
}

- (IBAction)editEndField:(id)sender
{
	id old = endDate;
	endDate = [[NSCalendarDate dateWithNaturalLanguageString:[endField stringValue]] retain];
	[old release];
	[self update];
}

@end
