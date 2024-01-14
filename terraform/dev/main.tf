module "dev" {
    source = "../"
    instance_size = "t3.xlarge"
    disk = 32
    inbound_rules = [{
            port = 22,
            protocol = "tcp",
            description = "Allow SSH"
        },
        {
            port = 9042,
            protocol = "tcp",
            description = "Allow Cassandra"
        },
        {
            port = 5601,
            protocol = "tcp",
            description = "Allow Kibana"
        }
    ]
}