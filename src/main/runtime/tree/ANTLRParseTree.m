//
//  ANTLRParseTree.m
//  ANTLR
//
//  Created by Ian Michell on 28/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRParseTree.h"


@implementation ANTLRParseTree

-(id) initWithLabel:(id) label
{
	self = [super init];
	if (self)
	{
		self.payload = label;
	}
	return self;
}

-(id) copyWithZone:(NSZone *)aZone
{
	return nil;
}

@dynamic type;
-(NSInteger) type
{
	return 0;
}

@dynamic text;
-(NSString *) text
{
	return [self description];
}

@dynamic tokenStartIndex;
-(NSInteger) tokenStartIndex
{
	return 0;
}

-(void) setTokenStartIndex:(NSInteger) index
{
	
}

@dynamic tokenStopIndex;
-(NSInteger) tokenStopIndex
{
	return 0;
}

-(void) setTokenStopIndex:(NSInteger) index
{
	
}

-(NSString *) description
{
	if ([payload conformsToProtocol:@protocol(ANTLRToken)])
	{
		id<ANTLRToken> t = (id<ANTLRToken>)payload;
		if (t.type == ANTLRTokenTypeEOF)
		{
			return @"<EOF>";
		}
		return t.text;
	}
	return [payload description];
}

-(NSString *) descriptionWithHiddenTokens
{
	NSMutableString *buf = [NSMutableString new];
	if (self.hiddenTokens != nil)
	{
		for (NSInteger i = 0; i < [hiddenTokens count]; i++)
		{
			id<ANTLRToken> hidden = (id<ANTLRToken>)[self.hiddenTokens objectAtIndex:i];
			[buf appendString:hidden.text];
		}
	}
	NSString *nodeText = [self description];
	if (![nodeText isEqualToString:@"<EOF>"])
	{
		[buf appendString:nodeText];
	}
	return buf;
}

-(NSString *) inputString
{
	NSMutableString *buf = [NSMutableString new];
	[self stringLeaves:buf];
	return buf;
}

// FIXME: Probably should make this hidden, java one isn't though...
-(void) stringLeaves:(NSMutableString *) buf
{
	if ([payload conformsToProtocol:@protocol(ANTLRToken)])
	{
		[buf appendString:[self descriptionWithHiddenTokens]];
		return;
	}
	for (NSInteger i = 0; self.children != nil && i < [self.children count]; i++)
	{
		ANTLRParseTree *t = (ANTLRParseTree *)[self.children objectAtIndex:i];
		[t stringLeaves:buf];
	}
}

@synthesize payload;
@synthesize hiddenTokens;

@end
