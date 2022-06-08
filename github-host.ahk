if (!A_IsAdmin)
	Run *RunAs %A_ScriptFullPath%

FileEncoding UTF-8-RAW


HostPath:="C:/windows/system32/drivers/etc/hosts"
FileRead HostFile,%HostPath%
RegExMatch(HostFile,"# Update at: (.+)\R",LocalVer)
SetTimer HostUpdate,3600000 ;Check interval
return

HostUpdate:
GitHost:=WinHttp("https://gitee.com/isevenluo/github-hosts/raw/master/hosts")
RegExMatch(GitHost,"# Update at: (.+)\R",RemoteVer)
if (LocalVer!=RemoteVer)
{
    FileDelete %HostPath%
    MyHost:="#Your hosts`n`n" GitHost ;Input here
    FileAppend %MyHost%,%HostPath%
    Run %ComSpec% /c "ipconfig /flushdns",,Hide
    LocalVer:=RemoteVer
}
return


#NoEnv
#Persistent
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
