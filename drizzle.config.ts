import { defineConfig } from "drizzle-kit";
export default defineConfig({
	schema: "./src/db/schema.ts",
	out: "./database/migrations",
	dialect: "sqlite",
	driver: "d1-http"
});
