FROM jekyll/builder:latest AS builder
WORKDIR /srv/jekyll
COPY /src/Gemfile* ./
RUN bundle config set --local deployment 'true' \
    && bundle install
COPY ./src .
RUN jekyll build

FROM nginx:alpine
COPY --from=builder /srv/jekyll/_site /usr/share/nginx/html
COPY --from=builder /srv/jekyll/_static/cv.pdf /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]