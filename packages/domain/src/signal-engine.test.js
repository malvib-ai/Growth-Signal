import test from "node:test";
import assert from "node:assert/strict";
import { generateSignal } from "./signal-engine.js";

test("marks a large drop as high confidence and high priority", () => {
  const result = generateSignal({
    connector: "meta_ads",
    metric: "roas",
    currentValue: 1.5,
    previousValue: 3,
    periodLabel: "daily"
  });

  assert.equal(result.observation.deltaPercent, -50);
  assert.equal(result.diagnosis.confidence, "high");
  assert.equal(result.recommendation.priority, 1);
});

test("handles zero previous values safely", () => {
  const result = generateSignal({
    connector: "shopify",
    metric: "revenue",
    currentValue: 100,
    previousValue: 0,
    periodLabel: "weekly"
  });

  assert.equal(result.observation.deltaPercent, 100);
  assert.equal(result.diagnosis.confidence, "high");
});
