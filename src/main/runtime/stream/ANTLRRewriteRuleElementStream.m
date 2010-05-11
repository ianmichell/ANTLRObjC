//
//  ANTLRRewriteRuleElementStream.m
//  ANTLR
//
//  Created by Ian Michell on 10/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRRewriteRuleElementStream.h"
#import "ANTLRRewriteEmptyStreamException.h"
#import "ANTLRRewriteCardinalityException.h"

@implementation ANTLRRewriteRuleElementStream

-(id) init
{
	self = [super init];
	if (self)
	{
		cursor = 0;
		dirty = NO;
	}
	return self;
}

-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) adaptor elementDescription:(NSString *) description
{
	self = [self init];
	if (self)
	{
		elementDescription = description;
		treeAdaptor = adaptor;
	}
	return self;
}

-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) adaptor elementDescription:(NSString *) description singleElement:(id) element
{
	self = [self initWithTreeAdaptor:adaptor elementDescription:description];
	if (self)
	{
		[self add:element];
	}
	return self;
}

-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) adaptor elementDescription:(NSString *) description listOfElements:(NSArray *) list
{
	self = [self initWithTreeAdaptor:adaptor elementDescription:description];
	if (self)
	{
		singleElement = nil;
		elements = [NSMutableArray new];
		[elements setArray:list];
	}
	return self;
}

-(void) reset
{
	cursor = 0;
	dirty = NO;
}

-(void) add:(id) el
{
	if (el == nil)
	{
		return;
	}
	if (elements != nil)
	{
		[elements addObject:el];
		return;
	}
	if (singleElement == nil)
	{
		singleElement = el;
		return;
	}
	if (elements != nil)
	{
		[elements release];
	}
	elements = [NSMutableArray arrayWithCapacity:5];
	[elements addObject:singleElement];
	singleElement = nil;
	[elements addObject:el];
}

-(id) nextTree
{
	NSInteger n = [self size];
	if (dirty || cursor >= n && n == 1)
	{
		id el = [self _next];
		return [self copy:el];
	}
	id el = [self _next];
	return el;
}

-(id) copy:(id) el
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(id) toTree:(id) el
{
	return el;
}

-(BOOL) hasNext
{
	return (singleElement != nil && cursor < 1) || (elements != nil && cursor < [elements count]);
}

-(NSInteger) size
{
	NSInteger n = 0;
	if (singleElement != nil)
	{
		n = 1;
	}
	if (elements != nil)
	{
		return [elements count];
	}
	return n;
}

@synthesize elementDescription;

// protected
-(id) _next
{
	NSInteger n = [self size];
	if (n == 0)
	{
		@throw [ANTLRRewriteEmptyStreamException exceptionWithElementDescription:elementDescription];
	}
	if (cursor >= n)
	{
		if (n == 1)
		{
			return [self toTree:singleElement];
		}
		@throw [ANTLRRewriteCardinalityException exceptionWithElementDescription:elementDescription];
	}
	if (singleElement != nil)
	{
		cursor++;
		return [self toTree:singleElement];
	}
	id o = [self toTree:[elements objectAtIndex:cursor]];
	cursor++;
	return o;
}

@end
