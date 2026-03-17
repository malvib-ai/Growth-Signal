export interface Healthcheck {
  service: 'api' | 'worker' | 'web';
  status: 'ok';
  timestamp: string;
}

export const healthcheck = (service: Healthcheck['service']): Healthcheck => ({
  service,
  status: 'ok',
  timestamp: new Date().toISOString(),
});
