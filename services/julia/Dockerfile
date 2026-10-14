FROM julia:1.13
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.jl /app/
ENV STEP_CMD="julia --startup-file=no /app/collatz.jl"
CMD ["runner"]
