export type Connector = "shopify" | "meta_ads" | "google_ads" | "ga4";

export interface MetricSnapshot {
  connector: Connector;
  metric: "revenue" | "spend" | "roas" | "sessions" | "conversion_rate";
  currentValue: number;
  previousValue: number;
  periodLabel: "daily" | "weekly" | "monthly";
}

export interface Observation {
  summary: string;
  deltaPercent: number;
}

export interface Diagnosis {
  hypothesis: string;
  confidence: "low" | "medium" | "high";
  rationale: string;
}

export interface Recommendation {
  priority: 1 | 2 | 3;
  action: string;
  expectedImpact: string;
}

export interface SignalResult {
  observation: Observation;
  diagnosis: Diagnosis;
  recommendation: Recommendation;
}
