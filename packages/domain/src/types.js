/** @typedef {"shopify" | "meta_ads" | "google_ads" | "ga4"} Connector */
/** @typedef {"revenue" | "spend" | "roas" | "sessions" | "conversion_rate"} Metric */
/** @typedef {"daily" | "weekly" | "monthly"} PeriodLabel */

/**
 * @typedef {Object} MetricSnapshot
 * @property {Connector} connector
 * @property {Metric} metric
 * @property {number} currentValue
 * @property {number} previousValue
 * @property {PeriodLabel} periodLabel
 */

/**
 * @typedef {Object} SignalResult
 * @property {{summary: string, deltaPercent: number}} observation
 * @property {{hypothesis: string, confidence: "low" | "medium" | "high", rationale: string}} diagnosis
 * @property {{priority: 1 | 2 | 3, action: string, expectedImpact: string}} recommendation
 */

export {};
