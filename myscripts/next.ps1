$downloadfolder = 'c:\temp\myAzureStorage'
 
$uploadfrom = "$downloadfolder\Content"
 
$files = get-childitem -Recurse "$downloadfolder\Content"
 
foreach($file in $files)
{
if($file -is [System.IO.DirectoryInfo])
{
$kudufolder = ((($file.FullName).Replace($uploadfrom,'Content')).replace('\','/')).trimstart('/')
$kudufolder = "$kudufolder/"
Upload-FileToWebApp -resourceGroupName Development -webAppName testingwebapp10 -kuduPath $kudufolder
}
elseif($file -is [System.IO.FileInfo])
{
$kudufile = ((($file.FullName).Replace($uploadfrom,'Content')).replace('\','/')).trimstart('/')
Upload-FileToWebApp -resourceGroupName Development -webAppName testingwebapp10 -localPath $file.FullName -kuduPath $kudufile
}
}