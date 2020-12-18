locals {
  backups = {
    schedule  = "cron(0 5 ? * MON-FRI *)" /* UTC Time */
    retention = 7 // days
  }
}

resource "aws_backup_vault" "example-backup-vault" {
  name = "example-backup-vault"
  tags = {
    Project = var.project
    Role    = "backup-vault"
  }
}

resource "aws_backup_plan" "example-backup-plan" {
  name = "example-backup-plan"

  rule {
    rule_name         = "weekdays-every-2-hours-${local.backups.retention}-day-retention"
    target_vault_name = aws_backup_vault.example-backup-vault.name
    schedule          = local.backups.schedule
    start_window      = 60
    completion_window = 300

    lifecycle {
      delete_after = local.backups.retention
    }

    recovery_point_tags = {
      Project = var.project
      Role    = "backup"
      Creator = "aws-backups"
    }
  }

  tags = {
    Project = var.project
    Role    = "backup"
  }
}

resource "aws_backup_selection" "example-server-backup-selection" {
  iam_role_arn = aws_iam_role.example-aws-backup-service-role.arn
  name         = "example-server-resources"
  plan_id      = aws_backup_plan.example-backup-plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }
}


