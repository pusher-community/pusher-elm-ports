# Pusher and Elm

This is an Elm application that connects with Pusher. The Elm app makes HTTP POST requests to a [Sinatra server](https://github.com/pusher-community/sinatra-realtime-server) which triggers Pusher messages. Using PusherJS, these messages are then passed back into the Elm app through the use of ports.
