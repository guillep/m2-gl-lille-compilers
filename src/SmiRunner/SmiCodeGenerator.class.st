Class {
	#name : 'SmiCodeGenerator',
	#superclass : 'Object',
	#instVars : [
		'cogit',
		'smiobject',
		'fallthroughBlock',
		'visitedBlocks',
		'deferredBranches',
		'architecture',
		'callsToPatch',
		'freeAddress',
		'machineCodeSize',
		'compilationUnit',
		'currentFunction'
	],
	#pools : [
		'CogAbstractRegisters'
	],
	#category : 'SmiRunner',
	#package : 'SmiRunner'
}

{ #category : 'codegen' }
SmiCodeGenerator class >> aarch64 [

	^ self new aarch64
]

{ #category : 'class initialization' }
SmiCodeGenerator class >> bindRegisters [

	Smalltalk at: #R0 put: 0.
	Smalltalk at: #R1 put: 1.
	Smalltalk at: #R2 put: 2.
	Smalltalk at: #R3 put: 3.

	"The register Ids 4 and 5 are the SP and FP in intel.
	Those are the 28 and 29 in our ARM64 model.
	Just map R4 and R5 to the 9th and 10th registers."
	Smalltalk at: #R4 put: 9.
	Smalltalk at: #R5 put: 10.

	Smalltalk at: #R6 put: 6.
	Smalltalk at: #R7 put: 7.
	Smalltalk at: #R8 put: 8.
]

{ #category : 'class initialization' }
SmiCodeGenerator class >> firstRegisterID [

	^ 0
]

{ #category : 'class initialization' }
SmiCodeGenerator class >> initialize [

	"Create 8 globals for the registers.
	They are just for the DSL.
	The are marked as undefined outside of the generator.
	They are bound when the generator executes."
	self unbindRegisters
]

{ #category : 'class initialization' }
SmiCodeGenerator class >> lastRegisterID [

	^ 8
]

{ #category : 'class initialization' }
SmiCodeGenerator class >> unbindRegisters [

	self firstRegisterID to: self lastRegisterID do: [ :i |
		Smalltalk at: #R, i asString put: #undefined.
	]
]

{ #category : 'codegen' }
SmiCodeGenerator class >> x64 [

	^ self new x64
]

{ #category : 'codegen' }
SmiCodeGenerator >> aarch64 [

	^ self initializeCompilerArchitecture: #aarch64
]

{ #category : 'codegen' }
SmiCodeGenerator >> architecture: aString [

	architecture := aString
]

{ #category : 'assembling' }
SmiCodeGenerator >> assemble: aFullBlockClosure [

	^ [
		  self class bindRegisters.
		  aFullBlockClosure value: cogit.
		  self generateMachineCode ]
				ensure: [ self class unbindRegisters ]
]

{ #category : 'accessing' }
SmiCodeGenerator >> compilationUnit: aSmiIRCompilationUnit [
	
	compilationUnit := aSmiIRCompilationUnit
]

{ #category : 'codegen' }
SmiCodeGenerator >> generateMachineCode [

	| size finalAddress machineCode |
	cogit computeMaximumSizes.
	size := cogit generateInstructionsAt: freeAddress.
	finalAddress := cogit outputInstructionsAt: freeAddress.
	self patchCallInstructions.
	machineCode := cogit objectMemory memoryManager
		  copyFrom: freeAddress
		  to: finalAddress.

	^ SmiProgram new
		architecture: architecture;
		machinecode: machineCode;
		yourself
]

{ #category : 'initialization' }
SmiCodeGenerator >> initialize [

	super initialize.	
	callsToPatch := Dictionary new.
	smiobject := SmiProgram new.
	
	freeAddress := 4096.
	machineCodeSize := 1000.
	
]

{ #category : 'codegen' }
SmiCodeGenerator >> initializeCompilerArchitecture: anArchitecture [

	| options interpreter memory |
	architecture := anArchitecture.
	options := {
		           (#ISA -> architecture).
		           (#BytesPerWord -> 8).
		           (#ObjectMemory -> #Spur64BitCoMemoryManager).
		           (#SistaV1BytecodeSet -> false) } asDictionary.
	SpurMemoryManager initializeWithOptions: options.
	CoInterpreter initializeWithOptions: options.
	SimpleStackBasedCogit initializeWithOptions: options.
	cogit := SimpleStackBasedCogit new.
	interpreter := CoInterpreter new.
	memory := Spur64BitMMLECoSimulator new.
	memory memoryManager: (MachineSimulatorMemoryManager new
			 wordSize: 8;
			 yourself). "bytes of word size in 64 bits"
	interpreter memoryManager: memory memoryManager.
	interpreter objectMemory: memory.
	"interpreter heapBase: 0."
	cogit setInterpreter: interpreter.

	"Prepare code memory"
	cogit objectMemory memoryManager
		allocate: machineCodeSize
		desiredPosition: freeAddress.

	cogit
		allocateOpcodes: 1000
		bytecodes: 0
		ifFail: [ self error: 'unexpected' ]. "opcodes? there should actually be **at least** one per instruction"
	cogit methodLabel address: freeAddress.
	cogit methodZone
		manageFrom: freeAddress
		to: freeAddress + machineCodeSize
]

{ #category : 'patching' }
SmiCodeGenerator >> patchCallInstructions [

	callsToPatch keysAndValuesDo: [ :functionName :calls |
		| functionAddress |
		functionAddress := (self functionNamed: functionName) address.
		calls do: [ :call |
			cogit backend
				rewriteCallAt: call address + call machineCodeSize
				target: functionAddress ] ]
]

{ #category : 'patching' }
SmiCodeGenerator >> registerCall: aCallInstruction to: aFunctionName [

	"Register a call instruction to a function.
	After addresses are computed but before code generation, we will patch all these with the corresponding value"
	
	(callsToPatch at: aFunctionName ifAbsentPut: [ Set new ]) add: aCallInstruction
]

{ #category : 'codegen' }
SmiCodeGenerator >> x64 [

	^ self initializeCompilerArchitecture: #X64
]
