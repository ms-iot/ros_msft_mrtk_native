//
// MainPage.xaml.h
// Declaration of the MainPage class.
//

#pragma once

#include "MainPage.g.h"
#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"

namespace uwp_cpp
{

	class MinimalSubscriber : public rclcpp::Node
	{
		rclcpp::Subscription<std_msgs::msg::String>::SharedPtr subscription_;
		void topic_callback(const std_msgs::msg::String::SharedPtr msg) const;

	public:
		MinimalSubscriber();


	};


	/// <summary>
	/// An empty page that can be used on its own or navigated to within a Frame.
	/// </summary>
	public ref class MainPage sealed
	{
		std::shared_ptr<MinimalSubscriber> _minSubscriber;

	public:
		MainPage();

	};
}
