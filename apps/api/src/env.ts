import { config } from 'dotenv';
import { z } from 'zod';

config();

const schema = z.object({
  PORT: z.coerce.number().default(4000),
  DATABASE_URL: z.string().url(),
  REDIS_URL: z.string().url(),
  JWT_SECRET: z.string().min(8),
});

export const env = schema.parse(process.env);
