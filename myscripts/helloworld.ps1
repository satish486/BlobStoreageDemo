echo "helloworld"
$appdirectory=".\testfiles"
$webappname="testingwebapp10"
$location="Central US"

# Create a resource group.
#New-AzResourceGroup -Name myResourceGroup -Location $location

# Create an App Service plan in `Free` tier.
#New-AzAppServicePlan -Name $webappname -Location $location `
#-ResourceGroupName myResourceGroup -Tier Free

# Create a web app.
#New-AzWebApp -Name $webappname -Location $location -AppServicePlan $webappname `
#-ResourceGroupName myResourceGroup

# Get publishing profile for the web app
$xml = [xml](Get-AzWebAppPublishingProfile -Name $webappname -ResourceGroupName Development -OutputFile null)

# Extract connection information from publishing profile
$username = $xml.SelectNodes("//publishProfile[@publishMethod=`"FTP`"]/@userName").value
$password = $xml.SelectNodes("//publishProfile[@publishMethod=`"FTP`"]/@userPWD").value
$url = $xml.SelectNodes("//publishProfile[@publishMethod=`"FTP`"]/@publishUrl").value
echo "url is" $url
# Upload files recursively 
Set-Location $appdirectory
$webclient = New-Object -TypeName System.Net.WebClient
$webclient.Credentials = New-Object System.Net.NetworkCredential($username,$password)
$files = Get-ChildItem -Path $appdirectory -Recurse | Where-Object{!($_.PSIsContainer)}
echo "files are"+$files
echo "testing change"
foreach ($file in $files)
{
echo "inside the for loop"
    $relativepath = (Resolve-Path -Path $file.FullName -Relative).Replace(".\", "").Replace('\', '/')
	echo $relativepath
    $uri = New-Object System.Uri("$url/$relativepath")
    "Uploading to " + $uri.AbsoluteUri
    $webclient.UploadFile($uri, $file.FullName)
} 
$webclient.Dispose()

