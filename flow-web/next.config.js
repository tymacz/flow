/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "standalone",
  typescript: {
    ignoreBuildErrors: true,
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  async rewrites() {
    return {
      // fallback s'exécute uniquement si Next.js ne trouve pas la route en interne
      fallback: [
        {
          source: "/api/:path*",
          destination: "http://cesizen_backend:8000/api/:path*",
        },
      ],
    };
  },
};

export default nextConfig;
