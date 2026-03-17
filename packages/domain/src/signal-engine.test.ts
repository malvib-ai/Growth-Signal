import { describe, expect, it } from "vitest";
import { generateSignal } from "./signal-engine";

describe("generateSignal", () => {
  it("marks a large drop as high confidence and high priority", () => {
    const result = generateSignal({
      connector: "meta_ads",
      metric: "roas",
      currentValue: 1.5,
      previousValue: 3,
      periodLabel: "daily"
    });

    expect(result.observation.deltaPercent).toBe(-50);
    expect(result.diagnosis.confidence).toBe("high");
    expect(result.recommendation.priority).toBe(1);
  });

  it("handles zero previous values safely", () => {
    const result = generateSignal({
      connector: "shopify",
      metric: "revenue",
      currentValue: 100,
      previousValue: 0,
      periodLabel: "weekly"
    });

    expect(result.observation.deltaPercent).toBe(100);
    expect(result.diagnosis.confidence).toBe("high");
  });
});
