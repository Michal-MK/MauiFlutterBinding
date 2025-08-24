using CoreFoundation;
using Microsoft.Maui.Controls.Compatibility.Platform.iOS;
using Microsoft.Maui.Controls.Handlers.Compatibility;
using Microsoft.Maui.Handlers;
using UIKit;
using ContentView = Microsoft.Maui.Platform.ContentView;

namespace MauiDemoApp;
public class FlutterPageHandler : PageHandler {

	protected override ContentView CreatePlatformView() {
		var binding = new iOS.Binding.Binding();
		var flutterViewController = binding.FlutterViewController;
		
		// Create a container view to host the Flutter view controller
		var containerView = new ContentView();
		
		// Add the Flutter view controller as a child view controller
		if (ViewController != null && flutterViewController?.View != null)
		{
			ViewController.AddChildViewController(flutterViewController);
			containerView.AddSubview(flutterViewController.View);
			flutterViewController.DidMoveToParentViewController(ViewController);
			
			// Set up constraints to fill the container
			flutterViewController.View.TranslatesAutoresizingMaskIntoConstraints = false;
			NSLayoutConstraint.ActivateConstraints(new[]
			{
				flutterViewController.View.TopAnchor.ConstraintEqualTo(containerView.TopAnchor),
				flutterViewController.View.BottomAnchor.ConstraintEqualTo(containerView.BottomAnchor),
				flutterViewController.View.LeadingAnchor.ConstraintEqualTo(containerView.LeadingAnchor),
				flutterViewController.View.TrailingAnchor.ConstraintEqualTo(containerView.TrailingAnchor)
			});
		}
		
		return containerView;
	}
}