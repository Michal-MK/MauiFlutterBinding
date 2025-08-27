namespace MauiDemoApp;

public partial class PageWithFlutterView : ContentPage
{
	public PageWithFlutterView()
	{
		InitializeComponent();
	}

	private void IncreaseSize(object sender, EventArgs e)
	{
		flutterView.HeightRequest += 50;
	}
	
	private void DecreaseSize(object sender, EventArgs e)
	{
		flutterView.HeightRequest -= 50;
	}
}