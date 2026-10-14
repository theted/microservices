<?php
header('Content-Type: text/plain');

$n = filter_input(INPUT_GET, 'n', FILTER_VALIDATE_INT, ['options' => ['min_range' => 1]]);
if (!$n) {
    http_response_code(400);
    exit('need ?n=<positive integer>');
}

echo $n % 2 === 0 ? intdiv($n, 2) : 3 * $n + 1;
