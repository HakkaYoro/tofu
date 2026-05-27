import { Elysia, t } from 'elysia'
import { mkdir, cp } from "node:fs/promises";
import path from 'node:path';
import OpenAI from 'openai';
import { $ } from "bun";
import cors from '@elysia/cors';

const openai = new OpenAI({
  baseURL: 'https://api.deepseek.com', // Required for DeepSeek
  apiKey: 'sk-11475504746a4b3b96858bc7def7f70e'
});

new Elysia()
  .use(cors())
  .post('/generate', async ({ body: { file } }) => {

    if (file.size === 0) throw new Error("Empty file provided")
    if (file.type !== 'text/markdown') throw new Error("File type not valid")

    const proyectId = crypto.randomUUID()
    const tempFile = `/tmp/t-${proyectId}`
    const typstTemplatePath = path.join(process.cwd(), './template')

    console.info(`Generating workspace ${proyectId} in ${tempFile}`)

    await mkdir(path.dirname(tempFile), { recursive: true });
    await cp(typstTemplatePath, tempFile, { recursive: true });

    const contextPrompt = await Bun.file(path.join(process.cwd(), './CONTEXT.md')).text();
    const fileContent = await file.text();

    const completion = await openai.chat.completions.create({
      model: "deepseek-v4-flash",
      messages: [
        { role: "system", content: contextPrompt },
        { role: "user", content: `Por favor, procesa el siguiente esquema y genera el reporte académico en español en formato JSON:\n\n${fileContent}` }
      ],
      response_format: { type: "json_object" }
    });

    const responseText = completion.choices[0].message.content || "{}";
    const parsed = JSON.parse(responseText);

    if (!parsed.response) {
      throw new Error("Invalid response structure from DeepSeek API");
    }

    const { intro, des, con, bib } = parsed.response;

    await Promise.all([
      Bun.write(`${tempFile}/sections/intro.typ`, intro || ""),
      Bun.write(`${tempFile}/sections/des.typ`, des || ""),
      Bun.write(`${tempFile}/sections/con.typ`, con || ""),
      Bun.write(`${tempFile}/bib.yaml`, bib || "")
    ]);

    await $`typst c ${tempFile}/main.typ`;

    return Bun.file(`${tempFile}/main.pdf`);

  }, {
    body: t.Object({
      file: t.File()
    })
  })
  .listen(3000)
