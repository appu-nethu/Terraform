resource "aws_instance" "web" {
  count = length(var.ec2_names)
  ami           = data.aws_ami.amazon-2.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [var.sg_id]
  subnet_id = var.subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  user_data = <<EOF
 #!/bin/bash
# Update the system's package list
yum update -y

# Install the Apache web server (httpd)
yum install -y httpd

# Start the Apache service
systemctl start httpd

# Enable Apache to start on every boot
systemctl enable httpd

# Create a simple index.html file in the web root directory
echo "<h1>Hello from my EC2 Instance!</h1>" > /var/www/html/index.html
  EOF
  tags = {
    Name = var.ec2_names[count.index]
  }
}