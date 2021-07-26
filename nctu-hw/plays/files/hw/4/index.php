<?php
$uri = $_SERVER['REQUEST_URI'];
$route = explode("?", $uri)[0];

if ("/app/" === $route || "/app" === $route) {
    if (isset($_GET['vid'])) {
        if (isset($_GET['time']))
            header("Location: https://youtu.be/" . $_GET['vid'] . "&t=" . $_GET['time']);
        else
            header("Location: https://youtu.be/" . $_GET['vid']);
    } else
        echo "App route enabled";
} elseif (str_contains($route, "/app/display/"))
    echo "Display: " . explode("/app/display/", $route)[1];
elseif (str_contains($route, "/app/calculate/")) {
    $values = explode("+", explode("/app/calculate/", $route)[1]);
    echo "Result: " . ((int)$values[0] + (int)$values[1]);
}
