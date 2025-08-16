using CoreGraphics;
using Microsoft.Maui.Handlers;
using UIKit;

namespace MauiDemoApp;

public class FlutterHandlerView : View;

public class FlutterViewHandler(IPropertyMapper mapper, CommandMapper? commandMapper = null)
	: ViewHandler<FlutterView, UIView>(mapper, commandMapper) {

	public FlutterViewHandler() : this(PropertyMapper, null) { }
	
	public static IPropertyMapper<FlutterView, FlutterViewHandler> PropertyMapper = new PropertyMapper<FlutterView, FlutterViewHandler>(ViewMapper);

	protected override UIView CreatePlatformView() {
		return new iOS.Binding.Binding().FlutterViewController.View!;
	}

	public override Size GetDesiredSize(double widthConstraint, double heightConstraint) {
		CGSize sizeThatFits = PlatformView.SizeThatFits(new Size(widthConstraint, heightConstraint));
		return new Size(sizeThatFits.Width, sizeThatFits.Height);
	}

	protected override void DisconnectHandler(UIView platformView) {
		platformView.Dispose();
		base.DisconnectHandler(platformView);
	}
}