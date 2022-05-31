: @echo off
pushd tools
call ..\build /x64
call ..\build /arm64
call ..\build /unity
popd