/** @type {import('next').NextConfig} */
const nextConfig = {
  // Enable strict mode
  reactStrictMode: true,
  // Image optimization
  images: {
    domains: [],
  },
  // Environment variables
  env: {
    CUSTOM_KEY: process.env.CUSTOM_KEY,
  },
}

module.exports = nextConfig