$Username = "abc@company.com.sa";
$Password = "abc123";
$Logfile_name = (get-date).AddDays(-1).ToString("yyyy_MM_dd")+"_sql_backup"
$Logfile = "c:\sql_logs\$Logfile_name.txt"
$path = $Logfile
$searchinfolder ='\\192.168.0.242\sql-backups\'

#function to send report via email.
function Send-ToEmail([string]$email, [string]$attachmentpath){

    $message = new-object Net.Mail.MailMessage;
    $message.From = "abc@company.com.sa";
    $message.To.Add($email);
    
    $message.Subject = $Logfile_name;
    $message.Body = "Hey, These are the SQL backups on 192.168.0.242 for yesterday ("+$Logfile_name+ ")`r`n";
    $parentdirectory = Get-ChildItem -Path $searchinfolder #-Filter '*2020_12_21*'
     $counter = 0
    foreach ($directory in $parentdirectory) 
    {
    $searchbackupfileinfolder = Get-ChildItem -Path $directory.FullName    
    $dte = (get-date).AddDays(-1).ToString("yyyy_MM_dd")
    $today =$dte #-Format "yyyy_MM_dd"
  
     if( $searchbackupfileinfolder -like "*"+$today.toString()+"*")
     {
      $counter+=1
     $message.Body +="`r`n"+$counter+". "+$directory.Name+".bak" 
     echo $directory.Name
     }
    }
    $message.Body += "`r`n`r`nThis is system generated email built on powershell script.`r`n This auto-notification runs every x.`r`n To unsubscribe send me a feedback.";
    $attachment = New-Object Net.Mail.Attachment($attachmentpath);
    $message.Attachments.Add($attachment);

    $smtp = new-object Net.Mail.SmtpClient("smtp.office365.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
    write-host "Mail Sent |V|" ; 
    #make logger here
    $attachment.Dispose();
 }
Send-ToEmail  -email "recipient@gmail.com" -attachmentpath $path;