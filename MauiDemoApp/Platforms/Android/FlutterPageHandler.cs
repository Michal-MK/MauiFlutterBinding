using Microsoft.Maui.Handlers;
using Binding = Com.Maui.Binding.Binding;

namespace MauiDemoApp;

public class FlutterPageHandler(IPropertyMapper mapper, CommandMapper? commandMapper = null)
	: ViewHandler<FlutterPage, Android.Views.View>(mapper, commandMapper) {

	public static IPropertyMapper<FlutterPage, FlutterPageHandler> PropertyMapper = new PropertyMapper<FlutterPage, FlutterPageHandler>(ViewMapper);

	public FlutterPageHandler() : this(PropertyMapper) { }

	protected override Android.Views.View CreatePlatformView() {
		return new Binding().GetFlutterView(
			MainActivity.Instance,
			null,
			(float)(DeviceDisplay.MainDisplayInfo.Width / DeviceDisplay.MainDisplayInfo.Density),
			(float)(DeviceDisplay.MainDisplayInfo.Height / DeviceDisplay.MainDisplayInfo.Density)
		);
	}

	protected override void DisconnectHandler(Android.Views.View platformView) {
		platformView.Dispose();
		base.DisconnectHandler(platformView);
	}
}