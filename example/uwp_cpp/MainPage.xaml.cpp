//
// MainPage.xaml.cpp
// Implementation of the MainPage class.
//

#include "pch.h"
#include "MainPage.xaml.h"

using namespace uwp_cpp;
using namespace Platform;
using namespace Windows::Foundation;
using namespace Windows::Foundation::Collections;
using namespace Windows::UI::Xaml;
using namespace Windows::UI::Xaml::Controls;
using namespace Windows::UI::Xaml::Controls::Primitives;
using namespace Windows::UI::Xaml::Data;
using namespace Windows::UI::Xaml::Input;
using namespace Windows::UI::Xaml::Media;
using namespace Windows::UI::Xaml::Navigation;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=402352&clcid=0x409
const std::string minsub = "minimal_subscriber";

using std::placeholders::_1;
MinimalSubscriber::MinimalSubscriber()
        : Node(minsub)
    {
        subscription_ = this->create_subscription<std_msgs::msg::String>(
            "/chatter", 10, std::bind(&MinimalSubscriber::topic_callback, this, _1));
    }

void MinimalSubscriber ::topic_callback(const std_msgs::msg::String::SharedPtr msg) const
{
    OutputDebugStringA(msg->data.c_str());
    OutputDebugStringA("\n");
}

MainPage::MainPage()
{
	InitializeComponent();

}
