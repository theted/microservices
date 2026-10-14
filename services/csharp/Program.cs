var app = WebApplication.CreateSlimBuilder(args).Build();

app.MapGet("/", (long? n) => n is >= 1
    ? Results.Text((n % 2 == 0 ? n / 2 : 3 * n + 1).ToString())
    : Results.Text("need ?n=<positive integer>", statusCode: 400));

app.Run();
