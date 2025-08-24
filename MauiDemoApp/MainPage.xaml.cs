#if ANDROID
using Binding = Com.Maui.Binding.Binding;
using MauiDemoApp.Platforms.Android;
#elif IOS || MACCATALYST
using iOS.Binding;
#endif

namespace MauiDemoApp;

public partial class MainPage : ContentPage
{
    public MainPage()
	{
		InitializeComponent();
	}

    void OnAsyncClicked(System.Object sender, System.EventArgs e)
    {
        asyncButton.IsVisible = false;
        asyncLabel.IsVisible = true;
        var parameters = new[] { "Hello", "world!" };
        
#if ANDROID
        new Binding().Async(MainActivity.Instance, parameters.ToList(), new StringResultImpl() { Callback = OnAsyncResult });
#elif IOS || MACCATALYST
        new iOS.Binding.Binding().AsyncWithParameters(parameters, OnAsyncResult);
#endif
    }

    private void OnAsyncResult(string result)
    {
        MainThread.BeginInvokeOnMainThread(() =>
        {
            asyncLabel.Text = result;
        });        
    }

    private void OnRendererClicked(object? sender, EventArgs e) {
        (App.Current.MainPage as NavigationPage)?.PushAsync(new FlutterPage(), animated: false);
    }

    private void OnHandlerClicked(object? sender, EventArgs e) {
        (App.Current.MainPage as NavigationPage)?.PushAsync(new PageWithFlutterView(), animated: true);
    }
}