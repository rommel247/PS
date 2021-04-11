
$searchinfolder ='\\SQLBACKUP_PATH\'
$Logfile_name = (get-date).AddDays(-1).ToString("yyyy_MM_dd")+"_sql_backup"
$Logfile = "c:\$Logfile_name.txt"
#$filetosearch = 'ZKTeco_backup_2020_12_11_000005_7716155.bak.zip' 
$parentdirectory = Get-ChildItem -Path $searchinfolder #-Filter '*2020_12_21*'
 LogWrite '#################################'
  Get-Date
 LogWrite 'Searching (9)backups file in 0.26...'
 LogWrite '#################################'
 LogWrite '     Found         | Not- Found'
 LogWrite '#################################'
 $counter = 0
foreach ($directory in $parentdirectory) 
{
    #search from this path
    $searchbackupfileinfolder = Get-ChildItem -Path $directory.FullName
    #get the date for yesterdays backup
   $dte = (get-date).AddDays(-1).ToString("yyyy_MM_dd")
   $today =$dte #-Format "yyyy_MM_dd"
   # echo $containWord
  
     if( $searchbackupfileinfolder -like "*"+$today.toString()+"*")
     {
       ## LogWrite 'SQL Database backup found:'  $directory.Name  
       $counter = $counter + 1
      LogWrite $directory.Name  
     echo $directory.Name
      
     }
     #else
     #{
    # LogWrite '                   |'+ $directory.Name  
     #}
}
LogWrite '#################################'
LogWrite $counter + " records found!"
LogWrite '#################################'

#function to create a log file on default path
Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

#function to send the attachment report via email
