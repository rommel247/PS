$path = 'C:\enc_pass.txt'
#encrypt
'!@#$%66' | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Set-Content -Path $path

#decrypt
$secreto = Get-Content -Path $path | ConvertTo-SecureString
$var = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((($secreto))))
Write-Host $var