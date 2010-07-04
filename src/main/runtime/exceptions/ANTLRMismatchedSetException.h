//
//  ANTLRMismatchedSetException.h
//  ANTLR
//
//  Created by Ian Michell on 04/07/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRRecognitionException.h>
#import <ANTLR/ANTLRBitSet.h>
#import <ANTLR/ANTLRIntStream.h>

@interface ANTLRMismatchedSetException : ANTLRRecognitionException 
{
	ANTLRBitSet *expecting;
}

-(id) initWithBitSet:(ANTLRBitSet *) set withInputStream:(id<ANTLRIntStream>) input;

@property(readwrite, retain) ANTLRBitSet *expecting;

@end
