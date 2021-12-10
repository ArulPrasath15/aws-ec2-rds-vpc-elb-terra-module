
<!DOCTYPE html>
<html>
<body>

<h1>Hello World!</h1>

<?php

 $db_user=trim(file_get_contents('user.txt'));
 $db_pass=trim(file_get_contents('pass.txt'));
 $db_host=trim(file_get_contents('host.txt'));

  $conn = new mysqli("$db_host:3306", "root", "rootroot");
	
	
// Check connection
if ($conn -> connect_errno) {
  ?>
  <h1 style="color:red;" >Not Connected with MySQL</h1>

<?php
  echo "Failed to connect to MySQL: " . $mysqli -> connect_error;
  exit();
}
else{
  ?>
  <h1 style="color:green;" >Connected with MySQL</h1>

<?php
}

// Check connection
if ($conn->connect_error) 
	die("Connection failed: " . $conn->connect_error);
 
if (!($result=mysqli_query($conn,'SHOW DATABASES')))
    printf("Error: %s\n", mysqli_error($conn));

echo "<h3>Databases</h3>";

while($row = mysqli_fetch_row( $result ))
    echo $row[0]."<br />";

$result -> free_result();
$conn->close();
?>


</body>
</html>