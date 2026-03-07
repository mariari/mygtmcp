Extension { #name : 'GtHome' }

{ #category : '*Claude-MCP' }
GtHome >> claudeMcpServerSection [
	<gtHomeSection>
	^ ClaudeMcpHomeSection new
		priority: 15
]
