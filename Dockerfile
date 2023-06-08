# as builder makes it where everything below this is part of builder phase in this multiple-step docker build
FROM node:16-alpine as builder
WORKDIR '/app'
COPY ./package.json .
RUN npm install
COPY . .
RUN npm run build


# this is the start of a new phase. docker can only have one from in each phase, so having a new from signifies new phase
FROM nginx
# this is for aws elastic bean stalk. expose wont help us when running locally, but AWS will use this to expose port 80
EXPOSE 80
# we are copying the build folder from the builder phase and then bringing it to the required director
# the /usr/share/nginx/html directory is specified to us in nginx image docs in hub.docker.com
COPY --from=builder /app/build /usr/share/nginx/html
# we dont have to do a run nginx command because that is already the default start up command for the nginx image
