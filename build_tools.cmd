: @echo off
cd tools
call .\build /x64
call .\build /arm64
call .\build /unity
