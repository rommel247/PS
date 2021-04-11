#Change the policy restrictions
#Set-ExecutionPolicy -ExecutionPolicy Unrestricted
#Invoke-Sqlcmd -Query "SELECT GETDATE() AS TimeOfQuery" -ServerInstance "192.168.0.85"
$server = "192.168.0.85"
$database = "applicationdb"
$user = "sa"
$secreto = Get-Content -Path C:\enc_pass.txt | ConvertTo-SecureString
$upassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((($secreto))))
$password = $upassword #this will use encrytion nexttime
$queue= Invoke-Sqlcmd -ServerInstance $server -Database $database -Query "SELECT * FROM Temp_DailyJobQueue where issent=0" -Username $user -Password $password

#******************** non-query block ************************
Function Execute-Procedure {
Param (
    [int] $id,
    [string] $sitecode,
    [int] $departmentid,
    [Datetime] $datefrom,
    [Datetime] $dateto,
    [Datetime] $replydate)

  $scon = New-Object System.Data.SqlClient.SqlConnection
  $scon.ConnectionString = "Data Source=$server;Initial Catalog=$database;User ID=$user;Password=$password"  
  $cmd = New-Object System.Data.SqlClient.SqlCommand
  $cmd.Connection = $scon
  $cmd.CommandTimeout = 0
  #constraints here is that time-out is still happening
  $querycmd =  "EXEC usp_TESTSendEmailAttendance @Type = N'AUTO', @SiteCode = N'$sitecode', @DepartmentID = $departmentid, @EmpCode = NULL, @DateFrom = '$datefrom', @DateTo = '$dateto', @IncludeSummary = 1, @ReplyBeforethisDate = '$replydate'" 
  $cmd.CommandText =$querycmd #"EXEC	FDusp_TESTSendEmailAttendance @Type = N'AUTO', @SiteCode = N'$sitecode', @DepartmentID = $departmentid, @EmpCode = NULL, @DateFrom = '$datefrom', @DateTo = '$dateto', @IncludeSummary = 1, @ReplyBeforethisDate = '$replydate'" 
  $updateQ = "Update Temp_DailyJobQueue set issent=1  where id=$id"
  try
  {
    $scon.Open()
    $cmd.ExecuteNonQuery()     
    $updatedqueue= Invoke-Sqlcmd -ServerInstance $server -Database $database -Query $updateQ -Username $user -Password $password
  }
 catch [Exception]
  {
    Write-Output "$(Get-Date) - $_ while running the  $querycmd and $updateQ"  | Out-File C:\sql-queuer-runner-errorlog.txt -Append
    Write-Warning $_.Exception.Message

  }
 finally
 {
   $scon.Dispose()
   $cmd.Dispose()
 }

}
#******************** non-query block end ************************ 

foreach ($job in $queue)
{
 Execute-Procedure -id $job.id -sitecode $job.sitecode -departmentid $job.departmentid -datefrom $job.datefrom -dateto $job.dateto $job.replytodate
}



