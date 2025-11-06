import fs from "fs";
import Elysia from "elysia";
import OpenAI from "openai";

 const client = new OpenAI({
   apiKey: process.env.OPENAI_SECRET_KEY, // store key in env
 })

const app = new Elysia().get("/", () => "Hello Elysia").listen(3000);

const file = await client.files.create({
  file: fs.createReadStream(""),
  purpose: "user_data"
})

const response = await client.responses.create({
  model: "gpt-5",
  input: "Write a one sentence story about a rabbit named Bumbleflower.",
});

console.log(
  `response.output_text`
);
