module "prod" {
    source = "../"
    instance_size = "t3.2xlarge"
    disk = 64
    inbound_rules = [{
            port = 22,
            protocol = "tcp",
            description = "Allow SSH"
        },
        {
            port = 5601,
            protocol = "tcp",
            description = "Allow Kibana"
        }
    ]
}