FROM node:20-alpine
WORKDIR /app
RUN corepack enable
COPY package.json pnpm-workspace.yaml turbo.json tsconfig.base.json ./
COPY apps/worker/package.json apps/worker/package.json
COPY packages/types/package.json packages/types/package.json
RUN pnpm install --filter worker... --frozen-lockfile=false
COPY . .
RUN pnpm --filter worker build
CMD ["pnpm", "--filter", "worker", "start"]
