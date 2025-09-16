
# Development
FROM public.ecr.aws/nginx/nginx:stable-alpine-slim AS development
COPY nginx.dev.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]