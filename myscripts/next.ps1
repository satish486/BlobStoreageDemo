$downloadfolder = 'c:\temp\myAzureStorage'
 
$uploadfrom = "$downloadfolder\Content"
 
$files = get-childitem -Recurse "$downloadfolder\Content"
 
foreach($file in $files)
{
if($file -is [System.IO.DirectoryInfo])
{
$kudufolder = ((($file.FullName).Replace($uploadfrom,'Content')).replace('\','/')).trimstart('/')
$kudufolder = "$kudufolder/"
Upload-FileToWebApp -resourceGroupName myresourcegroup -webAppName mywebapp -kuduPath $kudufolder
}
elseif($file -is [System.IO.FileInfo])
{
$kudufile = ((($file.FullName).Replace($uploadfrom,'Content')).replace('\','/')).trimstart('/')
Upload-FileToWebApp -resourceGroupName myresourcegroup -webAppName mywebapp -localPath $file.FullName -kuduPath $kudufile
}
}