# Growth Signal Monorepo

A modular TypeScript monorepo for Growth Signal.

## Stack
- pnpm workspaces + Turborepo
- Next.js app router (`apps/web`)
- Fastify API (`apps/api`)
- BullMQ worker (`apps/worker`)
- Prisma + PostgreSQL (`packages/db`)
- Shared packages in `/packages`

## Project Structure

- `apps/web`: Next.js frontend with landing/login/dashboard/onboarding/settings/reports/chat shells
- `apps/api`: API service
- `apps/worker`: Background job service
- `packages/ui`: Shared UI components (shadcn-style primitives)
- `packages/types`: Shared TypeScript types
- `packages/db`: Prisma schema + DB client
- `packages/auth`, `packages/connectors`, `packages/analytics`, `packages/prompts`, `packages/memory`: domain modules

## Setup

1. Install dependencies:
   ```bash
   pnpm install
   ```
2. Copy environment files:
   ```bash
   cp .env.example .env
   cp apps/web/.env.example apps/web/.env.local
   cp apps/api/.env.example apps/api/.env
   cp apps/worker/.env.example apps/worker/.env
   ```
3. Generate Prisma client:
   ```bash
   pnpm --filter @growth-signal/db db:generate
   ```

## Run locally

Run everything:
```bash
pnpm dev
```

Or run each service:
```bash
pnpm --filter web dev
pnpm --filter api dev
pnpm --filter worker dev
```

Default ports:
- Web: `http://localhost:3000`
- API: `http://localhost:4000`

## Useful scripts
- `pnpm build`
- `pnpm lint`
- `pnpm test`
- `pnpm typecheck`

## Database
Prisma schema is at `packages/db/prisma/schema.prisma`.

## Docker
- `apps/api/Dockerfile`
- `apps/worker/Dockerfile`
