namespace MauiDemoApp.Platforms.Android;

public class StringResultImpl : Java.Lang.Object, Com.Maui.Binding.IStringCallback {
	public Action<string>? Callback { get; set; }

	public void OnResult(string? result) {
		Callback?.Invoke(result ?? "No result came back");
	}
}