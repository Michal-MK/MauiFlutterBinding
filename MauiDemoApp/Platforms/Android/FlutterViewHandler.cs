using Android.Views;
using Microsoft.Maui.Handlers;
using Binding = Com.Maui.Binding.Binding;
using BindingSize = Com.Maui.Binding.Size;
using View = Android.Views.View;

namespace MauiDemoApp;

public class FlutterViewHandler(IPropertyMapper mapper, CommandMapper? commandMapper = null)
	: ViewHandler<FlutterView, View>(mapper, commandMapper) {

	public static IPropertyMapper<FlutterView, FlutterViewHandler> PropertyMapper = new PropertyMapper<FlutterView, FlutterViewHandler>(ViewMapper);

	private Binding binding = new();
	private View? flutterView;

	public FlutterViewHandler() : this(PropertyMapper) { }

	protected override View CreatePlatformView() {
		flutterView = binding.GetFlutterView(
			MainActivity.Instance!,
			VirtualView.ViewType,
			(float)(DeviceDisplay.MainDisplayInfo.Width / DeviceDisplay.MainDisplayInfo.Density),
			VirtualView.HeightExpectancy + 100
		);
		StartSizeMonitoring();

		return flutterView;
	}

	private void StartSizeMonitoring() {
		Task.Run(async () => {
			BindingSize? lastSize = null;

			while (flutterView != null) {
				await Task.Delay(20);
				var newSize = binding.GetLastReportedSize(VirtualView.ViewType);

				if (newSize != lastSize && newSize != null) {
					lastSize = newSize;
					Android.Util.Log.Info("~LOG~", $"FlutterViewHandler: Flutter reported new size {newSize.Width}x{newSize.Height}");

					MainThread.BeginInvokeOnMainThread(() => { VirtualView.HeightRequest = newSize.Height + 50; });
				}
			}
		});
	}

	protected override void DisconnectHandler(View platformView) {
		platformView.Dispose();
		flutterView = null;
		base.DisconnectHandler(platformView);
	}
}