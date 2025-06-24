FROM public.ecr.aws/nginx/nginx:stable-alpine-slim AS base

# Development
FROM base AS development
COPY nginx.dev.conf /etc/nginx/nginx.conf


EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


# Production
FROM base AS production

COPY nginx.prod.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
