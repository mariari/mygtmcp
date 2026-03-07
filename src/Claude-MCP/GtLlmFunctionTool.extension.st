Extension { #name : 'GtLlmFunctionTool' }

{ #category : '*Claude-MCP' }
GtLlmFunctionTool >> parametersDescription [
	^ ', ' join: (self parameters collect: [ :each | each asString ])
]
