import fs from "fs";
import { Elysia, t, file } from "elysia";
import OpenAI from "openai";

 const client = new OpenAI({
   apiKey: process.env.OPENAI_API_KEY, // store key in env
 })

const app = new Elysia()
  //---------------------------------------- 
  // post /review endpoint - receive a paper
  //----------------------------------------
  .post('review', async ({ body: { title, file } }) => {
    // read the uploaded file as text
    const arrayBuffer = await file.arrayBuffer();
    const paperText = new TextDecoder().decode(arrayBuffer);

    // call the LLM
    const { choices } = await client.chat.completions.create({
      model: "gpt-40-mini",
      messages: [
        {
          role: "system",
          content: "You are an expert academic reviewer. Provide constructive feedback on the paper provided by the user.",
        },
        {
          role: "user",
          content: `Please review the following paper titled "${title}":\n\n${paperText}`,
        },
      ],
    });

    // extract feedback; return's the LLM's answer
    const feedback = choices[0].message.content;

    // return feedback
    return { feedback };    
  })

const uploadedPaper = await client.files.create({
  file: fs.createReadStream("assets/cat-cache-test.txt"), // add a file here
  purpose: "user_data"
})

const response = await client.responses.create({
  model: "gpt-5",
  input: "Write a one sentence story about a rabbit named Bumbleflower.",
});

// validation
body: t.Object({
  title: t.String(),
  file: t.File({ format: 'application/pdf|text/plain|application|msword'  }),
})
.listen(3000);

console.log(
  `response.output_text`
);

export type App = typeof app;

