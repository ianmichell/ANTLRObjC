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
	children = [NSMutableArray new];
}

@end


@implementation ANTLRTree

-(id) init
{
	self = [super init];
	if (self)
	{
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
	[children release];
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
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

-(BOOL) hasAncestor:(NSInteger) tokenType
{
	[self doesNotRecognizeSelector:_cmd];
	return NO;
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

-(void) setChildAtIndex:(NSInteger) idx child:(id<ANTLRTree>)child error:(NSError **) error
{
	// If child is nil, do nothing
	if (child == nil)
	{
		return;
	}
	if (child.isEmpty)
	{
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:@"The specified child is empty" forKey:NSLocalizedDescriptionKey];
		*error = [NSError errorWithDomain:ANTLRErrorDomain code:ANTLRIllegalArgument userInfo:userInfo];
		return;
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

-(void) sanityCheckParentAndChildIndexes:(NSError **) error
{
	[self sanityCheckParentAndChildIndexesForParentTree:nil forIndex:-1 error:error];
}

-(void) sanityCheckParentAndChildIndexesForParentTree:(id<ANTLRTree>) parentTree forIndex:(NSInteger) idx error:(NSError **)error
{
	// Check that our parent is the samea s parent tree
	if (parentTree != self.parent)
	{
		// Setup error message
		NSString *errorMsg = @"Parents don't match; expected ";
		errorMsg = [errorMsg stringByAppendingString:[parentTree description]];
		errorMsg = [errorMsg stringByAppendingString:@" found"];
		errorMsg = [errorMsg stringByAppendingString:[self.parent description]];
		// Setup user info dictionary
		NSMutableDictionary *errInfo = [NSMutableDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
		// Setup error
		*error = [NSError errorWithDomain:ANTLRErrorDomain code:ANTLRIllegalState userInfo:errInfo];
		// After setting error, return.
		return;
	}
	
	// Check that the child indexes match
	if (idx != self.childIndex)
	{
		NSString *errorMsg = @"Child indexes don't match; expected ";
		errorMsg = [errorMsg stringByAppendingString: [NSString stringWithFormat: @" %d found %d", idx, self.childIndex]];
		NSMutableDictionary *errInfo = [NSMutableDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
		*error = [NSError errorWithDomain:ANTLRErrorDomain code:ANTLRIllegalState userInfo:errInfo];
		return;
	}
	
	// Cycle through children and check their sanity.
	for (int i = 0; i < self.childCount; i++)
	{
		ANTLRTree *child = [self.children objectAtIndex:i];
		[child sanityCheckParentAndChildIndexesForParentTree:self forIndex:i error:error];
		// check for errors
		if (*error != nil)
		{
			return;
		}
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
		// if the empty tree has children, we should add those to our children.
		if (child.childCount > 0)
		{
			[self.children addObjectsFromArray:child.children];
		}
	}
	else
	{
		// if the tree is not empty, add it as a child.
		[self.children addObject:child];
	}
}

-(id<ANTLRTree>) deleteChild:(NSInteger) index
{
	if (self.children != nil)
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

-(void) replaceChildrenFromIndex:(NSInteger) start toIndex:(NSInteger) stop tree:(id<ANTLRTree>) tree error:(NSError**) error
{
	// If there are no children, return an illegal state error. It's up to the person using the parser to pick these errors up.
	if (self.children == nil)
	{
		NSString *errMsg = @"Indexes invalid; no children in list";
		NSMutableDictionary *errInfo = [NSMutableDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
		*error = [NSError errorWithDomain:ANTLRErrorDomain code:ANTLRIllegalState userInfo:errInfo];
		return;
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
		for (int i = start; i < stop; i++)
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
		for (int i = indexToDelete; i < stop; i++)
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
		for (int i = 0; i < replacingWithHowMany; i++)
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

-(id) deepCopy
{
	return [self deepCopyWithZone:nil];
}

-(id) deepCopyWithZone:(NSZone *) aZone
{
	id<ANTLRTree> theCopy = [self copyWithZone:aZone];
	NSArray *childrenCopy = [NSMutableArray new];
	if (theCopy.children != nil)
	{
		[theCopy.children removeAllObjects];
	}
	for (int i = 0; i < [childrenCopy count]; i++)
	{
		id<ANTLRTree> child = [[childrenCopy objectAtIndex:i] deepCopyWithZone:aZone];
		[theCopy addChild:child];
	}
	[childrenCopy release];
	// Return the copied object
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

