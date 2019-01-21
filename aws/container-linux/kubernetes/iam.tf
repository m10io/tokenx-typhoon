# IAM Roles and Policies for Controllers (Masters)

data "aws_iam_policy_document" "controller_role_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "controller_role" {
  name               = "${var.cluster_name}-controller-instance-role"
  assume_role_policy = "${data.aws_iam_policy_document.controller_role_doc.json}"
}

data "aws_iam_policy_document" "controller_policy_doc" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:*",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "elasticloadbalancing:*",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
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
}

resource "aws_iam_role_policy" "controller_policy" {
  name = "${var.cluster_name}-controller-instance-role-policy"

  # path        = "/"
  role   = "${aws_iam_role.controller_role.id}"
  policy = "${data.aws_iam_policy_document.controller_policy_doc.json}"
}

resource "aws_iam_instance_profile" "controller_profile" {
  name = "${var.cluster_name}-controller-instance-role"
  role = "${aws_iam_role.controller_role.name}"
}
