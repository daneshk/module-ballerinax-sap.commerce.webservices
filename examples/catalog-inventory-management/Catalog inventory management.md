# Catalog Inventory Management

This example demonstrates how to perform comprehensive product catalog management operations using SAP Commerce Cloud, including discovering catalogs, exploring category structures, and analyzing inventory across multiple product categories.

## Prerequisites

1. **SAP Commerce WebServices Setup**
   > Refer the [SAP Commerce WebServices setup guide](https://central.ballerina.io/ballerinax/sap.commerce.webservices/latest#setup-guide) here.

2. For this example, create a `Config.toml` file with your credentials:

```toml
clientId = "<Your Client ID>"
clientSecret = "<Your Client Secret>"
serviceUrl = "http://localhost:9001/occ/v2"
baseSiteId = "electronics"
```

## Run the Example

Execute the following command to run the example. The script will print its progress to the console.

```shell
bal run
```

The script will perform a comprehensive catalog management workflow:
- Discover available product catalogs
- Explore specific catalog version details
- Retrieve product listings for category analysis
- Analyze additional product categories (smartphones, laptops, accessories)
- Perform inventory analysis with detailed product information