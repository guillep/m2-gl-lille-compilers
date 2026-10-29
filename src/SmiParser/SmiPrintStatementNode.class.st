Class {
	#name : 'SmiPrintStatementNode',
	#superclass : 'SmiAbstractNode',
	#instVars : [
		'string'
	],
	#category : 'SmiParser',
	#package : 'SmiParser'
}

{ #category : 'generated' }
SmiPrintStatementNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitPrintStatement: self
]

{ #category : 'generated' }
SmiPrintStatementNode >> string [

	^ string
]

{ #category : 'generated' }
SmiPrintStatementNode >> string: aSmaCCToken [

	string := aSmaCCToken
]

{ #category : 'generated' }
SmiPrintStatementNode >> tokenVariables [

	^ #( #string )
]
