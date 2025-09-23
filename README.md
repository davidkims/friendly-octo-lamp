# friendly-octo-lamp MCP Server

A Model Context Protocol (MCP) server implementation that provides basic utility tools for AI assistants.

## Features

This MCP server provides the following tools:

- **echo**: Echo back a provided message
- **get_time**: Get the current time in ISO format
- **calculate**: Perform basic arithmetic operations (add, subtract, multiply, divide)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/davidkims/friendly-octo-lamp.git
cd friendly-octo-lamp
```

2. Install dependencies:
```bash
npm install
```

3. Build the project:
```bash
npm run build
```

## Usage

### Starting the Server

To start the MCP server:

```bash
npm start
```

For development with auto-reload:

```bash
npm run dev
```

### Connecting to AI Clients

This server follows the Model Context Protocol specification and can be connected to compatible AI clients like Claude Desktop or other MCP-enabled applications.

#### Claude Desktop Configuration

Add the following to your Claude Desktop configuration file:

**macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
**Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "friendly-octo-lamp": {
      "command": "node",
      "args": ["path/to/friendly-octo-lamp/dist/index.js"],
      "cwd": "path/to/friendly-octo-lamp"
    }
  }
}
```

Replace `path/to/friendly-octo-lamp` with the actual path to this repository.

## Available Tools

### echo
- **Description**: Echo back the provided message
- **Parameters**: 
  - `message` (string, required): The message to echo back
- **Example**: `{"message": "Hello, World!"}`

### get_time
- **Description**: Get the current time
- **Parameters**: None
- **Example**: Returns current time in ISO 8601 format

### calculate
- **Description**: Perform basic arithmetic calculations
- **Parameters**:
  - `operation` (string, required): One of "add", "subtract", "multiply", "divide"
  - `a` (number, required): First number
  - `b` (number, required): Second number
- **Example**: `{"operation": "add", "a": 5, "b": 3}`

## Development

### Scripts

- `npm run build`: Compile TypeScript to JavaScript
- `npm run dev`: Run in development mode with auto-reload
- `npm start`: Start the compiled server
- `npm run clean`: Remove compiled files

### Project Structure

```
src/
  index.ts          # Main server implementation
dist/               # Compiled JavaScript output
package.json        # Node.js dependencies and scripts
tsconfig.json       # TypeScript configuration
mcp-config.json     # Example MCP configuration
```

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
