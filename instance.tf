resource "aws_key_pair" "new-key" {
  key_name   = "newkey"
  public_key = file(var.PUB_KEY)
}

resource "aws_instance" "terra-insta" {
  ami                    = var.AMIS[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  subnet_id              = aws_subnet.public-subnet-01.id
  key_name               = aws_key_pair.new-key.key_name
  vpc_security_group_ids = [aws_security_group.my-SG.id]
  tags = {
    Name    = "terra-insta"
    Project = "terra"
  }
}

resource "aws_ebs_volume" "terra-voulme4" {
  availability_zone = var.ZONE1
  size              = 40

  tags = {
    Name = "terra-volume"
  }
}

resource "aws_volume_attachment" "attach-volume-ECS-EC2" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.terra-voulme4.id
  instance_id = aws_instance.terra-insta.id
}

output "PublicIP" {
  value = aws_instance.terra-insta.public_ip
}