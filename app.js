var myApp = Elm.fullscreen(Elm.PusherApp, {
  newMessage: ''
});

var pusher = new Pusher('84cb48dd85934503cdaf');

var channel = pusher.subscribe('messages');

channel.bind('new_message', function(data) {
  myApp.ports.newMessage.send(data.text);
});
