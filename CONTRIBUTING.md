
# Debugging on Hololens
Please read the discussion on [Microsoft's MR & Unity Debugging site](https://docs.microsoft.com/en-us/windows/mixed-reality/develop/unity/managed-debugging-with-unity-il2cpp).
## Capabilities
To ensure that you can debug a C# application running on the Hololens, you need to select `Internet (Client &Server)` and `Private Networks (Client & Server)` in the appxmanifest of the application - not just in Unity.

## Firewall
If you are unable to attach the unity debugger to the application running on the hololens, you may need to adjust your firewall settings.

From your Start Menu, select `Windows Defender Firewall with Advanced Security`, select `inbound rules`, and ensure that the Microsoft Visual Studio rules are enabled.


# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.