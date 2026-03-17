-- Create enums
CREATE TYPE "WorkspaceRole" AS ENUM ('OWNER', 'ADMIN', 'MEMBER', 'VIEWER');
CREATE TYPE "ConnectorType" AS ENUM ('SHOPIFY', 'META_ADS', 'GOOGLE_ADS', 'GA4');
CREATE TYPE "ConnectorStatus" AS ENUM ('ACTIVE', 'PAUSED', 'ERROR', 'DISCONNECTED');
CREATE TYPE "SyncStatus" AS ENUM ('QUEUED', 'RUNNING', 'SUCCEEDED', 'FAILED', 'CANCELED');
CREATE TYPE "Grain" AS ENUM ('DAILY', 'WEEKLY', 'MONTHLY');
CREATE TYPE "InsightStatus" AS ENUM ('OPEN', 'ACKNOWLEDGED', 'RESOLVED', 'DISMISSED');
CREATE TYPE "RecommendationStatus" AS ENUM ('DRAFT', 'ACTIVE', 'ACCEPTED', 'REJECTED', 'APPLIED');
CREATE TYPE "ReportType" AS ENUM ('PERFORMANCE', 'ATTRIBUTION', 'FUNNEL', 'EXECUTIVE_SUMMARY');
CREATE TYPE "Channel" AS ENUM ('PAID_SOCIAL', 'PAID_SEARCH', 'ECOMMERCE', 'ANALYTICS', 'OTHER');
CREATE TYPE "MessageRole" AS ENUM ('SYSTEM', 'USER', 'ASSISTANT');

