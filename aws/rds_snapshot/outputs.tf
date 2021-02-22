output "db_snapshot_arn" {
  value = aws_db_snapshot.snap.db_snapshot_arn
}

output "status" {
  value = aws_db_snapshot.snap.status
}

output "db_snapshot_name" {
  value = aws_db_snapshot.snap.db_snapshot_identifier
}
