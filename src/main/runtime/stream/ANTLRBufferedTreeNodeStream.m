//
//  ANTLRBufferedTreeNodeStream.m
//  ANTLR
//
//  Created by Ian Michell on 29/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRBufferedTreeNodeStream.h"
#import "ANTLRStreamEnumerator.h"
#import "ANTLRCommonTreeAdaptor.h"

@implementation ANTLRBufferedTreeNodeStream

-(id) init
{
	self = [super init];
	if (self)
	{
		p = -1;
		uniqueNavigationNodes = NO;
	}
	return self;
}

-(id) initWithTree:(id<ANTLRTree>) tree
{
	return [self initWithTreeAdaptor:[ANTLRCommonTreeAdaptor new] andTree:tree];
}

-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) anAdaptor andTree:(id<ANTLRTree>) tree
{
	return [self initWithTreeAdaptor:anAdaptor withTree:tree withBufferSize:ANTLR_BUFFERED_TREE_NODE_STREAM_BUFFER_SIZE];
}

-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) anAdaptor withTree:(id<ANTLRTree>) tree withBufferSize:(NSInteger) bufferSize
{
	self = [super init];
	if (self)
	{
		self.treeSource = tree;
		self.treeAdaptor = anAdaptor;
		nodes = [NSMutableArray arrayWithCapacity:bufferSize];
		down = [self.treeAdaptor createTreeWithTokenType:ANTLRTokenTypeDOWN withText:@"DOWN"];
		up = [self.treeAdaptor createTreeWithTokenType:ANTLRTokenTypeDOWN withText:@"UP"];
		eof = [self.treeAdaptor createTreeWithTokenType:ANTLRTokenTypeDOWN withText:@"EOF"];
	}
	return self;
}

// protected methods. DO NOT USE
#pragma mark Protected Methods
-(void) _fillBuffer
{
	[self _fillBufferWithTree:self.treeSource];
	p = 0;
}

-(void) _fillBufferWithTree:(id<ANTLRTree>) tree
{
	BOOL empty = [self.treeAdaptor isEmptyTree:tree];
	if (!empty)
	{
		[nodes addObject:tree];
	}
	NSInteger n = [self.treeAdaptor childCountForTree:tree];
	if (!empty && n > 0)
	{
		[self _addNavigationNode:ANTLRTokenTypeDOWN];
	}
	for (NSInteger i = 0; i < n; i++)
	{
		id child = [self.treeAdaptor childForNode:tree atIndex:i];
		[self _fillBufferWithTree:child];
	}
	if (!empty && n > 0)
	{
		[self _addNavigationNode:ANTLRTokenTypeUP];
	}
}

-(NSInteger) _nodeIndex:(id<ANTLRTree>) node
{
	if (p == -1)
	{
		[self _fillBuffer];
	}
	for (NSInteger i = 0; i < [nodes count]; i++)
	{
		id t = [nodes objectAtIndex:i];
		if (t == node)
		{
			return i;
		}
	}
	return -1;
}

-(void) _addNavigationNode:(NSInteger) type
{
	id navNode = nil;
	if (type == ANTLRTokenTypeDOWN)
	{
		if (self.uniqueNavigationNodes)
		{
			navNode = [self.treeAdaptor createTreeWithTokenType:ANTLRTokenTypeDOWN withText:@"DOWN"];
		}
		else 
		{
			navNode = down;
		}

	}
	else 
	{
		if (self.uniqueNavigationNodes)
		{
			navNode = [self.treeAdaptor createTreeWithTokenType:ANTLRTokenTypeUP withText:@"UP"];
		}
		else 
		{
			navNode = up;
		}
	}
	[nodes addObject:navNode];
}

-(id) get:(NSInteger) i
{
	if (p == -1)
	{
		[self _fillBuffer];
	}
	return [nodes objectAtIndex:i];
}

-(id) LT:(NSInteger) i
{
	if (p == -1)
	{
		[self _fillBuffer];
	}
	if (i == 0)
	{
		return nil;
	}
	if (i < 0)
	{
		return [self LB:i];
	}
	if ((p + i - 1) >= [nodes count])
	{
		return eof;
	}
	return [nodes objectAtIndex:(p + i - 1)];
}

@dynamic currentSymbol;
-(id) currentSymbol
{
	return [self LT:1];
}

-(id) LB:(NSInteger) i
{
	if (i == 0)
	{
		return nil;
	}
	if ((p - i) < 0)
	{
		return nil;
	}
	return [nodes objectAtIndex:(p - i)];
}

@dynamic sourceName;
-(NSString *) sourceName
{
	return self.tokenStream.sourceName;
}

-(void) consume
{
	if (p == -1)
	{
		[self _fillBuffer];
	}
	p++;
}

-(NSInteger) LA:(NSInteger) i
{
	return [self.treeAdaptor tokenTypeForNode:[self LT:i]];
}

