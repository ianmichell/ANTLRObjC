//
//  ANTLRTree.m
//  ANTLR
//
//  Created by Ian Michell on 21/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

// [The "BSD licence"]
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. The name of the author may not be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#import "ANTLRTree.h"
#import "ANTLRCommonTree.h"
#import "ANTLRError.h"


static id<ANTLRTree> invalidNode = nil;

@interface ANTLRTree (Private)

-(void) setupChildren;

@end

@implementation ANTLRTree (Private)

-(void) setupChildren
{
	if (children != nil)
	{
		return;
	}
	// Create a new array
	children = [[NSMutableArray new] autorelease];
}

@end


@implementation ANTLRTree

-(id) init
{
	self = [super init];
	if (self)
	{
		pool = [NSAutoreleasePool new];
		children = nil;
	}
	return self;
}

-(id) initWithTree:(id<ANTLRTree>) tree
{
	return [self init];
}

-(void) dealloc
{
	[pool drain];
	[super dealloc];
}

+(id<ANTLRTree>) invalidNode
{
	if (!invalidNode)
	{
		invalidNode = [[ANTLRCommonTree alloc] initWithTokenType:ANTLRTokenTypeInvalid];
		[invalidNode retain];
	}
	return (const id<ANTLRTree>) invalidNode;
}

#pragma mark Ancestors / Parents
-(id<ANTLRTree>) getAncestor:(NSInteger) tokenType
{
	id<ANTLRTree> t = self.parent;
	while (t != nil)
	{
		if (t.type == tokenType)
		{
			return t;
		}
		t = t.parent;
	}
	return nil;
}

-(BOOL) hasAncestor:(NSInteger) tokenType
{
	return [self getAncestor:tokenType] != nil;
}

@synthesize parent;
@synthesize ancestors;

// Children
#pragma mark Children
-(id<ANTLRTree>) childAtIndex:(NSInteger) idx
{
	// use property for thread safety.
	if (self.children != nil && idx < [self.children count]) {
		return [self.children objectAtIndex:idx];
	}
	return nil;
}

-(void) setChildAtIndex:(NSInteger) idx child:(id<ANTLRTree>)child
{
	// If child is nil, do nothing
	if (child == nil)
	{
		return;
	}
	if (child.isEmpty)
	{
		@throw [NSException exceptionWithName:ANTLRRuntimeException reason:@"The specified child is empty" userInfo:nil];
	}
	if (self.children == nil)
	{
		[self setupChildren];
	}
	[self.children replaceObjectAtIndex:idx withObject:child];
	child.parent = self;
	child.childIndex = idx;
}

-(id<ANTLRTree>) firstChildWithType:(NSInteger) t
{
	if (self.children == nil)
	{
		// return nil if we don't have any children.
		return nil;
	}
	// no need to keep indenting our code... Single if with a return is good enough.
	// loop through each child until we get one of it's type.
	for (id<ANTLRTree> child in self.children)
	{
		if (child.type == t)
		{
			return child;
		}
	}
	// return nil by default
	return nil;
}

-(void) freshenParentAndChildIndexes
{
	[self freshenParentAndChildIndexesAtOffset:0];
}

-(void) freshenParentAndChildIndexesAtOffset:(NSInteger) offset
{
	NSInteger i;
	for (i = offset; i < self.childCount; i++)
	{
		id<ANTLRTree> child = (id<ANTLRTree>)[self childAtIndex:i];
		child.childIndex = i;
		child.parent = self;
	}
}

-(void) sanityCheckParentAndChildIndexes
{
	[self sanityCheckParentAndChildIndexesForParentTree:nil forIndex:-1];
}

-(void) sanityCheckParentAndChildIndexesForParentTree:(id<ANTLRTree>) parentTree forIndex:(NSInteger) idx
{
	// Check that our parent is the same as parent tree
	if (parentTree != self.parent)
	{
		@throw [NSException exceptionWithName:ANTLRIllegalArgumentException reason:[NSString stringWithFormat:@"Parents don't match; expected %@ found %@", [parent description], [self.parent description]] userInfo:nil];
	}
	
	// Check that the child indexes match
	if (idx != self.childIndex)
	{
		@throw [NSException exceptionWithName:ANTLRIllegalStateException reason:[NSString stringWithFormat:@"Child indexes don't match; expected %d found %d", idx, self.childIndex] userInfo:nil];
	}
	
	// Cycle through children and check their sanity.
	for (int i = 0; i < self.childCount; i++)
	{
		ANTLRTree *child = [self.children objectAtIndex:i];
		[child sanityCheckParentAndChildIndexesForParentTree:self forIndex:i];
	}
}

-(void) addChild:(id<ANTLRTree>) child
{
	// check if child is nil
	if (child == nil)
	{
		return; // we don't want to add nil children
	}
	
	// If we have no children, then we need to init the children collection
	if (self.children == nil)
	{
		[self setupChildren];
	}
	
	if (child.isEmpty)
	{
		if (self.children != nil && self.children == child.children)
		{
			@throw [NSException exceptionWithName:ANTLRIllegalArgumentException reason:@"Attempted to add child list to itself" userInfo:nil];
		}
		// if the empty tree has children, we should add those to our children.
		if (child.childCount > 0)
		{
			// add all children from the array
			[self.children addObjectsFromArray:child.children];
			// then freshen it up by correcting indexes and parent.
			[self freshenParentAndChildIndexes];
		}
	}
	else
	{
		// if the tree is not empty, add it as a child.
		[self.children addObject:child];
		child.parent = self;
		child.childIndex = [self.children count] - 1;
	}
}

