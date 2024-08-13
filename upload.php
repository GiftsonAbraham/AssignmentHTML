<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['file'])) {
    $file = $_FILES['file'];
    $uploadDir = '/var/www/html/uploads/';
    $uploadFile = $uploadDir . basename($file['name']);

    if (move_uploaded_file($file['tmp_name'], $uploadFile)) {
        echo "File successfully uploaded.";
    } else {
        echo "File upload failed.";
    }
}
?>
