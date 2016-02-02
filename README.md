# Pusher and Elm

This is an Elm application that connects with Pusher. The Elm app makes HTTP POST requests to a [Sinatra server](https://github.com/pusher-community/sinatra-realtime-server) which triggers Pusher messages. Using PusherJS, these messages are then passed back into the Elm app through the use of ports.

To find out more, [read the blog post!](https://blog.pusher.com/making-elm-lang-realtime-with-pusherjs/).

# Running locally

- `git clone` the repo
- `npm install`
- `gulp start` in one terminal tab
- `gulp serve` in another to serve the app locally
