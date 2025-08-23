using CoreFoundation;
using Microsoft.Maui.Handlers;
using UIKit;

namespace MauiDemoApp;

public class FlutterViewWrapper : UIView {
	private readonly UIViewController flutterViewController;
	private bool isViewControllerAdded;

	public FlutterViewWrapper(UIViewController flutterViewController) {
		this.flutterViewController = flutterViewController;
		AddSubview(this.flutterViewController.View!);

		// Ensure the Flutter view fills the wrapper view
		this.flutterViewController.View!.TranslatesAutoresizingMaskIntoConstraints = false;
		NSLayoutConstraint.ActivateConstraints([
			this.flutterViewController.View.TopAnchor.ConstraintEqualTo(TopAnchor),
			this.flutterViewController.View.BottomAnchor.ConstraintEqualTo(BottomAnchor),
			this.flutterViewController.View.LeadingAnchor.ConstraintEqualTo(LeadingAnchor),
			this.flutterViewController.View.TrailingAnchor.ConstraintEqualTo(TrailingAnchor)
		]);
	}

	public override void MovedToSuperview() {
		base.MovedToSuperview();

		if (isViewControllerAdded) return;
		
		// Use a delayed approach to ensure the view hierarchy is fully established
		DispatchQueue.MainQueue.DispatchAsync(() => {
			var parentViewController = GetParentViewController();
			if (parentViewController != null && !isViewControllerAdded) {
				parentViewController.AddChildViewController(flutterViewController);
				flutterViewController.DidMoveToParentViewController(parentViewController);
				isViewControllerAdded = true;
				CoreFoundation.OSLog.Default.Log("~LOG~ Successfully added Flutter view controller to parent");
			} else {
				CoreFoundation.OSLog.Default.Log("~LOG~ Failed to find parent view controller");
			}
		});
	}

	public override void RemoveFromSuperview() {
		if (isViewControllerAdded) {
			flutterViewController.WillMoveToParentViewController(null);
			flutterViewController.RemoveFromParentViewController();
			isViewControllerAdded = false;
		}

		base.RemoveFromSuperview();
	}

	private UIViewController? GetParentViewController() {
		CoreFoundation.OSLog.Default.Log("~LOG~ GetParentViewController called");
		
		// Start from the superview instead of NextResponder
		UIView? currentView = Superview;
		while (currentView != null) {
			CoreFoundation.OSLog.Default.Log("~LOG~ Checking view: " + currentView.GetType().Name);
			
			// Check if this view belongs to a view controller
			UIResponder? responder = currentView.NextResponder;
			if (responder is UIViewController viewController) {
				CoreFoundation.OSLog.Default.Log("~LOG~ Found UIViewController: " + viewController.GetType().Name);
				return viewController;
			}
			
			currentView = currentView.Superview;
		}
		
		// Fallback: try the traditional responder chain approach
		UIResponder? currentResponder = NextResponder;
		while (currentResponder != null) {
			if (currentResponder is UIViewController viewController) {
				CoreFoundation.OSLog.Default.Log("~LOG~ Found UIViewController via responder chain: " + viewController.GetType().Name);
				return viewController;
			}
			currentResponder = currentResponder.NextResponder;
		}
		
		CoreFoundation.OSLog.Default.Log("~LOG~ No parent view controller found");
		return null;
	}

	protected override void Dispose(bool disposing) {
		if (disposing && isViewControllerAdded) {
			flutterViewController.WillMoveToParentViewController(null);
			flutterViewController.RemoveFromParentViewController();
		}
		base.Dispose(disposing);
	}
}

public class FlutterViewHandler(IPropertyMapper mapper, CommandMapper? commandMapper = null)
	: ViewHandler<FlutterView, UIView>(mapper, commandMapper) {

	public FlutterViewHandler() : this(PropertyMapper, null) { }

	public static IPropertyMapper<FlutterView, FlutterViewHandler> PropertyMapper = new PropertyMapper<FlutterView, FlutterViewHandler>(ViewMapper);

	protected override UIView CreatePlatformView() {
		return new FlutterViewWrapper(new iOS.Binding.Binding().FlutterViewController);
	}

	protected override void DisconnectHandler(UIView platformView) {
		platformView.Dispose();
		base.DisconnectHandler(platformView);
	}
}