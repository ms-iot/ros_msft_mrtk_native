$filespecs = @(
    "..\target\@@sourcearch@@\Lib\builtin_interfaces\dotnet\builtin_interfaces_assemblies.*"
    "..\target\@@sourcearch@@\Lib\rcldotnet\dotnet\System.*"
    "..\target\@@sourcearch@@\Lib\rcldotnet\dotnet\rcldotnet_assemblies.*"
    "..\target\@@sourcearch@@\Lib\rcldotnet_common\dotnet\rcldotnet_common.*"
    "..\target\@@sourcearch@@\Lib\rclcppdotnet\dotnet\rclcppdotnet_assemblies.*"
    "..\target\@@sourcearch@@\Lib\rcl_interfaces\dotnet\rcl_interfaces_assemblies.*"
    "..\target\@@sourcearch@@\lib\actionlib_msgs\dotnet\actionlib_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\actionlib_msgs\dotnet\std_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\action_msgs\dotnet\action_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\diagnostic_msgs\dotnet\diagnostic_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\geometry_msgs\dotnet\geometry_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\lifecycle_msgs\dotnet\lifecycle_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\nav_msgs\dotnet\nav_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\rosgraph_msgs\dotnet\rosgraph_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\sensor_msgs\dotnet\sensor_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\shape_msgs\dotnet\shape_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\stereo_msgs\dotnet\stereo_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\test_msgs\dotnet\test_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\tf2_msgs\dotnet\tf2_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\trajectory_msgs\dotnet\trajectory_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\unique_identifier_msgs\dotnet\unique_identifier_msgs_assemblies.*"
    "..\target\@@sourcearch@@\lib\visualization_msgs\dotnet\visualization_msgs_assemblies.*"

    "..\target\@@sourcearch@@\bin\*.dll"
    "..\tools\@@sourcearch@@\bin\*.dll"
    "C:\opt\vcpkg\installed\@@arch@@-@@platform@@\bin\*.dll"
    "%VCToolsRedistDir%\onecore\@@arch@@\Microsoft.VC142.CRT\vcruntime140.dll"
    "%VCToolsRedistDir%\onecore\@@arch@@\Microsoft.VC142.CRT\vcruntime140_1.dll"
    "%VCToolsRedistDir%\onecore\@@arch@@\Microsoft.VC142.CRT\msvcp140.dll"
    "%VCToolsRedistDir%\onecore\@@arch@@\Microsoft.VC142.CRT\msvcp140.dll"
)



function createMeta
{
    param 
    (
        $forFile,
        $template
    )

    $guidRaw = New-Guid
    $guid = $guidRaw.ToString().Replace("-", "")
    $newMetafilename = $forFile + ".meta"

    Write-Host "Generating $newMetafilename"

    $newMetafile = $template.Replace("@@newGuid@@", $guid)
    Set-Content $newMetafilename $newMetafile

}

function populateArchAndPlat
{
    param 
    (
        $arch,
        $sourceArch,
        $templateName,
        $platform
    )

    $vcredist = [System.Environment]::GetEnvironmentVariable('VCToolsRedistDir')

    $template = Get-Content $templateName -Raw
    $templateFolder = Get-Content "folder_meta.txt" -Raw

    $extSpecs = @("*.dll", "*.pdb")

    $currentDir = Get-Location
    $buildDir = Join-Path -Path $currentDir -ChildPath "com.microsoft.ros_mrtk_native\Plugins"
    New-Item -ItemType Directory -Force -Path $buildDir

    createMeta -forFile $buildDir -template $templateFolder

    $platDir = "$platform-$arch"
    $archDir = Join-Path -Path $buildDir -ChildPath $platDir
    New-Item -ItemType Directory -Force -Path $archDir
    createMeta -forFile $archDir -template $templateFolder

    foreach ($filespec in $filespecs)
    {
        $filespec = $filespec.Replace("@@sourcearch@@", $sourceArch)
        $filespec = $filespec.Replace("@@arch@@", $arch)
        $filespec = $filespec.Replace("@@platform@@", $platform)
        $filespec = $filespec.Replace("%VCToolsRedistDir%", $vcredist)

        foreach ($extSpec in $extSpecs)
        {
            $files = Get-Item $filespec -Filter $extSpec

            foreach ($file in $files)
            {
                $filename = Split-Path $file -leaf
                $destination = Join-Path -Path $archDir -ChildPath $filename

                # Copy-Item -Path 
                Write-Host "Copy $file to $destination"
                Copy-Item $file -Destination $destination

                createMeta -forFile $destination -template $template
            }
        }
    }
}

function populate
{
    populateArchAndPlat -arch "x64" -platform "Windows" -sourceArch "Unity" -templateName 'x86_64_meta.txt'
    #populateArchAndPlat -arch "x64" -platform "uwp" -sourceArch "x64" -templateName 'wsa_x64_meta.txt'
    #populateArchAndPlat -arch "x86" -platform "uwp" -sourceArch "x86" -templateName 'wsa_x86_meta.txt'
    populateArchAndPlat -arch "arm64" -platform "uwp"  -sourceArch "arm64"  -templateName 'wsa_arm64_meta.txt'
}

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

populate

<#
GenerateUnityMeta -templateName 'wsa_arm64_meta.txt' -folder "..\target\arm64"
GenerateUnityMeta -templateName 'wsa_x64_meta.txt' -folder "..\target\x64"
GenerateUnityMeta -templateName 'x86_64_meta.txt' -folder "..\target\x86"

GenerateUnityMeta -templateName 'wsa_arm64_meta.txt' -folder "C:\opt\vcpkg\installed\arm64-uwp\bin"
GenerateUnityMeta -templateName 'wsa_x64_meta.txt' -folder "C:\opt\vcpkg\installed\x64-uwp\bin"
GenerateUnityMeta -templateName 'x86_64_meta.txt' -folder "C:\opt\vcpkg\installed\x86-windows\bin"

GenerateUnityMeta -templateName 'wsa_arm64_meta.txt' -folder "C:\opt\vcpkg\buildtrees\apriltag\arm64-uwp-rel\Release"
GenerateUnityMeta -templateName 'wsa_x64_meta.txt' -folder "C:\opt\vcpkg\buildtrees\apriltag\x64-uwp-rel\Release"
GenerateUnityMeta -templateName 'x86_64_meta.txt' -folder "C:\opt\vcpkg\buildtrees\apriltag\x86-windows-rel\Release"
#>