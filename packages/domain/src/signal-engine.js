/** @import {MetricSnapshot, SignalResult} from './types.js' */

function deltaPercent(currentValue, previousValue) {
  if (previousValue === 0) {
    return currentValue === 0 ? 0 : 100;
  }

  return ((currentValue - previousValue) / Math.abs(previousValue)) * 100;
}

/**
 * @param {MetricSnapshot} snapshot
 * @returns {SignalResult}
 */
export function generateSignal(snapshot) {
  const delta = deltaPercent(snapshot.currentValue, snapshot.previousValue);
  const direction = delta >= 0 ? "up" : "down";
  const absDelta = Math.abs(delta);

  const confidence = absDelta >= 30 ? "high" : absDelta >= 12 ? "medium" : "low";

  const observation = {
    summary: `${snapshot.connector} ${snapshot.metric} is ${direction} ${absDelta.toFixed(1)}% ${snapshot.periodLabel}-over-${snapshot.periodLabel}.`,
    deltaPercent: Number(delta.toFixed(2))
  };

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
  };

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
  };

  return { observation, diagnosis, recommendation };
}
