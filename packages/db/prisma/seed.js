import { PrismaClient, ConnectorType, ConnectorStatus, Grain, InsightStatus, MessageRole, RecommendationStatus, ReportType, WorkspaceRole } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const user = await prisma.user.upsert({
    where: { email: 'demo@growthsignal.app' },
    update: { name: 'Demo Founder' },
    create: { email: 'demo@growthsignal.app', name: 'Demo Founder' }
  });


  await prisma.workspace.deleteMany({ where: { slug: 'demo-growth' } });

  const workspace = await prisma.workspace.upsert({
    where: { slug: 'demo-growth' },
    update: { name: 'Demo Growth Workspace' },
    create: { name: 'Demo Growth Workspace', slug: 'demo-growth', timezone: 'UTC' }
  });

  await prisma.workspaceMember.upsert({
    where: { workspaceId_userId: { workspaceId: workspace.id, userId: user.id } },
    update: { role: WorkspaceRole.OWNER },
    create: { workspaceId: workspace.id, userId: user.id, role: WorkspaceRole.OWNER }
  });

  const connector = await prisma.connector.create({
    data: {
      workspaceId: workspace.id,
      type: ConnectorType.SHOPIFY,
      status: ConnectorStatus.ACTIVE,
      displayName: 'Shopify Main Store',
      sourceMetadata: { region: 'US' }
    }
  });

  const account = await prisma.connectorAccount.create({
    data: {
      workspaceId: workspace.id,
      connectorId: connector.id,
      externalAccountId: 'shopify-store-1',
      accountName: 'Main Store',
      sourceSystem: ConnectorType.SHOPIFY,
      isPrimary: true,
      sourceMetadata: { domain: 'demo-store.myshopify.com' }
    }
  });

  const product = await prisma.product.create({
    data: {
      workspaceId: workspace.id,
      sku: 'SKU-001',
      name: 'Hero Product',
      sourceSystem: ConnectorType.SHOPIFY,
      sourceEntityId: 'gid://shopify/Product/1',
      sourceMetadata: { productType: 'Supplements' }
    }
  });

  const landingPage = await prisma.landingPage.create({
    data: {
      workspaceId: workspace.id,
      url: 'https://demo-store.com/products/hero-product',
      normalizedPath: '/products/hero-product',
      sourceSystem: ConnectorType.GA4,
      sourceEntityId: 'page:/products/hero-product',
      sourceMetadata: { channelHint: 'organic' }
    }
  });

  const campaign = await prisma.campaign.create({
    data: {
      workspaceId: workspace.id,
      connectorAccountId: account.id,
      name: 'Spring Prospecting',
      status: 'ACTIVE',
      sourceSystem: ConnectorType.META_ADS,
      sourceEntityId: 'cmp_1001'
    }
  });

  const adGroup = await prisma.adGroupOrAdSet.create({
    data: {
      workspaceId: workspace.id,
      connectorAccountId: account.id,
      campaignId: campaign.id,
      name: 'US Broad 25-45',
      status: 'ACTIVE',
      sourceSystem: ConnectorType.META_ADS,
      sourceEntityId: 'adset_2001'
    }
  });

  const ad = await prisma.ad.create({
    data: {
      workspaceId: workspace.id,
      connectorAccountId: account.id,
      adGroupOrAdSetId: adGroup.id,
      name: 'Creator Video A',
      status: 'ACTIVE',
      sourceSystem: ConnectorType.META_ADS,
      sourceEntityId: 'ad_3001'
    }
  });

  const creative = await prisma.creative.create({
    data: {
      workspaceId: workspace.id,
      connectorAccountId: account.id,
      adId: ad.id,
      title: 'Try Hero Product Today',
      body: 'Clinically backed formula with fast shipping.',
      destinationUrl: 'https://demo-store.com/products/hero-product',
      sourceSystem: ConnectorType.META_ADS,
      sourceEntityId: 'creative_4001'
    }
  });

  await prisma.dailyMetricFact.create({
    data: {
      workspaceId: workspace.id,
      date: new Date('2026-01-10T00:00:00.000Z'),
      grain: Grain.DAILY,
      sourceSystem: ConnectorType.META_ADS,
      sourceEntityId: 'fact_5001',
      impressions: 42000,
      clicks: 1300,
      spend: 1543.22,
      revenue: 3890.4,
      conversions: 92,
      sessions: 960,
      users: 840,
      orders: 74,
      productId: product.id,
      landingPageId: landingPage.id,
      campaignId: campaign.id,
      adGroupOrAdSetId: adGroup.id,
      adId: ad.id,
      creativeId: creative.id,
      sourceMetadata: { conflictGroup: 'meta-vs-ga4', selectedSource: 'META_ADS' }
    }
  });

  const insight = await prisma.insight.create({
    data: {
      workspaceId: workspace.id,
      title: 'CTR is strong but LP conversion is lagging',
      summary: 'Top-funnel engagement is healthy; conversion drop appears post-click.',
      confidenceScore: 0.86,
      status: InsightStatus.OPEN,
      occurredOn: new Date('2026-01-10T00:00:00.000Z'),
      sourceSystem: ConnectorType.GA4,
      sourceMetadata: { benchmark: 'last_14_days' }
    }
  });

  await prisma.recommendation.create({
    data: {
      workspaceId: workspace.id,
      insightId: insight.id,
      title: 'Test shorter checkout landing variant',
      action: 'Create variant with fewer above-the-fold blocks and stronger CTA.',
      rationale: 'High CTR + weak CVR usually indicates landing friction.',
      confidenceScore: 0.79,
      status: RecommendationStatus.ACTIVE,
      sourceSystem: ConnectorType.GA4
    }
  });

  await prisma.learning.create({
    data: {
      workspaceId: workspace.id,
      key: 'lp_short_form_win',
      title: 'Short-form landing pages improved CVR',
      content: 'In prior tests, short-form pages improved checkout starts by 12%.',
      tags: ['landing-page', 'conversion-rate', 'experiment'],
      confidenceScore: 0.74,
      sourceSystem: ConnectorType.GA4
    }
  });

  await prisma.guideline.create({
    data: {
      workspaceId: workspace.id,
      title: 'Always include source attribution in generated reports',
      content: 'Any recommendation should cite source systems and confidence.',
      sourceSystem: ConnectorType.GA4
    }
  });

  await prisma.report.create({
    data: {
      workspaceId: workspace.id,
      createdById: user.id,
      type: ReportType.EXECUTIVE_SUMMARY,
      period: Grain.WEEKLY,
      periodStart: new Date('2026-01-05T00:00:00.000Z'),
      periodEnd: new Date('2026-01-11T23:59:59.000Z'),
      title: 'Weekly Growth Summary',
      summary: 'Revenue up 8% WoW with stable CAC.',
      sourceMetadata: { includes: ['daily_metric_facts', 'insights', 'recommendations'] }
    }
  });

  const chatSession = await prisma.chatSession.create({
    data: {
      workspaceId: workspace.id,
      userId: user.id,
      title: 'Why did CVR drop this week?'
    }
  });

  await prisma.chatMessage.createMany({
    data: [
      {
        workspaceId: workspace.id,
        chatSessionId: chatSession.id,
        userId: user.id,
        role: MessageRole.USER,
        content: 'What changed in paid social conversion rate this week?'
      },
      {
        workspaceId: workspace.id,
        chatSessionId: chatSession.id,
        role: MessageRole.ASSISTANT,
        content: 'CTR improved, but landing page conversion fell by ~14% versus prior week.'
      }
    ]
  });

  console.log('Seeded demo workspace:', workspace.slug);
}

main()
  .catch(async (error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
