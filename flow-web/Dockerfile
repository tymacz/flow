# Stage 1: Installation des dépendances
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --legacy-peer-deps || npm install

# Stage 2: Build de l'application Next.js
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED=1
ENV SKIP_ENV_VALIDATION=1
ENV NEXT_PUBLIC_API_URL=/api

ENV NEXTAUTH_SECRET="build_secret_placeholder_for_docker"
ENV NEXTAUTH_URL="http://localhost:3000"
ENV DATABASE_URL="postgresql://dummy:dummy@localhost:5432/dummy"

RUN npm run build

# Stage 3: Runner (Image finale de production)
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV AUTH_TRUST_HOST=true

# Variables indispensables au RUNTIME pour NextAuth et T3 Env
ENV NEXTAUTH_URL="http://localhost:3000"
ENV NEXTAUTH_SECRET="change_me_in_docker_compose_secret"

RUN addgroup --system --gid 1001 nodejs \
    && adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs
EXPOSE 3000
ENV PORT=3000

CMD ["node", "server.js"]
