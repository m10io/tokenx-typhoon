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
