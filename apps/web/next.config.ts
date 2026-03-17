import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  transpilePackages: ['@growth-signal/ui', '@growth-signal/types'],
};

export default nextConfig;
