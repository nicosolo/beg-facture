FROM public.ecr.aws/nginx/nginx:stable-alpine-slim as base

# Development
FROM base as development
COPY nginx.dev.conf /etc/nginx/nginx.conf


EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


# Production
FROM base as production

COPY nginx.prod.conf /etc/nginx/nginx.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
