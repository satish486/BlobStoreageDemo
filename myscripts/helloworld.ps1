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

#foreach ($file in $files)
#{
echo "inside the for loop"
    $relativepath = "test2.html"
	echo $relativepath
    $uri = New-Object System.Uri("$url/$relativepath")
    echo "Uploading to " + $uri.AbsoluteUri
	echo "URI value is " $uri
	Write-Output $uri
    $webclient.UploadFile($uri, "testfiles/test2.html")
#} 
$webclient.Dispose()

