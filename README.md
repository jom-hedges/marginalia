# Marginalia
An app that provides feedback in academic writing. Designed to foster creative thinking for students and academic writing.

## Considerations
1. Error handling - add an `onError` hook to return friendly messages (e.g., missing API key, file too large, etc)
2. Rate limiting - use `@elysiajs/rate-limit` to protect the LLM endpoint. According to the docs, as long as on the latest version of Bun and Elysia, then the latest version of `@elysiajs/rate-limit` should work just fine.
3. File size - Validate `file.size` in the handler before reading it.
4. Security - Never trust client-provided MIME types; inspect the file header or use `fileType` helper from Elysia.
5. OpenAPI docs - export a schema with `app.openapi()` 
6. Testing - Use `app.handle(new Request(...))` to unit-test the route without a real server.


## Development
To start the development server run:
```bash
bun run dev
```

Open http://localhost:3000/ with your browser to see the result.
