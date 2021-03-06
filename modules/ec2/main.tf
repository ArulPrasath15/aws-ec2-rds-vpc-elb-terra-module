
#SG for EC2 instance
resource "aws_security_group" "sg" {
  name        = "${var.owner}-sg"
  description = "Allow http inbound traffic"
  vpc_id      = var.vpc_id           

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.owner}-sg"
    Createdby="${var.ownermail}"
    Environmnet="${var.env}"
  }
}

#EC2
resource "aws_instance" "ec2_instance" {
  count         = var.instance_count        
  ami           = data.aws_ami.ami_id.id                             
  instance_type = var.instance_type      
  subnet_id     = element(var.public_subnet_ids, count.index)          
  key_name               = var.instance_keypair      
  vpc_security_group_ids = [aws_security_group.sg.id]
 
 provisioner "file" {
      source = "index.php"
      destination = "/tmp/index.php"
		  connection {
		    type ="ssh"
		    host=self.public_ip
		    user="ec2-user"
		    password=""
		    private_key = file("TrainingKey-Arul.pem")
		  }
 }
  provisioner "remote-exec" {
      inline = [
         "sudo yum update -y",
         "sudo amazon-linux-extras install -y php7.2",
         "sudo yum install -y httpd git",
         "sudo systemctl start httpd",
         "sudo systemctl enable httpd",
         "sudo usermod -a -G apache ec2-user",
         "sudo chown -R ec2-user:apache /var/www",
         "sudo chmod 2775 /var/www",
         "cd /var/www/html",
         "cp /tmp/index.php .",
         "sudo echo '${var.mysql_address}' > host.txt"
      ]
		  connection {
		    type ="ssh"
		    host=self.public_ip
		    user="ec2-user"
		    password=""
		    private_key = file("TrainingKey-Arul.pem")
		  }
 }


  tags = {
    Name = "${var.owner}-ec2-${count.index + 1}"
    Createdby="${var.ownermail}"
    Environmnet="${var.env}"
  }
}
data "aws_ami" "ami_id" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
