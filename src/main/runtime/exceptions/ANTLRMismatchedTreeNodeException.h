//
//  ANTLRMismatchedTreeNodeException.h
//  ANTLR
//
//  Created by Ian Michell on 03/07/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRRecognitionException.h>
#import <ANTLR/ANTLRTreeNodeStream.h>

@interface ANTLRMismatchedTreeNodeException : ANTLRRecognitionException 
{
	NSInteger expecting;
}

-(id) initWithTreeNodeStream:(id<ANTLRTreeNodeStream>) input withExpecting:(NSInteger) exp;

@property(readwrite) NSInteger expecting;

@end
