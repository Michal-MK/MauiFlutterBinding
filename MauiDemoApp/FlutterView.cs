using MauiDemoApp.Enums;

namespace MauiDemoApp;

public class FlutterView : View {
	
	public const string ComponentOne = "component_one";
	public const string ComponentTwo = "component_two";
	
	public required float HeightExpectancy { get; set; }
	public required AndroidRenderMode AndroidRenderMode { get; set; }
	public required string ViewType { get; set; }
}