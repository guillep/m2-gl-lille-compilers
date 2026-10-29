Class {
	#name : 'SmiProgramNode',
	#superclass : 'SmiAbstractNode',
	#instVars : [
		'functions'
	],
	#category : 'SmiParser',
	#package : 'SmiParser'
}

{ #category : 'generated' }
SmiProgramNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitProgram: self
]

{ #category : 'generated' }
SmiProgramNode >> functions [

	^ functions
]

{ #category : 'generated' }
SmiProgramNode >> functions: anObject [

	functions := anObject
]

{ #category : 'generated' }
SmiProgramNode >> otherVariables [

	^ #( #functions )
]
