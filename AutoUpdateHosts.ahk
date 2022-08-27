if (!A_IsAdmin)
    Run *RunAs %A_ScriptFullPath%
FileEncoding UTF-8-RAW


HostPath:="C:/windows/system32/drivers/etc/hosts"
FileRead HostFile,%HostPath%
RegExMatch(HostFile,"# Update at: (.+)\R",LocalVer)
SetTimer HostUpdate,3600000 ;Check interval
return

HostUpdate:
GitHost:=WinHttp("https://raw.hellogithub.com/hosts")
RegExMatch(GitHost,"# Update time: (.+)\R",RemoteVer)
if (RemoteVer!="" && RemoteVer!=LocalVer)
{
    LocalVer:=RemoteVer
    FileDelete %HostPath%
    FileRead MyHost,MyHost.txt
    MyHost.=GitHost
    FileAppend %MyHost%,%HostPath%
    Run %ComSpec% /c "ipconfig /flushdns",,Hide
}
return


#NoEnv
#Persistent
#SingleInstance Force
WinHttp(url,method:="GET",data:="")
{
    try
    {
        whr:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
        whr.Open(method,url,true)
        whr.Send(data)
        whr.WaitForResponse()
        return whr.ResponseText
    }
    catch
    {
        Reload
    }
}