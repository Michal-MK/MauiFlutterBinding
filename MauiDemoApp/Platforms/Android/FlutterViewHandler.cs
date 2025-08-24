using Microsoft.Maui.Handlers;
using Binding = Com.Maui.Binding.Binding;
using View = Android.Views.View;

namespace MauiDemoApp;

public class FlutterViewHandler(IPropertyMapper mapper, CommandMapper? commandMapper = null)
	: ViewHandler<FlutterView, Android.Views.View>(mapper, commandMapper) {

	public static IPropertyMapper<FlutterView, FlutterViewHandler> PropertyMapper = new PropertyMapper<FlutterView, FlutterViewHandler>(ViewMapper);

	private Binding binding = new();

	public FlutterViewHandler() : this(PropertyMapper, null) { }

	protected override Android.Views.View CreatePlatformView() {
		return binding.GetFlutterView(MainActivity.Instance!, VirtualView.ViewType);
	}

	protected override void ConnectHandler(View platformView) {
		base.ConnectHandler(platformView);
		var size = binding.GetLastReportedSize(VirtualView.ViewType);
		if (size is not null) {
			var measure = VirtualView.Measure(size.Width, size.Height);
			VirtualView.Layout(new(0, 0, (int)measure.Width, (int)measure.Height));
		}

		Task.Run(async () => {
			while (true) {
				await Task.Delay(20);
				var newSize = binding.GetLastReportedSize(VirtualView.ViewType);

				
				if (newSize == size || newSize is null)
					continue;
				Android.Util.Log.Info("~LOG~", $"FlutterViewHandler: newSize={newSize?.Width}x{newSize?.Height}");

				var measure = VirtualView.Measure(size.Width, size.Height);
				VirtualView.Layout(new(0, 0, (int)measure.Width, (int)measure.Height));
			}
		});
	}

	protected override void DisconnectHandler(Android.Views.View platformView) {
		platformView.Dispose();
		base.DisconnectHandler(platformView);
	}
}