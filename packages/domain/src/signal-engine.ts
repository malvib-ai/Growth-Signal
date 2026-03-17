import { MetricSnapshot, SignalResult } from "./types";

function deltaPercent(currentValue: number, previousValue: number): number {
  if (previousValue === 0) {
    return currentValue === 0 ? 0 : 100;
  }

  return ((currentValue - previousValue) / Math.abs(previousValue)) * 100;
}

export function generateSignal(snapshot: MetricSnapshot): SignalResult {
  const delta = deltaPercent(snapshot.currentValue, snapshot.previousValue);
  const direction = delta >= 0 ? "up" : "down";
  const absDelta = Math.abs(delta);

  const confidence =
    absDelta >= 30 ? "high" :
    absDelta >= 12 ? "medium" :
    "low";

  const observation = {
    summary: `${snapshot.connector} ${snapshot.metric} is ${direction} ${absDelta.toFixed(1)}% ${snapshot.periodLabel}-over-${snapshot.periodLabel}.`,
    deltaPercent: Number(delta.toFixed(2))
  } as const;

  const diagnosis = {
    hypothesis:
      direction === "down"
        ? `Performance decline detected in ${snapshot.metric}.`
        : `Performance improvement detected in ${snapshot.metric}.`,
    confidence,
    rationale:
      confidence === "low"
        ? "Change is small; treat as directional until more data accumulates."
        : "Magnitude exceeds beta threshold for meaningful movement."
  } as const;

  const recommendation = {
    priority: direction === "down" ? 1 : 2,
    action:
      direction === "down"
        ? "Investigate channel-level drivers and landing-page quality, then run one focused test."
        : "Document the likely driver and scale cautiously while monitoring CAC/ROAS guardrails.",
    expectedImpact:
      direction === "down"
        ? "Reduce downside risk and recover efficiency."
        : "Sustain gains without over-scaling volatility."
  } as const;

  return { observation, diagnosis, recommendation };
}
