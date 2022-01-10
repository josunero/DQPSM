Function Install-Software()
{
    
    Param

    (
        [Parameter(Mandatory = $false)] [string] $ServiceName,
        [Parameter(Mandatory = $false)] [string] $64Bit_Installer,
        [Parameter(Mandatory = $false)] [string] $32Bit_Installer,
        [Parameter(Mandatory = $false)] [string] $ArgumentList

    )

    try 
       {
                   




    if ((Get-Service -Name $ServiceName -erroraction 'silentlycontinue').Status -eq 'Running')

        {
         Write-Error -Message "The installation procedure is aborted. The software package is already installed and running." -ErrorAction Stop

        }

    else

        {



    if ((Get-WmiObject win32_operatingsystem | select osarchitecture).osarchitecture -eq "64-bit")
         {
         #64bit here
         Invoke-Expression  ('.\'+$64Bit_Installer + ' ' + $ArgumentList)
        
         }
    else
         {
         #32bit here
         Invoke-Expression  ('.\'+$32Bit_Installer  + ' ' + $ArgumentList)
         }

         #15 seconds break
         Start-Sleep -s 30

         
         #--- Check if the software installed properly.
         #Code Here
         #START--- Check if the software installed properly.
         
         if ((Get-Service -Name $ServiceName -erroraction 'silentlycontinue').Status -eq 'Running')
         {

         Write-Host "The software package installed successfully."
         }
         else
         {
         Write-Error -Message "The software package failed to install." -ErrorAction Stop

         #Call remediate function here.


         }

         #END--- Check if the software installed properly.






         }
         }
         

        
        catch
        {
            
             Write-Host $_.Exception.Message -BackgroundColor Red
        }
    
}




# TO DO
# Check Powershell compatibility
# Check if all required ports are open - Done
#



#Test function
Set-Location "C:\Users\jorben.osunero\OneDrive - Dynamic Quest, Inc\Desktop\DATTO RMM Migration"

$SetupParam = '/q /norestart UI=false SITE_TOKEN=eyJ1cmwiOiAiaHR0cHM6Ly91c2VhMS1wYXg4LnNlbnRpbmVsb25lLm5ldCIsICJzaXRlX2tleSI6ICJiNWQ5ODI0MGJiZTc1M2IwIn0='

$ServiceName = "SentinelAgent"
$64Bit_Installer = "SentinelInstaller_windows_64bit_v21_7_4_1043.msi"
$32Bit_Installer = "SentinelInstaller_windows_32bit_v21_7_4_1043.msi"
$ArgumentList = $SetupParam


Install-Software $ServiceName $64Bit_Installer $32Bit_Installer $SwitchParameter
