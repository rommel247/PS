$Username = "employee@company.com";
$Password = "123456789";
#$path = "C:\txtfile.txt";
$Logfile_name = (get-date).AddDays(-1).ToString("yyyy_MM_dd")+"_sql_backup"
$Logfile = "c:\$Logfile_name.txt"
$path = $Logfile
function Send-ToEmail([string]$email, [string]$attachmentpath){

    $message = new-object Net.Mail.MailMessage;
    $message.From = "employee@company.com";
    $message.To.Add($email);
    $message.Subject = $Logfile_name;
    $message.Body = "Hey got the attached report of your SQL backups.";
    $attachment = New-Object Net.Mail.Attachment($attachmentpath);
    $message.Attachments.Add($attachment);

    $smtp = new-object Net.Mail.SmtpClient("smtp.office365.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
    write-host "Mail Sent" ; 
    #make logger here
    $attachment.Dispose();
 }
Send-ToEmail  -email "myemail@gmail.com" -attachmentpath $path;