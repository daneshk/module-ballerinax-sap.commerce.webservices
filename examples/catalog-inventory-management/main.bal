import ballerina/io;
import ballerinax/sap.commerce.webservices as sapCommerce;

configurable string clientId = "your-client-id";
configurable string clientSecret = "your-client-secret";
configurable string serviceUrl = "http://localhost:9001/occ/v2";
configurable string baseSiteId = "electronics";

public function main() returns error? {
    
    sapCommerce:OAuth2ClientCredentialsGrantConfig authConfig = {
        clientId: clientId,
        clientSecret: clientSecret,
        tokenUrl: "http://localhost:9001/occ/v2/authorizationserver/oauth/token"
    };

    sapCommerce:ConnectionConfig connectionConfig = {
        auth: authConfig
    };

    sapCommerce:Client sapCommerceClient = check new (connectionConfig, serviceUrl);
    io:println("=== SAP Commerce Product Catalog Management Workflow ===\n");

    io:println("Step 1: Discovering available product catalogs...");
    xml|sapCommerce:CatalogList catalogsResponse = check sapCommerceClient->getCatalogs(baseSiteId, {}, {fields: "FULL"});
    io:println("Available Catalogs:", catalogsResponse.toString());

    io:println("Step 2: Exploring specific catalog version details...");
    string catalogId = "electronicsProductCatalog";
    string catalogVersionId = "Online";
    xml|sapCommerce:CatalogVersion catalogVersionResponse = check sapCommerceClient->getCatalogVersion(
        baseSiteId, 
        catalogId, 
        catalogVersionId, 
        {}, 
        {fields: "FULL"}
    );
    io:println("Catalog Version Details:", catalogVersionResponse.toString());

    io:println("Step 3: Retrieving product listings for category analysis...");
    string categoryId = "cameras";
    sapCommerce:GetProductsByCategoryQueries productQueries = {
        pageSize: 50,
        currentPage: 0,
        fields: "FULL",
        sort: "name-asc",
        query: "cameras:name-asc"
    };

    xml|sapCommerce:ProductSearchPage productsResponse = check sapCommerceClient->getProductsByCategory(
        baseSiteId, 
        categoryId, 
        {}, 
        productQueries
    );
    io:println(string `Products in Category ${categoryId}:`, productsResponse.toString());

    io:println("Step 4: Analyzing additional product categories...");
    string[] additionalCategories = ["smartphones", "laptops", "accessories"];
    
    foreach string category in additionalCategories {
        io:println("Retrieving products for category: " + category);
        sapCommerce:GetProductsByCategoryQueries categoryQueries = {
            pageSize: 25,
            currentPage: 0,
            fields: "DEFAULT",
            sort: "price-asc"
        };

        xml|sapCommerce:ProductSearchPage categoryProducts = check sapCommerceClient->getProductsByCategory(
            baseSiteId,
            category,
            {},
            categoryQueries
        );
        io:println(string `Category '${category}' product count and details:`, categoryProducts.toString());
    }

    io:println("Step 5: Performing inventory analysis with detailed product information...");
    sapCommerce:GetProductsByCategoryQueries inventoryQueries = {
        pageSize: 100,
        currentPage: 0,
        fields: "FULL",
        sort: "stock-desc",
        query: "*:stock-desc:inStockFlag:true"
    };

    xml|sapCommerce:ProductSearchPage inventoryAnalysis = check sapCommerceClient->getProductsByCategory(
        baseSiteId,
        "brand_canon",
        {},
        inventoryQueries
    );
    io:println("Inventory Analysis for Canon Brand Products:", inventoryAnalysis.toString());

    io:println("=== Product Catalog Management Workflow Complete ===");
    io:println("Summary: Successfully retrieved catalog information, explored catalog versions,");
    io:println("analyzed category structures, and performed inventory analysis across multiple");
    io:println("product categories for comprehensive catalog management.");
}