-(id<ANTLRTree>) deleteChild:(NSInteger) index
{
	if (self.children == nil)
	{
		return nil;
	}
	id<ANTLRTree> deletedTree = (id<ANTLRTree>)[self.children objectAtIndex:index];
	// Remove object from the array
	if (deletedTree != nil)
	{
		[self.children removeObjectAtIndex:index];
	}
	return deletedTree;
}

-(void) replaceChildrenFromIndex:(NSInteger) start toIndex:(NSInteger) stop tree:(id<ANTLRTree>) tree
{
	// If there are no children, return an illegal state error. It's up to the person using the parser to pick these errors up.
	if (self.children == nil)
	{
		@throw [NSException exceptionWithName:ANTLRIllegalArgumentException reason:@"Indexes invalid; no children in list" userInfo:nil];
	}
	
	int replacingHowMany = stop - start + 1;
	int replacingWithHowMany;
	
	ANTLRTree *newTree = (ANTLRTree *)tree;
	NSMutableArray *newChildren = nil;
	// nomalize to a list of children to add: newChildren
	if ([newTree isEmpty])
	{
		newChildren = newTree.children;
	}
	else 
	{
		newChildren = [NSMutableArray new];
		[newChildren addObject: newTree];
	}
	replacingWithHowMany = [newChildren count];
	int numNewChildren = [newChildren count];
	int delta = replacingHowMany - replacingWithHowMany;
	
	if (delta == 0)
	{
		int j = 0; // index into new children
		for (int i = start; i <= stop; i++)
		{
			ANTLRTree *child = [newChildren objectAtIndex:j];
			[self.children replaceObjectAtIndex:i withObject:child];
			child.parent = self;
			child.childIndex = i;
			j++;
		}
	}
	else if (delta > 0)
	{
		// Set children and then delete extra
		for (int i = 0; i < numNewChildren; i++)
		{
			[self.children replaceObjectAtIndex:start + i withObject:[newChildren objectAtIndex:i]];
		}
		int indexToDelete = start + numNewChildren;
		for (int i = indexToDelete; i <= stop; i++)
		{
			[self.children removeObjectAtIndex:i];
		}
		[self freshenParentAndChildIndexesAtOffset:start];
	}
	// More new nodes than were there before
	else
	{
		for (int i = 0; i < replacingHowMany; i++)
		{
			[self.children replaceObjectAtIndex:start + i withObject:[newChildren objectAtIndex:i]];
		}
		//int numToInsert = replacingWithHowMany - replacingHowMany; // why isn't this used in the java code?
		for (int i = replacingHowMany; i < replacingWithHowMany; i++)
		{
			[self.children insertObject:[newChildren objectAtIndex:i] atIndex:start + i];
		}
		[self freshenParentAndChildIndexesAtOffset:start];
	}
}

-(void) addChildren:(NSArray *) c
{
	if (c == nil || [c count] == 0)
	{
		// if the collection is empty or nil then do nothing
		// we should probably throw here just to force the policy...
		return;
	}
	// Add each child in the collection
	for (id child in c)
	{
		[self addChild:(id<ANTLRTree>) child];
	}
}


-(id) copyWithZone:(NSZone *) aZone
{
	id<ANTLRTree> theCopy = [[[self class] alloc] init];
	[theCopy addChildren:self.children];
	return theCopy;
}


-(NSString *) description
{
	return self.text;
}

/* Print the whole tree structure! */
-(NSString *) treeDescription
{
	if (self.children == nil || [self.children count] == 0)
	{
		return [self description];
	}
	
	NSMutableString *treeString = [NSMutableString new];
	if (!self.isEmpty)
	{
		[treeString appendString:@"("];
		[treeString appendString:[self description]];
		[treeString appendString:@" "];
	}
	for (int i = 0; i < self.childCount; i++)
	{
		id<ANTLRTree> t = (id<ANTLRTree>)[self.children objectAtIndex:i];
		if (i > 0)
		{
			[treeString appendString:@" "];
		}
		[treeString appendString:[t treeDescription]];
	}
	if (!self.isEmpty)
	{
		[treeString appendString:@")"];
	}
	return treeString;
}

@synthesize children;
@synthesize childIndex;
@synthesize tokenStartIndex;
@synthesize tokenStopIndex;

/*******************************************************************************
 *	Dynamic properties
 ******************************************************************************/
@dynamic isEmpty;
-(BOOL) isEmpty
{
	return NO;
}


@dynamic childCount; // dynamic
-(NSInteger) childCount
{
	if (self.children != nil)
	{
		return [self.children count];
	}
	return 0;
}

@dynamic charPositionInLine;
-(NSInteger) charPositionInLine
{
	[self doesNotRecognizeSelector:_cmd];
	return 0;
}


@dynamic type;
-(NSInteger) type
{
	[self doesNotRecognizeSelector:_cmd];
	return 0;
}

@dynamic line;
-(NSInteger) line
{
	[self doesNotRecognizeSelector:_cmd];
	return 0;
}

@dynamic text;
-(NSString *) text
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

@end

