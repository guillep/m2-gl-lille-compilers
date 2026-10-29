Class {
	#name : 'SmiRunnerTest',
	#superclass : 'SmiBaseTest',
	#category : 'SmiRunner-Tests',
	#package : 'SmiRunner-Tests'
}

{ #category : 'tests' }
SmiRunnerTest >> newGenerator [

	^ SmiCodeGenerator perform: architectureId
]

{ #category : 'tests' }
SmiRunnerTest >> testR0IsDefinedDuringAssemble [

	| program runner |
	program := self newGenerator assemble: [ :asm | 
		asm MoveCq: 17 R: R0.
		asm RetN: 0 ].

	runner := SmiRunner new.
	runner run: program.
	self assert: runner r0 equals: 17
]

{ #category : 'tests' }
SmiRunnerTest >> testR1IsDefinedDuringAssemble [

	| program runner |
	program := self newGenerator assemble: [ :asm | 
		asm MoveCq: 17 R: R1.
		asm RetN: 0 ].

	runner := SmiRunner new.
	runner run: program.
	self assert: runner r1 equals: 17
]

{ #category : 'tests' }
SmiRunnerTest >> testR2IsDefinedDuringAssemble [

	| program runner |
	program := self newGenerator assemble: [ :asm |
			           asm MoveCq: 17 R: R2.
			           asm RetN: 0 ].

	runner := SmiRunner new.
	runner run: program.
	self assert: runner r2 equals: 17
]

{ #category : 'tests' }
SmiRunnerTest >> testR3IsDefinedDuringAssemble [

	| program runner |
	program := self newGenerator assemble: [ :asm |
			           asm MoveCq: 17 R: R3.
			           asm RetN: 0 ].

	runner := SmiRunner new.
	runner run: program.
	self assert: runner r3 equals: 17
]

{ #category : 'tests' }
SmiRunnerTest >> testR4IsDefinedDuringAssemble [

	| program runner |
	program := self newGenerator assemble: [ :asm |
			           asm MoveCq: 17 R: R4.
			           asm RetN: 0 ].

	runner := SmiRunner new.
	runner run: program.
	self assert: runner r4 equals: 17
]

{ #category : 'tests' }
SmiRunnerTest >> testR5IsDefinedDuringAssemble [

	| program runner |
	program := self newGenerator assemble: [ :asm |
			           asm MoveCq: 17 R: R5.
			           asm RetN: 0 ].

	runner := SmiRunner new.
	runner run: program.
	self assert: runner r5 equals: 17
]

{ #category : 'tests' }
SmiRunnerTest >> testR6IsDefinedDuringAssemble [

	| program runner |
	program := self newGenerator assemble: [ :asm |
			           asm MoveCq: 17 R: R6.
			           asm RetN: 0 ].

	runner := SmiRunner new.
	runner run: program.
	self assert: runner r6 equals: 17
]

{ #category : 'tests' }
SmiRunnerTest >> testR7IsDefinedDuringAssemble [

	| program runner |
	program := self newGenerator assemble: [ :asm |
			           asm MoveCq: 17 R: R7.
			           asm RetN: 0 ].

	runner := SmiRunner new.
	runner run: program.
	self assert: runner r7 equals: 17
]

{ #category : 'tests' }
SmiRunnerTest >> testR8IsDefinedDuringAssemble [

	| program runner |
	program := self newGenerator assemble: [ :asm |
			           asm MoveCq: 17 R: R8.
			           asm RetN: 0 ].

	runner := SmiRunner new.
	runner run: program.
	self assert: runner r8 equals: 17
]

{ #category : 'tests' }
SmiRunnerTest >> testRegistersAreUndefinedOutsideOfAssemble [

	SmiCodeGenerator firstRegisterID to: SmiCodeGenerator lastRegisterID
		do: [ :id |
				self
					assert: (Smalltalk at: ('R' , id asString) asSymbol)
					equals: #undefined ]
]
