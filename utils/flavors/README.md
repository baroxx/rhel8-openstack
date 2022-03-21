OpenStack was deployed with default flavors in older versions. In newer versions you have to create them. The default flavors were:

|Flavor|VCPUs|Disk (in GB)|RAM (in MB)|
|---|---|---|---|
|m1.tiny|1|1|512|
|m1.small|1|20|2048|
|m1.medium|2|40|4096|
|m1.large|4|80|8192|
|m1.xlarge|8|160|16384|

You can use [create_default_flavors.sh](create_default_flavors.sh) to create them. You need to set the environment variables for the OpenStack CLI first.