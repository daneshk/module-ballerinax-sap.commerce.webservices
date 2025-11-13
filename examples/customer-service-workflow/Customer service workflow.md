# Customer Service Workflow

This example demonstrates a comprehensive customer service workflow using SAP Commerce Cloud. The script helps manage customer return requests by retrieving nearby store locations, creating support tickets, and documenting resolution steps.

## Prerequisites

1. **SAP Commerce Cloud Setup**
   > Refer the [SAP Commerce Cloud setup guide](https://central.ballerina.io/ballerinax/sap.commerce.webservices/latest) here.

2. For this example, create a `Config.toml` file with your credentials:

```toml
clientId = "<Your Client ID>"
clientSecret = "<Your Client Secret>"
tokenUrl = "http://localhost:9001/occ/v2/authorizationserver/oauth/token"
serviceUrl = "http://localhost:9001/occ/v2"
```

## Run the example

Execute the following command to run the example. The script will print its progress to the console.

```shell
bal run
```

The workflow will:
1. Retrieve store locations near the customer to help them find the nearest physical store
2. Create a support ticket for the customer's product return request
3. Add a ticket event to document resolution steps and provide clear next steps for the customer