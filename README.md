## Installation

```st
Metacello new
	repository: '';
	baseline: 'MyGtMcp';
	load
```

## Load Lepiter

After installing with Metacello, you will be able to execute

```
#BaselineOfMyGtMcp asClass loadLepiter
```

## Add to claude code

```
claude mcp add --transport http gtmcp http://localhost:3030
```

## Warning

This launches an MCP server on a port and gives arbitrary code execution like evaluate to whoever is using it, without any authorization or authentication.
