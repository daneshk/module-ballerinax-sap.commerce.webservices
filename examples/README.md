# Examples

The `sap.commerce.webservices` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-sap.commerce.webservices/tree/main/examples), covering use cases like procurement cost center setup, catalog inventory management, and support ticket management.

1. [Procurement cost center setup](https://github.com/ballerina-platform/module-ballerinax-sap.commerce.webservices/tree/main/examples/procurement-cost-center-setup) - Configure and establish cost centers for procurement operations in SAP Commerce.

2. [Catalog inventory management](https://github.com/ballerina-platform/module-ballerinax-sap.commerce.webservices/tree/main/examples/catalog-inventory-management) - Manage product catalog and inventory levels within SAP Commerce system.

3. [Support ticket management](https://github.com/ballerina-platform/module-ballerinax-sap.commerce.webservices/tree/main/examples/support-ticket-management) - Handle customer support tickets and service requests through SAP Commerce.

4. [Customer service workflow](https://github.com/ballerina-platform/module-ballerinax-sap.commerce.webservices/tree/main/examples/customer-service-workflow) - Implement automated workflows for customer service operations and processes.

## Prerequisites

1. Generate SAP Commerce credentials to authenticate the connector as described in the [Setup guide](https://central.ballerina.io/ballerinax/sap.commerce.webservices/latest#setup-guide).

2. For each example, create a `Config.toml` file the related configuration. Here's an example of how your `Config.toml` file should look:

    ```toml
    clientId = "<Your Client ID>"
    clientSecret = "<Your Client Secret>"
    refreshToken = "<Your Refresh Token>"
    ```

## Running an Example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```