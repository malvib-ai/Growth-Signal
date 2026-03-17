FROM node:20-alpine
WORKDIR /app
RUN corepack enable
COPY package.json pnpm-workspace.yaml turbo.json tsconfig.base.json ./
COPY apps/api/package.json apps/api/package.json
COPY packages/types/package.json packages/types/package.json
COPY packages/db/package.json packages/db/package.json
RUN pnpm install --filter api... --frozen-lockfile=false
COPY . .
RUN pnpm --filter api build
EXPOSE 4000
CMD ["pnpm", "--filter", "api", "start"]
