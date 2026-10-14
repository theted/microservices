       IDENTIFICATION DIVISION.
       PROGRAM-ID. COLLATZ.
      * ONE HAILSTONE STEP, PROCESSED IN A BATCH OF EXACTLY ONE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 N             PIC 9(10).
       01 HALF          PIC 9(10).
       01 PARITY        PIC 9.
       01 ANSWER        PIC Z(10)9.
       PROCEDURE DIVISION.
           ACCEPT N.
           DIVIDE N BY 2 GIVING HALF REMAINDER PARITY.
           IF PARITY = 0
               MOVE HALF TO ANSWER
           ELSE
               COMPUTE ANSWER = 3 * N + 1
           END-IF.
           DISPLAY ANSWER.
           STOP RUN.
