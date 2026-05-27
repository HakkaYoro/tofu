FROM oven/bun:1 AS base
WORKDIR /usr/src/app

FROM base AS install
RUN mkdir -p /temp/prod
COPY package.json bun.lock /temp/prod/
RUN cd /temp/prod && bun install

FROM base AS prerelease
COPY --from=install /temp/prod/node_modules node_modules
COPY . .

ENV NODE_ENV=production
RUN bun run build --compile --minify-whitespace --minify-syntax --target bun-linux-x64 --outfile server src/index.ts

FROM base AS release
COPY --from=prerelease /usr/src/app/server .
COPY --from=prerelease /usr/src/app/CONTEXT.md .
COPY --from=prerelease /usr/src/app/template ./template

# Copy typst binary from the official Typst image
COPY --from=ghcr.io/typst/typst:latest /bin/typst /usr/local/bin/typst

# Copy pre-downloaded Typst packages into the cache folder under the 'bun' user
COPY --chown=bun:bun typst-packages/packages/ /home/bun/.cache/typst/packages/

# Run as non-root user for security
USER bun
EXPOSE 3000/tcp
ENTRYPOINT [ "./server" ]
