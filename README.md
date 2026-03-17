# Growth Signal (Beta) — Phase 0 Foundation

This repository starts with a **small, production-minded foundation** for Growth Signal.

## What is included in this phase
- Monorepo-style workspace structure (`apps/*`, `packages/*`)
- A typed `@growth-signal/domain` package for core data contracts
- A tiny, testable signal engine prototype that separates:
  - observation
  - diagnosis
  - confidence
  - recommendation

## Why this phase exists
Before building UI and connectors, we need clean contracts and a deterministic, testable analysis layer.
This keeps LLM features and product presentation decoupled from source-of-truth business logic.

## Next suggested phase
1. Add a minimal Next.js `apps/web` app with:
   - auth stub
   - onboarding shell
   - daily signal summary view from mocked normalized data
2. Add `packages/connectors` interfaces for read-only sync contracts.

## Run tests
```bash
npm install
npm test
```

## TODO (production-hard)
- Define confidence calibration strategy across connectors
- Add event-level lineage metadata for observability and support debugging
- Add queue-oriented sync lifecycle contract (`queued`, `running`, `retrying`, `failed`, `succeeded`)
- Add persisted memory contract for recommendations and user feedback loops

## Database schema rationale (Prisma + PostgreSQL)
- The schema is **workspace-scoped first** so every major model carries `workspaceId` and indexed access paths for multi-tenant isolation in beta.
- Integrations are split into `Connector` (provider connection), `ConnectorAccount` (ad/store/account scope), `OAuthToken` (credential lifecycle), and `SyncRun` (sync observability).
- Normalized marketing/ecommerce entities (`Campaign`, `AdGroupOrAdSet`, `Ad`, `Creative`, `Product`, `LandingPage`) use `sourceSystem + sourceEntityId + sourceMetadata` to preserve lineage and resolve source-truth conflicts.
- `DailyMetricFact` stores denormalized daily/weekly/monthly grain metrics and optional dimension references so reports can aggregate across channels without coupling to raw provider schemas.
- Decision-support objects (`Insight`, `Recommendation`, `Learning`) include confidence scoring and source attribution metadata for explainable AI outputs and retrieval of prior learnings.
- `Report` supports `DAILY`, `WEEKLY`, and `MONTHLY` periods; `ChatSession` and `ChatMessage` persist analyst/assistant context linked to workspace history.
