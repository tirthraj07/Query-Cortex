/** @type {import('next').NextConfig} */
const nextConfig = {
    images: {
        remotePatterns: [
          {
            protocol: "http",
            hostname: "**", // Allow all hostnames
          },
          {
            protocol: "https",
            hostname: "**", // Allow all hostnames for HTTPS
          },
        ],
      },
      reactStrictMode:false,
};

export default nextConfig;
