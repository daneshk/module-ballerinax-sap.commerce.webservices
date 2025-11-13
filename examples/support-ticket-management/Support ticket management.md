# Support Ticket Management

This example demonstrates a complete customer service ticket management workflow using SAP Commerce. The script retrieves available ticket categories, creates a new support ticket for a product complaint, and adds follow-up communication to track the resolution process.

## Prerequisites

1. **SAP Commerce Setup**
   > Refer the [SAP Commerce setup guide](https://central.ballerina.io/ballerinax/sap.commerce.webservices) here.

2. For this example, create a `Config.toml` file with your credentials:

```toml
clientId = "<Your Client ID>"
clientSecret = "<Your Client Secret>"
serviceUrl = "http://localhost:9001/occ/v2"
baseSiteId = "electronics"
userId = "customer@example.com"
```

## Run the example

Execute the following command to run the example. The script will print its progress to the console.

```shell
bal run
```

The script will demonstrate the complete customer service workflow:
1. Retrieve and display available ticket categories
2. Create a new support ticket for a product complaint
3. Add follow-up communication with additional details