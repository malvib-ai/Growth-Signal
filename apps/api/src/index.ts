import Fastify from 'fastify';
import { env } from './env.js';
import { healthcheck } from '@growth-signal/types';

const app = Fastify({ logger: true });

app.get('/health', async () => healthcheck('api'));

const start = async () => {
  await app.listen({ host: '0.0.0.0', port: env.PORT });
};

start().catch((error) => {
  app.log.error(error);
  process.exit(1);
});
