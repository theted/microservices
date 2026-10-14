// One hailstone step from F#, on the same ASP.NET Core as the C# service, but with pipes.
open System
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Http

let step n = if n % 2L = 0L then n / 2L else 3L * n + 1L

let app = WebApplication.CreateSlimBuilder().Build()

app.MapGet("/", Func<HttpRequest, IResult>(fun request ->
    match Int64.TryParse(string request.Query["n"]) with
    | true, n when n > 0L -> step n |> string |> Results.Text
    | _ -> Results.Text("need ?n=<positive integer>", statusCode = Nullable 400)))
|> ignore

app.Run()
