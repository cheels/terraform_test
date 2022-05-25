output "aws_members_public_dns" {
  value       = formatlist("%s", aws_instance.hazelcast_member.*.public_dns)
  description = "The public DNS of the Hazelcast Members"
}