-(NSInteger) mark
{
	if (p == -1)
	{
		[self _fillBuffer];
	}
	lastMarker = [self index];
	return lastMarker;
}

-(void) releaseWithMarker:(NSInteger) marker
{
	// do nothing
}

-(NSInteger) index
{
	return p;
}

-(void) rewindWithMarker:(NSInteger) marker
{
	[self seek:marker];
}

-(void) rewind
{
	[self seek:lastMarker];
}

-(void) seek:(NSInteger) i
{
	if (p == -1)
	{
		[self _fillBuffer];
	}
	p = i;
}

-(void) push:(NSInteger) i
{
	if (calls == nil)
	{
		calls = [ANTLRIntArray new];
	}
	[calls push:p];
	[self seek:i];
}

-(NSInteger) pop
{
	NSInteger ret = [calls pop];
	[self seek:ret];
	return ret;
}

-(void) reset
{
	p = 0;
	lastMarker = 0;
	if (calls != nil)
	{
		[calls clear];
	}
}

-(NSInteger) size
{
	if (p == -1)
	{
		[self _fillBuffer];
	}
	return [nodes count];
}

-(NSEnumerator *) objectEnumerator
{
	if (e == nil)
	{
		e = [[ANTLRStreamEnumerator alloc] initWithNodes:nodes andEOF:eof];
	}
	return e;
}

-(void) replaceChildren:(id<ANTLRTree>) parent start:(NSInteger) startIdx end:(NSInteger) stopIdx object:(id<ANTLRTree>) t
{
	if (parent != nil)
	{
		[self.treeAdaptor replaceChildrenForTree:parent from:startIdx to:stopIdx with:t];
	}
}

-(NSString *) stringValueFromObjects:(id) start end:(id) stop
{
	if (start == nil || stop == nil)
	{
		return nil;
	}
	if (p == -1)
	{
		[self _fillBuffer];
	}
	
	// if we have a token stream, use that to dump text in order
	if (self.tokenStream != nil)
	{
		NSInteger beginTokenIndex = [self.treeAdaptor tokenStartIndexForTree:start];
		NSInteger endTokenIndex = [self.treeAdaptor tokenStopIndexForTree:stop];
		
		if ([self.treeAdaptor tokenTypeForNode:stop] == ANTLRTokenTypeUP)
		{
			endTokenIndex = [self.treeAdaptor tokenStopIndexForTree:start];
		}
		else if ([self.treeAdaptor tokenTypeForNode:stop] == ANTLRTokenTypeEOF)
		{
			endTokenIndex = [self size] - 2; //don't use EOF
		}
		return [self.tokenStream stringValueFromRange:NSMakeRange(beginTokenIndex, endTokenIndex)];
	}
	// walk nodes looking for start
	id<ANTLRTree> t = nil;
	NSInteger i = 0;
	for (; i < [nodes count]; i++)
	{
		t = [nodes objectAtIndex:i];
		if (t == start)
		{
			break;
		}
	}
	NSMutableString *buf = [NSMutableString new];
	t = [nodes objectAtIndex:i]; // why?
	while (t != stop)
	{
		NSString *text = [self.treeAdaptor textForNode:t];
		if (text == nil)
		{
			text = [NSString stringWithFormat:@" %d", [self.treeAdaptor tokenTypeForNode:t]];
		}
		[buf appendString:text];
		i++;
		t = [nodes objectAtIndex:i];
	}
	NSString *text = [self.treeAdaptor textForNode:stop];
	if (text == nil)
	{
		text = [NSString stringWithFormat:@" %d", [self.treeAdaptor tokenTypeForNode:stop]];
	}
	[buf appendString:text];
	return buf;
}

-(NSString *) tokenTypeString
{
	if (p == 01)
	{
		[self _fillBuffer];
	}
	NSMutableString *buf = [NSMutableString new];
	for (NSInteger i= 0; i < [nodes count]; i++)
	{
		id<ANTLRTree> t = (id<ANTLRTree>)[nodes objectAtIndex:i];
		[buf appendFormat:@" %d", [self.treeAdaptor tokenTypeForNode:t]];
	}
	return buf;
}

-(NSString *) tokenStringFrom:(NSInteger) start to:(NSInteger) stop
{
	if (p == -1)
	{
		[self _fillBuffer];
	}
	NSMutableString *buf = [NSMutableString new];
	for (NSInteger i = start; i < [nodes count] && i <= stop; i++)
	{
		id<ANTLRTree> t = (id<ANTLRTree>)[nodes objectAtIndex:i];
		[buf appendFormat:@" %d", [self.treeAdaptor tokenTypeForNode:t]];
	}
	return buf;
}

@synthesize treeAdaptor;
@synthesize treeSource;
@synthesize uniqueNavigationNodes;
@synthesize tokenStream;

@end