CREATE TABLE "User" (
  "id" TEXT NOT NULL,
  "email" TEXT NOT NULL,
  "name" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Workspace" (
  "id" TEXT NOT NULL,
  "name" TEXT NOT NULL,
  "slug" TEXT NOT NULL,
  "timezone" TEXT NOT NULL DEFAULT 'UTC',
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "Workspace_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "WorkspaceMember" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "userId" TEXT NOT NULL,
  "role" "WorkspaceRole" NOT NULL DEFAULT 'MEMBER',
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "WorkspaceMember_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Connector" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "type" "ConnectorType" NOT NULL,
  "status" "ConnectorStatus" NOT NULL DEFAULT 'ACTIVE',
  "displayName" TEXT NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  "lastSyncedAt" TIMESTAMP(3),
  "sourceMetadata" JSONB,
  CONSTRAINT "Connector_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "ConnectorAccount" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "connectorId" TEXT NOT NULL,
  "externalAccountId" TEXT NOT NULL,
  "accountName" TEXT NOT NULL,
  "channel" "Channel" NOT NULL DEFAULT 'OTHER',
  "currency" TEXT,
  "isPrimary" BOOLEAN NOT NULL DEFAULT false,
  "sourceSystem" "ConnectorType" NOT NULL,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "ConnectorAccount_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "OAuthToken" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "connectorAccountId" TEXT NOT NULL,
  "provider" "ConnectorType" NOT NULL,
  "accessTokenEncrypted" TEXT NOT NULL,
  "refreshTokenEncrypted" TEXT,
  "scope" TEXT,
  "expiresAt" TIMESTAMP(3),
  "tokenType" TEXT,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "OAuthToken_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "SyncRun" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "connectorAccountId" TEXT NOT NULL,
  "status" "SyncStatus" NOT NULL DEFAULT 'QUEUED',
  "startedAt" TIMESTAMP(3),
  "finishedAt" TIMESTAMP(3),
  "recordsRead" INTEGER NOT NULL DEFAULT 0,
  "recordsWritten" INTEGER NOT NULL DEFAULT 0,
  "errorMessage" TEXT,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "SyncRun_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Product" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "sku" TEXT,
  "name" TEXT NOT NULL,
  "sourceSystem" "ConnectorType" NOT NULL,
  "sourceEntityId" TEXT NOT NULL,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "LandingPage" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "url" TEXT NOT NULL,
  "normalizedPath" TEXT NOT NULL,
  "sourceSystem" "ConnectorType" NOT NULL,
  "sourceEntityId" TEXT NOT NULL,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "LandingPage_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Campaign" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "connectorAccountId" TEXT,
  "name" TEXT NOT NULL,
  "status" TEXT,
  "sourceSystem" "ConnectorType" NOT NULL,
  "sourceEntityId" TEXT NOT NULL,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "Campaign_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "AdGroupOrAdSet" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "connectorAccountId" TEXT,
  "campaignId" TEXT,
  "name" TEXT NOT NULL,
  "status" TEXT,
  "sourceSystem" "ConnectorType" NOT NULL,
  "sourceEntityId" TEXT NOT NULL,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "AdGroupOrAdSet_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Ad" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "connectorAccountId" TEXT,
  "adGroupOrAdSetId" TEXT,
  "name" TEXT NOT NULL,
  "status" TEXT,
  "sourceSystem" "ConnectorType" NOT NULL,
  "sourceEntityId" TEXT NOT NULL,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "Ad_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Creative" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "connectorAccountId" TEXT,
  "adId" TEXT,
  "title" TEXT,
  "body" TEXT,
  "destinationUrl" TEXT,
  "sourceSystem" "ConnectorType" NOT NULL,
  "sourceEntityId" TEXT NOT NULL,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "Creative_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "DailyMetricFact" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "date" TIMESTAMP(3) NOT NULL,
  "grain" "Grain" NOT NULL DEFAULT 'DAILY',
  "sourceSystem" "ConnectorType" NOT NULL,
  "sourceEntityId" TEXT,
  "sourceUpdatedAt" TIMESTAMP(3),
  "sourceMetadata" JSONB,
  "impressions" INTEGER NOT NULL DEFAULT 0,
  "clicks" INTEGER NOT NULL DEFAULT 0,
  "spend" DECIMAL(14,2) NOT NULL DEFAULT 0,
  "revenue" DECIMAL(14,2) NOT NULL DEFAULT 0,
  "conversions" DECIMAL(14,2) NOT NULL DEFAULT 0,
  "sessions" INTEGER NOT NULL DEFAULT 0,
  "users" INTEGER NOT NULL DEFAULT 0,
  "orders" INTEGER NOT NULL DEFAULT 0,
  "productId" TEXT,
  "landingPageId" TEXT,
  "campaignId" TEXT,
  "adGroupOrAdSetId" TEXT,
  "adId" TEXT,
  "creativeId" TEXT,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "DailyMetricFact_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Insight" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "title" TEXT NOT NULL,
  "summary" TEXT NOT NULL,
  "confidenceScore" DECIMAL(4,3) NOT NULL,
  "status" "InsightStatus" NOT NULL DEFAULT 'OPEN',
  "occurredOn" TIMESTAMP(3) NOT NULL,
  "sourceSystem" "ConnectorType" NOT NULL,
  "sourceEntityId" TEXT,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "Insight_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Recommendation" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "insightId" TEXT,
  "title" TEXT NOT NULL,
  "action" TEXT NOT NULL,
  "rationale" TEXT,
  "confidenceScore" DECIMAL(4,3) NOT NULL,
  "status" "RecommendationStatus" NOT NULL DEFAULT 'DRAFT',
  "sourceSystem" "ConnectorType" NOT NULL,
  "sourceEntityId" TEXT,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "Recommendation_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Report" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "createdById" TEXT,
  "type" "ReportType" NOT NULL,
  "period" "Grain" NOT NULL,
  "periodStart" TIMESTAMP(3) NOT NULL,
  "periodEnd" TIMESTAMP(3) NOT NULL,
  "title" TEXT NOT NULL,
  "summary" TEXT,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "Report_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Learning" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "key" TEXT NOT NULL,
  "title" TEXT NOT NULL,
  "content" TEXT NOT NULL,
  "tags" TEXT[],
  "confidenceScore" DECIMAL(4,3),
  "sourceSystem" "ConnectorType",
  "sourceEntityId" TEXT,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "Learning_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Guideline" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "title" TEXT NOT NULL,
  "content" TEXT NOT NULL,
  "isActive" BOOLEAN NOT NULL DEFAULT true,
  "sourceSystem" "ConnectorType",
  "sourceEntityId" TEXT,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "Guideline_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "ChatSession" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "userId" TEXT,
  "title" TEXT,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "ChatSession_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "ChatMessage" (
  "id" TEXT NOT NULL,
  "workspaceId" TEXT NOT NULL,
  "chatSessionId" TEXT NOT NULL,
  "userId" TEXT,
  "role" "MessageRole" NOT NULL,
  "content" TEXT NOT NULL,
  "sourceMetadata" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "ChatMessage_pkey" PRIMARY KEY ("id")
);

