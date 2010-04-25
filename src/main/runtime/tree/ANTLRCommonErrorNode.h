//
//  ANTLRCommonErrorNode.h
//  ANTLR
//
//  Created by Ian Michell on 23/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRCommonTree.h>
#import <ANTLR/ANTLRIntStream.h>
#import <ANTLR/ANTLRToken.h>
#import <ANTLR/ANTLRTokenStream.h>
#import <ANTLR/ANTLRRecognitionException.h>

@interface ANTLRCommonErrorNode : ANTLRCommonTree 
{
	id<ANTLRIntStream> inputStream;
	id<ANTLRToken> startToken;
	id<ANTLRToken> stopToken;
	NSError *trappedError;
}

-(id) initWithStream:(id<ANTLRTokenStream>) input fromToken:(id<ANTLRToken>) start toToken:(id<ANTLRToken>) stop caughtException:(ANTLRRecognitionException *) exception;

@property(readwrite, retain) id<ANTLRIntStream> inputStream;
@property(readwrite, retain) id<ANTLRToken> startToken;
@property(readwrite, retain) id<ANTLRToken> stopToken;
@property(readwrite, retain) ANTLRRecognitionException *trappedException;

@end
