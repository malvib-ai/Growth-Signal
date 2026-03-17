import { config } from 'dotenv';
import { Queue, Worker } from 'bullmq';
import IORedis from 'ioredis';
import { z } from 'zod';

config();

const env = z
  .object({
    REDIS_URL: z.string().url(),
  })
  .parse(process.env);

const connection = new IORedis(env.REDIS_URL, { maxRetriesPerRequest: null });

const queueName = 'growth-signal-jobs';
const queue = new Queue(queueName, { connection });

new Worker(
  queueName,
  async (job) => {
    console.log(`[worker] processing ${job.name}`, job.data);
    return { ok: true };
  },
  { connection },
);

const boot = async () => {
  await queue.add('bootstrap', { createdAt: new Date().toISOString() });
  console.log('[worker] ready');
};

boot().catch((error) => {
  console.error(error);
  process.exit(1);
});