-- Unique indexes
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
CREATE UNIQUE INDEX "Workspace_slug_key" ON "Workspace"("slug");
CREATE UNIQUE INDEX "WorkspaceMember_workspaceId_userId_key" ON "WorkspaceMember"("workspaceId", "userId");
CREATE UNIQUE INDEX "Connector_workspaceId_type_displayName_key" ON "Connector"("workspaceId", "type", "displayName");
CREATE UNIQUE INDEX "ConnectorAccount_workspaceId_externalAccountId_sourceSystem_key" ON "ConnectorAccount"("workspaceId", "externalAccountId", "sourceSystem");
CREATE UNIQUE INDEX "Product_workspaceId_sourceSystem_sourceEntityId_key" ON "Product"("workspaceId", "sourceSystem", "sourceEntityId");
CREATE UNIQUE INDEX "LandingPage_workspaceId_normalizedPath_sourceSystem_key" ON "LandingPage"("workspaceId", "normalizedPath", "sourceSystem");
CREATE UNIQUE INDEX "Campaign_workspaceId_sourceSystem_sourceEntityId_key" ON "Campaign"("workspaceId", "sourceSystem", "sourceEntityId");
CREATE UNIQUE INDEX "AdGroupOrAdSet_workspaceId_sourceSystem_sourceEntityId_key" ON "AdGroupOrAdSet"("workspaceId", "sourceSystem", "sourceEntityId");
CREATE UNIQUE INDEX "Ad_workspaceId_sourceSystem_sourceEntityId_key" ON "Ad"("workspaceId", "sourceSystem", "sourceEntityId");
CREATE UNIQUE INDEX "Creative_workspaceId_sourceSystem_sourceEntityId_key" ON "Creative"("workspaceId", "sourceSystem", "sourceEntityId");
CREATE UNIQUE INDEX "Learning_workspaceId_key_key" ON "Learning"("workspaceId", "key");

-- Secondary indexes
CREATE INDEX "WorkspaceMember_userId_idx" ON "WorkspaceMember"("userId");
CREATE INDEX "Connector_workspaceId_type_idx" ON "Connector"("workspaceId", "type");
CREATE INDEX "ConnectorAccount_workspaceId_connectorId_idx" ON "ConnectorAccount"("workspaceId", "connectorId");
CREATE INDEX "OAuthToken_workspaceId_provider_idx" ON "OAuthToken"("workspaceId", "provider");
CREATE INDEX "OAuthToken_connectorAccountId_idx" ON "OAuthToken"("connectorAccountId");
CREATE INDEX "SyncRun_workspaceId_status_createdAt_idx" ON "SyncRun"("workspaceId", "status", "createdAt");
CREATE INDEX "SyncRun_connectorAccountId_createdAt_idx" ON "SyncRun"("connectorAccountId", "createdAt");
CREATE INDEX "DailyMetricFact_workspaceId_date_grain_idx" ON "DailyMetricFact"("workspaceId", "date", "grain");
CREATE INDEX "DailyMetricFact_workspaceId_sourceSystem_date_idx" ON "DailyMetricFact"("workspaceId", "sourceSystem", "date");
CREATE INDEX "Product_workspaceId_sku_idx" ON "Product"("workspaceId", "sku");
CREATE INDEX "Campaign_workspaceId_connectorAccountId_idx" ON "Campaign"("workspaceId", "connectorAccountId");
CREATE INDEX "AdGroupOrAdSet_workspaceId_campaignId_idx" ON "AdGroupOrAdSet"("workspaceId", "campaignId");
CREATE INDEX "Ad_workspaceId_adGroupOrAdSetId_idx" ON "Ad"("workspaceId", "adGroupOrAdSetId");
CREATE INDEX "Creative_workspaceId_adId_idx" ON "Creative"("workspaceId", "adId");
CREATE INDEX "Insight_workspaceId_status_occurredOn_idx" ON "Insight"("workspaceId", "status", "occurredOn");
CREATE INDEX "Recommendation_workspaceId_status_createdAt_idx" ON "Recommendation"("workspaceId", "status", "createdAt");
CREATE INDEX "Report_workspaceId_period_periodStart_idx" ON "Report"("workspaceId", "period", "periodStart");
CREATE INDEX "Learning_workspaceId_updatedAt_idx" ON "Learning"("workspaceId", "updatedAt");
CREATE INDEX "Guideline_workspaceId_isActive_idx" ON "Guideline"("workspaceId", "isActive");
CREATE INDEX "ChatSession_workspaceId_createdAt_idx" ON "ChatSession"("workspaceId", "createdAt");
CREATE INDEX "ChatMessage_workspaceId_chatSessionId_createdAt_idx" ON "ChatMessage"("workspaceId", "chatSessionId", "createdAt");

