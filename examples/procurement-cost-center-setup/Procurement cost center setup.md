# Procurement Cost Center Setup

This example demonstrates how to automate B2B procurement workflows using SAP Commerce, including creating cost centers, associating budgets, and initiating quote requests for bulk purchasing.

## Prerequisites

1. **SAP Commerce Setup**
   > Refer to the [SAP Commerce setup guide](https://central.ballerina.io/ballerinax/sap.commerce.webservices/latest#setup-guide) to obtain the necessary credentials and configure your SAP Commerce environment.

2. For this example, create a `Config.toml` file with your credentials:

```toml
clientId = "<Your Client ID>"
clientSecret = "<Your Client Secret>"
tokenUrl = "http://localhost:9001/occ/v2/authorizationserver/oauth/token"
serviceUrl = "http://localhost:9001/occ/v2"
baseSiteId = "powertools"
userId = "procurement.manager@company.com"
```

## Run the example

Execute the following command to run the example. The script will print its progress to the console as it creates the cost center, associates the budget, and initiates the quote request.

```shell
bal run
```

The script will perform the following operations:
1. Create a new cost center for the Marketing Department
2. Associate a budget with the created cost center
3. Create a quote request for bulk office supplies procurement