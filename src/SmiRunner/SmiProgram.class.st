Class {
	#name : 'SmiProgram',
	#superclass : 'Object',
	#instVars : [
		'machinecode',
		'literals',
		'architecture'
	],
	#category : 'SmiRunner',
	#package : 'SmiRunner'
}

{ #category : 'accessing' }
SmiProgram >> architecture [

	^ architecture
]

{ #category : 'accessing' }
SmiProgram >> architecture: anObject [

	architecture := anObject
]

{ #category : 'utilities' }
SmiProgram >> disassemble: size [

	^ (LLVMDisassembler perform: (architecture = #X64
			              ifTrue: [ #amd64 ]
			              ifFalse: [
				              architecture = #aarch64
					              ifTrue: [ #aarch64 ]
					              ifFalse: [ architecture ] ]))
		disassembleNext: size
		instructionsIn: machinecode
		startAddress: 4096
		pc: 4096
]

{ #category : 'accessing' }
SmiProgram >> literalAt: anInteger [ 
	
	^ literals at: anInteger
]

{ #category : 'accessing' }
SmiProgram >> literals [

	^ literals
]

{ #category : 'accessing' }
SmiProgram >> literals: anObject [

	literals := anObject
]

{ #category : 'accessing' }
SmiProgram >> machinecode [

	^ machinecode
]

{ #category : 'accessing' }
SmiProgram >> machinecode: anObject [

	machinecode := anObject
]