-- Foreign keys
ALTER TABLE "WorkspaceMember" ADD CONSTRAINT "WorkspaceMember_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "WorkspaceMember" ADD CONSTRAINT "WorkspaceMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Connector" ADD CONSTRAINT "Connector_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "ConnectorAccount" ADD CONSTRAINT "ConnectorAccount_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "ConnectorAccount" ADD CONSTRAINT "ConnectorAccount_connectorId_fkey" FOREIGN KEY ("connectorId") REFERENCES "Connector"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "OAuthToken" ADD CONSTRAINT "OAuthToken_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "OAuthToken" ADD CONSTRAINT "OAuthToken_connectorAccountId_fkey" FOREIGN KEY ("connectorAccountId") REFERENCES "ConnectorAccount"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SyncRun" ADD CONSTRAINT "SyncRun_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SyncRun" ADD CONSTRAINT "SyncRun_connectorAccountId_fkey" FOREIGN KEY ("connectorAccountId") REFERENCES "ConnectorAccount"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Product" ADD CONSTRAINT "Product_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "LandingPage" ADD CONSTRAINT "LandingPage_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Campaign" ADD CONSTRAINT "Campaign_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Campaign" ADD CONSTRAINT "Campaign_connectorAccountId_fkey" FOREIGN KEY ("connectorAccountId") REFERENCES "ConnectorAccount"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "AdGroupOrAdSet" ADD CONSTRAINT "AdGroupOrAdSet_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "AdGroupOrAdSet" ADD CONSTRAINT "AdGroupOrAdSet_connectorAccountId_fkey" FOREIGN KEY ("connectorAccountId") REFERENCES "ConnectorAccount"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "AdGroupOrAdSet" ADD CONSTRAINT "AdGroupOrAdSet_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_connectorAccountId_fkey" FOREIGN KEY ("connectorAccountId") REFERENCES "ConnectorAccount"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_adGroupOrAdSetId_fkey" FOREIGN KEY ("adGroupOrAdSetId") REFERENCES "AdGroupOrAdSet"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Creative" ADD CONSTRAINT "Creative_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Creative" ADD CONSTRAINT "Creative_connectorAccountId_fkey" FOREIGN KEY ("connectorAccountId") REFERENCES "ConnectorAccount"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Creative" ADD CONSTRAINT "Creative_adId_fkey" FOREIGN KEY ("adId") REFERENCES "Ad"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "DailyMetricFact" ADD CONSTRAINT "DailyMetricFact_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "DailyMetricFact" ADD CONSTRAINT "DailyMetricFact_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "DailyMetricFact" ADD CONSTRAINT "DailyMetricFact_landingPageId_fkey" FOREIGN KEY ("landingPageId") REFERENCES "LandingPage"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "DailyMetricFact" ADD CONSTRAINT "DailyMetricFact_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "Campaign"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "DailyMetricFact" ADD CONSTRAINT "DailyMetricFact_adGroupOrAdSetId_fkey" FOREIGN KEY ("adGroupOrAdSetId") REFERENCES "AdGroupOrAdSet"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "DailyMetricFact" ADD CONSTRAINT "DailyMetricFact_adId_fkey" FOREIGN KEY ("adId") REFERENCES "Ad"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "DailyMetricFact" ADD CONSTRAINT "DailyMetricFact_creativeId_fkey" FOREIGN KEY ("creativeId") REFERENCES "Creative"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Insight" ADD CONSTRAINT "Insight_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Recommendation" ADD CONSTRAINT "Recommendation_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Recommendation" ADD CONSTRAINT "Recommendation_insightId_fkey" FOREIGN KEY ("insightId") REFERENCES "Insight"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Report" ADD CONSTRAINT "Report_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Report" ADD CONSTRAINT "Report_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "Learning" ADD CONSTRAINT "Learning_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "Guideline" ADD CONSTRAINT "Guideline_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "ChatSession" ADD CONSTRAINT "ChatSession_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "ChatSession" ADD CONSTRAINT "ChatSession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "ChatMessage" ADD CONSTRAINT "ChatMessage_workspaceId_fkey" FOREIGN KEY ("workspaceId") REFERENCES "Workspace"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "ChatMessage" ADD CONSTRAINT "ChatMessage_chatSessionId_fkey" FOREIGN KEY ("chatSessionId") REFERENCES "ChatSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "ChatMessage" ADD CONSTRAINT "ChatMessage_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
