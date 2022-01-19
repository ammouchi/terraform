//importing provider
provider "aws" {
  //we can export this to global terraform variable
    region =  "us-east-1" 
    //user credentiel and user must have permissions to create and query
   // access_key = "-----"
    //secret_key = "-----"
}

variable "subnet-var" {
  description = "my subnet variable"
  
}

variable "vpc-var" {
  description = "my vpc variable"
  
}
variable "environnement" {
   description = "environnement"
}

// ressource that we will create must be <providerName>_<ressoucesType>  <variableName> inside terraform>
resource "aws_vpc" "development_vpc"{
    //parameters
    cidr_block = var.vpc-var // adresse range to be in vpc

}
//anything that we will create start with ressource
resource "aws_subnet" "development-subnet-1" {
    //here our vpc is not yet created so we can reference it
    vpc_id = aws_vpc.development_vpc.id
    cidr_block = "10.0.10.0/24" //sub range of the vpc range
    availability_zone = "us-east-1" //otherwise it will get a random availaibility zone
    tags = {
      "vpc-env" : "env"
      Name : var.environnement
    }
}


//query existing resources and components from aws
//same structure <Provider_Name>_<ResourceType> <terraformVariableName>
data "aws_vpc" "existing_vpc"{
 //filter criteria 
 //get the default vpc
 default = true
}
resource "aws_subnet" "development-subnet-2" {
    //get the id from the referenced one comming from data
    vpc_id = data.aws_vpc.existing_vpc.id
    //range must be in default vpc range and different from other subnet in same vpc
    cidr_block = var.subnet-var  //get the file from the variable
    availability_zone = "us-east-1" //otherwise it will get a random availaibility zone
    tags = {
      "vpc-env" = "env"
       Name : "default-developement-subnet-2"
    }
}

//will return the specified attribute for created ressource
//we can show it with terraform state show resource
//for each attribute we must have it's ouput
output "subnet-1"{
  value = aws_subnet.development-subnet-1.id
}

output "subnet-2"{
  value = aws_subnet.development-subnet-2.id
}