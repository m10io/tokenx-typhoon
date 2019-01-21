# IAM Roles and Policies for Workers

data "aws_iam_policy_document" "worker_role_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "worker_role" {
  name               = "${var.name}-worker-instance-role"
  assume_role_policy = "${data.aws_iam_policy_document.worker_role_doc.json}"
}

data "aws_iam_policy_document" "worker_policy_doc" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ecr:*",
      "codecommit:*",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
      "route53:GetHostedZone",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/${var.dns_zone_id}",
    ]
  }

  statement {
    actions = [
      "route53:GetChange",
    ]

    resources = [
      "arn:aws:route53:::change/*",
    ]
  }

  statement {
    actions = [
      "route53:ListHostedZones",
    ]

    resources = ["*"]
  }


  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "worker_policy" {
  name = "${var.name}-worker-instance-role-policy"

  # path        = "/"
  role   = "${aws_iam_role.worker_role.id}"
  policy = "${data.aws_iam_policy_document.worker_policy_doc.json}"
}

resource "aws_iam_instance_profile" "worker_profile" {
  name = "${var.name}-worker-instance-role"
  role = "${aws_iam_role.worker_role.name}"
}
