import { Elysia, t } from 'elysia'
import { mkdir, cp } from "node:fs/promises";
import path from 'node:path';
import OpenAI from 'openai';
import { $ } from "bun";
import cors from '@elysia/cors';
import { existsSync } from 'node:fs';

const openai = new OpenAI({
  baseURL: 'https://api.deepseek.com',
  apiKey: 'sk-xxxxxxxxxxxxxxxxxxxxxxxxxxx'
});
function sanitizeTypstContent(text: string, workDir: string): string {
  if (typeof text !== 'string') return text;
  let processed = text.replace(/(?<!\\)#([0-9a-fA-F]{6}\b|[0-9a-fA-F]{3}\b|[0-9]+\b)/g, '\\#$1');
  processed = processed.replace(/\$\$([^$]+)\$\$/g, (_match, math: string) => {
    return `#mitex(\`${math}\`)`;
  });
  
  processed = processed.replace(/\$([^$]+)\$/g, (_match, math: string) => {
    return `#mi(\`${math}\`)`;
  });

  processed = processed.replace(/#?image\s*\(\s*"([^"]+)"\s*(,[^)]*)?\)/g, (match, imgPath: string) => {
    const abs1 = path.join(workDir, 'sections', imgPath);
    const abs2 = path.join(workDir, imgPath);
    if (existsSync(abs1) || existsSync(abs2)) return match;
    const label = imgPath.split('/').pop() || imgPath;
    return `rect(width: 100%, height: 120pt, stroke: 0.5pt + luma(150), radius: 4pt, fill: luma(240), align(center + horizon)[#text(fill: luma(120), size: 10pt)[Imagen: ${label}]])`;
  });

  return `#import "@preview/mitex:0.2.4": *\n` + processed;
}
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
      reasoning_effort: "xhigh",
      max_tokens: 12288,
      messages: [
        { role: "system", content: contextPrompt },
        { role: "user", content: `Por favor, procesa el siguiente esquema y genera el reporte académico en español en formato JSON:\n\n${fileContent}` }
      ],
      response_format: { type: "json_object" }
    });

    const responseText = completion.choices[0].message.content || "{}";

    let jsonStr = responseText.trim();
    const fenceMatch = jsonStr.match(/```(?:json)?\s*\n?([\s\S]*?)\n?\s*```/);
    if (fenceMatch) jsonStr = fenceMatch[1].trim();

    let parsed: any;
    try {
      parsed = JSON.parse(jsonStr);
    } catch (e) {
      console.error("Failed to parse DeepSeek response as JSON:");
      console.error(jsonStr.slice(0, 500));
      throw new Error("DeepSeek returned invalid JSON");
    }

    if (!parsed.response) {
      console.error("Missing 'response' key in parsed JSON:", Object.keys(parsed));
      throw new Error("Invalid response structure from DeepSeek API");
    }

    const { intro, des, con, bib } = parsed.response;

    await Promise.all([
      Bun.write(`${tempFile}/sections/intro.typ`, sanitizeTypstContent(intro || "", tempFile)),
      Bun.write(`${tempFile}/sections/des.typ`, sanitizeTypstContent(des || "", tempFile)),
      Bun.write(`${tempFile}/sections/con.typ`, sanitizeTypstContent(con || "", tempFile)),
      Bun.write(`${tempFile}/bib.yaml`, bib || "")
    ]);

    console.info(`Compiling ${tempFile}/main.typ ...`);
    try {
      await $`typst c ${tempFile}/main.typ`;
    } catch (e: any) {
      console.error("Typst compilation failed:", e?.stderr?.toString() || e?.message || e);
      throw new Error("Typst compilation failed");
    }
    console.info(`PDF generated successfully`);

    return Bun.file(`${tempFile}/main.pdf`);

  }, {
    body: t.Object({
      file: t.File()
    })
  })
  .listen(3000)
