import ballerina/test;
import ballerina/websocket;

@test:Config {}
function testChatService() returns error? {
    websocket:Client wsClient1 = check new ("ws://localhost:9090/chat/john");
    check wsClient1->writeTextMessage("Hai James");
    string textResp = check wsClient1->readTextMessage();
    test:assertEquals(textResp, "john : Hai James");

    websocket:Client wsClient2 = check new ("ws://localhost:9090/chat/james");
    check wsClient2->writeTextMessage("Hai John");
    textResp = check wsClient2->readTextMessage();
    test:assertEquals(textResp, "james : Hai John");
}
