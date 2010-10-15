'*****************************************************************
'**  Home Media Server Application -- Home Screen
'**  November 2010
'**  Copyright (c) 2010 Brian C. Lane All Rights Reserved.
'*****************************************************************

'************************************************************
' ** Check the registry for the server URL
' ** Prompt the user to enter the URL or IP if it is not
' ** found and write it to the registry.
'************************************************************
Function checkServerUrl(forceEdit as Boolean) as Void
    serverURL = RegRead("ServerURL")
    if (serverURL = invalid) then
        print "ServerURL not found in the registry"
        serverURL = "video.local"
    else if !forceEdit then
        print "Server set to ";serverURL
        return
    endif

    screen = CreateObject("roKeyboardScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.SetTitle("Video Server URL")
    screen.SetText(serverURL)
    screen.SetDisplayText("Enter Host Name or IP Address")
    screen.SetMaxLength(25)
    screen.AddButton(1, "finished")
    screen.Show()

    while true
        msg = wait(0, screen.GetMessagePort())
        print "message received"
        if type(msg) = "roKeyboardScreenEvent"
            if msg.isScreenClosed()
                return
            else if msg.isButtonPressed() then
                print "Evt: ";msg.GetMessage();" idx:"; msg.GetIndex()
                if msg.GetIndex() = 1 then
                    searchText = screen.GetText()
                    print "search text: "; searchText
                    RegWrite("ServerURL", searchText)
                    return
                endif
            endif
        endif
    end while
End Function
