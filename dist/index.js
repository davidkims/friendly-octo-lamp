#!/usr/bin/env node
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ErrorCode, ListToolsRequestSchema, McpError, } from "@modelcontextprotocol/sdk/types.js";
const server = new Server({
    name: "friendly-octo-lamp-mcp-server",
    version: "1.0.0",
}, {
    capabilities: {
        tools: {},
    },
});
// Tool definitions
const TOOLS = [
    {
        name: "echo",
        description: "Echo back the provided message",
        inputSchema: {
            type: "object",
            properties: {
                message: {
                    type: "string",
                    description: "The message to echo back",
                },
            },
            required: ["message"],
        },
    },
    {
        name: "get_time",
        description: "Get the current time",
        inputSchema: {
            type: "object",
            properties: {},
        },
    },
    {
        name: "calculate",
        description: "Perform basic arithmetic calculations",
        inputSchema: {
            type: "object",
            properties: {
                operation: {
                    type: "string",
                    enum: ["add", "subtract", "multiply", "divide"],
                    description: "The arithmetic operation to perform",
                },
                a: {
                    type: "number",
                    description: "First number",
                },
                b: {
                    type: "number",
                    description: "Second number",
                },
            },
            required: ["operation", "a", "b"],
        },
    },
];
// List tools handler
server.setRequestHandler(ListToolsRequestSchema, async () => {
    return {
        tools: TOOLS,
    };
});
// Call tool handler
server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, arguments: args } = request.params;
    if (!args) {
        throw new McpError(ErrorCode.InvalidParams, "Missing arguments");
    }
    switch (name) {
        case "echo":
            const message = args.message;
            if (!message) {
                throw new McpError(ErrorCode.InvalidParams, "Missing message parameter");
            }
            return {
                content: [
                    {
                        type: "text",
                        text: `Echo: ${message}`,
                    },
                ],
            };
        case "get_time":
            return {
                content: [
                    {
                        type: "text",
                        text: `Current time: ${new Date().toISOString()}`,
                    },
                ],
            };
        case "calculate":
            const operation = args.operation;
            const a = args.a;
            const b = args.b;
            if (!operation || typeof a !== "number" || typeof b !== "number") {
                throw new McpError(ErrorCode.InvalidParams, "Missing or invalid parameters for calculation");
            }
            let result;
            switch (operation) {
                case "add":
                    result = a + b;
                    break;
                case "subtract":
                    result = a - b;
                    break;
                case "multiply":
                    result = a * b;
                    break;
                case "divide":
                    if (b === 0) {
                        throw new McpError(ErrorCode.InvalidParams, "Cannot divide by zero");
                    }
                    result = a / b;
                    break;
                default:
                    throw new McpError(ErrorCode.InvalidParams, `Unknown operation: ${operation}`);
            }
            return {
                content: [
                    {
                        type: "text",
                        text: `${a} ${operation} ${b} = ${result}`,
                    },
                ],
            };
        default:
            throw new McpError(ErrorCode.MethodNotFound, `Unknown tool: ${name}`);
    }
});
// Error handling
server.onerror = (error) => {
    console.error("[MCP Error]", error);
};
process.on("SIGINT", async () => {
    await server.close();
    process.exit(0);
});
// Start the server
async function main() {
    const transport = new StdioServerTransport();
    await server.connect(transport);
    console.error("MCP Server started successfully");
}
main().catch((error) => {
    console.error("Failed to start MCP server:", error);
    process.exit(1);
});
//# sourceMappingURL=index.js.map