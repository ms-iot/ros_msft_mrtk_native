

function GenerateUnityMeta 
{

    param 
    (
        $templateName,
        $folder
    )

    $template = Get-Content $templateName -Raw

    $files = Get-ChildItem -Filter "*.dll" -Recurse $folder
    
    foreach ($file in $files)
    {
        $ext = [IO.Path]::GetExtension($file)
        if ($ext -notmatch ".meta")
        {
            $guidRaw = New-Guid
            $guid = $guidRaw.ToString().Replace("-", "")
            $newMetafilename = $file.FullName + ".meta"
    
            Write-Host "Generating $newMetafilename"
    
            $newMetafile = $template.Replace("@@newGuid@@", $guid)
            Set-Content $newMetafilename $newMetafile
        }
    }
}

GenerateUnityMeta -templateName 'wsa_arm64_meta.txt' -folder "..\target\arm64"
GenerateUnityMeta -templateName 'wsa_x64_meta.txt' -folder "..\target\x64"
GenerateUnityMeta -templateName 'x86_64_meta.txt' -folder "..\target\x86"

GenerateUnityMeta -templateName 'wsa_arm64_meta.txt' -folder "C:\opt\vcpkg\installed\arm64-uwp\bin"
GenerateUnityMeta -templateName 'wsa_x64_meta.txt' -folder "C:\opt\vcpkg\installed\x64-uwp\bin"
GenerateUnityMeta -templateName 'x86_64_meta.txt' -folder "C:\opt\vcpkg\installed\x86-windows\bin"

GenerateUnityMeta -templateName 'wsa_arm64_meta.txt' -folder "C:\opt\vcpkg\buildtrees\apriltag\arm64-uwp-rel\Release"
GenerateUnityMeta -templateName 'wsa_x64_meta.txt' -folder "C:\opt\vcpkg\buildtrees\apriltag\x64-uwp-rel\Release"
GenerateUnityMeta -templateName 'x86_64_meta.txt' -folder "C:\opt\vcpkg\buildtrees\apriltag\x86-windows-rel\Release"
