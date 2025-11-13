## Overview

[SAP Commerce Cloud](https://www.sap.com/products/crm/commerce-cloud.html) is a comprehensive e-commerce platform that enables businesses to deliver personalized, omnichannel shopping experiences across all touchpoints, from web and mobile to social and in-store interactions.

The `ballerinax/sap.commerce.webservices` package offers APIs to connect and interact with [SAP Commerce Cloud API](https://help.sap.com/docs/SAP_COMMERCE_CLOUD_PUBLIC_CLOUD/0995c8579f3d4ea2a7c0e1ef5e2b3d1c/8c91f3a486691014b085fb11c44412fc.html) endpoints, specifically based on [SAP Commerce Web Services API v2](https://help.sap.com/docs/SAP_COMMERCE_CLOUD_PUBLIC_CLOUD/d0224eca81e249cb821f2cdf45a82ace/8c91f3a486691014b085fb11c44412fc.html).
## Setup guide

To use the SAP Commerce Web Services connector, you must have access to SAP Commerce Cloud (formerly SAP Hybris) through a valid SAP account and configure OAuth2 authentication credentials. If you do not have an SAP account, you can sign up for one [here](https://www.sap.com/registration.html) and explore SAP Commerce Cloud solutions at the [SAP Commerce Cloud portal](https://www.sap.com/products/commerce-cloud.html).

### Step 1: Create an SAP Account and Access SAP Commerce Cloud

1. Navigate to the [SAP website](https://www.sap.com/) and sign up for an account or log in if you already have one.

2. Ensure you have access to SAP Commerce Cloud, which typically requires a licensed subscription or access through SAP's cloud platform services.

### Step 2: Configure OAuth2 Client Credentials

1. Log in to your SAP Commerce Cloud administration console (Backoffice or HAC - Hybris Administration Console).

2. Navigate to System > OAuth > OAuth Client Details or access the OAuth configuration through the Platform > Configuration menu.

3. Create a new OAuth client or modify an existing one by providing the necessary client ID and client secret for your application.

4. Configure the appropriate scopes and grant types (typically "client_credentials" for API access) based on your integration requirements.

> **Tip:** You must copy and store the client secret somewhere safe. It won't be visible again in your configuration settings for security reasons.
## Quickstart

To use the `SAP Commerce Web Services` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerina/oauth2;
import ballerinax/sap.commerce.webservices as sapcommerce;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file with your credentials:

```toml
clientId = "<Your_Client_Id>"
clientSecret = "<Your_Client_Secret>"
refreshToken = "<Your_Refresh_Token>"
```

2. Create a `sapcommerce:ConnectionConfig` and initialize the client:

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

final sapcommerce:Client sapcommerceClient = check new({
    auth: {
        clientId,
        clientSecret,
        refreshToken
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Create a new cost center

```ballerina
public function main() returns error? {
    sapcommerce:B2BCostCenter newCostCenter = {
        code: "CC001",
        name: "Marketing Cost Center",
        activeFlag: true,
        currency: {
            isocode: "USD",
            name: "US Dollar"
        }
    };

    sapcommerce:B2BCostCenter response = check sapcommerceClient->createCostCenter("electronics", newCostCenter);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```
## Examples

The `sap.commerce.webservices` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-sap.commerce.webservices/tree/main/examples), covering the following use cases:

1. [Procurement cost center setup](https://github.com/ballerina-platform/module-ballerinax-sap.commerce.webservices/tree/main/examples/procurement-cost-center-setup) - Demonstrates how to configure and manage procurement cost centers using the SAP Commerce Web Services connector.
2. [Catalog inventory management](https://github.com/ballerina-platform/module-ballerinax-sap.commerce.webservices/tree/main/examples/catalog-inventory-management) - Illustrates managing product catalogs and inventory levels through SAP Commerce Web Services.
3. [Support ticket management](https://github.com/ballerina-platform/module-ballerinax-sap.commerce.webservices/tree/main/examples/support-ticket-management) - Shows how to create, update, and track customer support tickets using the connector.
4. [Customer service workflow](https://github.com/ballerina-platform/module-ballerinax-sap.commerce.webservices/tree/main/examples/customer-service-workflow) - Demonstrates automating customer service processes and workflows through SAP Commerce Web Services.