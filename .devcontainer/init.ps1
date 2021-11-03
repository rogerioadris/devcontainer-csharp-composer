#requires -PSEdition Core
# Additional steps to initialize the development container

# Install sqlserver module so we can use 'Invoke-Sqlcmd'
Install-Module sqlserver -Confirm:$False  -Force

# Create new database
# Source for the retry logic:
# https://stackoverflow.com/a/47712807/411428
$attempts=20
$sleepInSeconds=5
$password=[System.Environment]::GetEnvironmentVariable('SA_PASSWORD')
$database=[System.Environment]::GetEnvironmentVariable('SQL_DATABASE')
do
{
    try
    {
        Invoke-Sqlcmd -ServerInstance "database,1433" -Username SA -Password $password -Query "CREATE DATABASE [$database]";
        Write-Host "Database $database created successfully."
        break;
    }
    catch [Exception]
    {
        Write-Host $_.Exception.Message
        Write-Host "Retrying..."
    }
    $attempts--
    if ($attempts -gt 0) { Start-Sleep $sleepInSeconds }
} while ($attempts -gt 0)