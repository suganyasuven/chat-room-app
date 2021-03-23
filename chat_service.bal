import ballerina/http;
import ballerina/log;
import ballerina/websocket;

map<websocket:Caller> connectionMap = {};
string userName = "";
# Simple chat application using web socket servive 
service /chat on new websocket:Listener(9090) {
    resource function get [string name](http:Request req) returns websocket:Service|websocket:UpgradeError {
        userName = name;
        return service object websocket:Service {
            remote function onOpen(websocket:Caller caller) {
                string msg = userName + " joined to the chat room";
                broadcast(msg);
                connectionMap[caller.getConnectionId()] = <@untainted>caller;
            }

            remote function onTextMessage(websocket:Caller caller, string text) {
                string msg = userName + " : " + text;
                broadcast(msg);
            }

            remote function onClose(websocket:Caller caller) {
                _ = connectionMap.remove(caller.getConnectionId());
                string msg = userName + " left the chat room";
                broadcast(msg);
            }
        };
    }
}

# Broadcasts the message to all conected with the chat room.
#
# + text - Message needs to be broadcasted  
function broadcast(string text) {
    foreach var con in connectionMap {
        var err = con->writeTextMessage(text);
        if (err is websocket:Error) {
            log:printError("Error sending message", 'error = err);
        }
    }
}
