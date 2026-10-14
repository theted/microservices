' One hailstone step in Visual Basic .NET, for everyone who started on VB6.
Module Program
    Function NextNumber(n As Long) As Long
        If n Mod 2 = 0 Then
            Return n \ 2
        Else
            Return 3 * n + 1
        End If
    End Function

    Sub Main()
        Dim n As Long
        If Long.TryParse(Console.ReadLine(), n) AndAlso n > 0 Then
            Console.WriteLine(NextNumber(n))
        End If
    End Sub
End Module
