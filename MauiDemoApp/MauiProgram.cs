using Microsoft.Maui.Controls.Compatibility.Hosting;

namespace MauiDemoApp;

public static class MauiProgram
{
    public static MauiApp CreateMauiApp()
    {
        var builder = MauiApp.CreateBuilder();
        builder
            .UseMauiApp<App>()
            .UseMauiCompatibility()
            .ConfigureFonts(fonts =>
            {
                fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
                fonts.AddFont("OpenSans-Semibold.ttf", "OpenSansSemibold");
            })
            .ConfigureMauiHandlers(handlers =>
            {
#if IOS
                handlers.AddHandler(typeof(FlutterView), typeof(FlutterViewHandler));
                handlers.AddHandler(typeof(FlutterPage), typeof(FlutterPageHandler));
#elif ANDROID
                handlers.AddHandler(typeof(FlutterView), typeof(FlutterViewHandler));
                handlers.AddHandler(typeof(FlutterPage), typeof(FlutterPageHandler));
#endif
            });

        return builder.Build();
    }
}