using Microsoft.Maui.Handlers;
using Binding = Com.Maui.Binding.Binding;

namespace MauiDemoApp;

public class FlutterView : View;

public class FlutterViewHandler(IPropertyMapper mapper, CommandMapper? commandMapper = null)
	: ViewHandler<FlutterView, Android.Views.View>(mapper, commandMapper) {

	public static IPropertyMapper<FlutterView, FlutterViewHandler> PropertyMapper = new PropertyMapper<FlutterView, FlutterViewHandler>(ViewMapper);

	public FlutterViewHandler() : this(PropertyMapper, null) { }

	protected override Android.Views.View CreatePlatformView() {
		return new Binding().GetFlutterView(MainActivity.Instance);
	}

	protected override void DisconnectHandler(Android.Views.View platformView) {
		platformView.Dispose();
		base.DisconnectHandler(platformView);
	}
}