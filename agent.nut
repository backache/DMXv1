// Log the URLs to turn LED on/off when agent starts
server.log("Change the DMX channel value by browsing to " + http.agenturl() + "?ch=1&val=255");

// HTTP Request handlers expect two parameters:
// request: the incoming request
// response: the response we send back to whoever made the request
function requestHandler(request, response) {
  // Check if the variable led was passed into the query
  if ("favcolor" in request.query) {
    // if it was, send the value of it to the device
    server.log("Colour is " + request.query["favcolor"]);
    device.send("favcolor", request.query["favcolor"]);
  }
  // send a response back to whoever made the request
  response.send(200, "OK"+request.query["favcolor"]+"OK");
}
 
// your agent code should only ever have ONE http.onrequest call.
http.onrequest(requestHandler);