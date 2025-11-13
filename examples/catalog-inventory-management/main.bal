import ballerina/io;
import ballerinax/sap.commerce.webservices as sapCommerceClient;

configurable string clientId = "your-client-id";
configurable string clientSecret = "your-client-secret";
configurable string serviceUrl = "http://localhost:9001/occ/v2";
configurable string baseSiteId = "electronics";

public function main() returns error? {
    
    sapCommerceClient:OAuth2ClientCredentialsGrantConfig authConfig = {
        clientId: clientId,
        clientSecret: clientSecret,
        tokenUrl: "http://localhost:9001/occ/v2/authorizationserver/oauth/token"
    };

    sapCommerceClient:ConnectionConfig connectionConfig = {
        auth: authConfig
    };

    sapCommerceClient:Client sapCommerceClient = check new (connectionConfig, serviceUrl);
    io:println("=== SAP Commerce Product Catalog Management Workflow ===\n");

    io:println("Step 1: Discovering available product catalogs...");
    xml catalogsResponse = check sapCommerceClient->getCatalogs(baseSiteId, {}, {fields: "FULL"});
    io:println("Available Catalogs:");
    io:println(catalogsResponse.toString());
    io:println();

    io:println("Step 2: Exploring specific catalog version details...");
    string catalogId = "electronicsProductCatalog";
    string catalogVersionId = "Online";
    xml catalogVersionResponse = check sapCommerceClient->getCatalogVersion(
        baseSiteId, 
        catalogId, 
        catalogVersionId, 
        {}, 
        {fields: "FULL"}
    );
    io:println("Catalog Version Details:");
    io:println(catalogVersionResponse.toString());
    io:println();

    io:println("Step 3: Retrieving product listings for category analysis...");
    string categoryId = "cameras";
    sapCommerceClient:GetProductsByCategoryQueries productQueries = {
        pageSize: 50,
        currentPage: 0,
        fields: "FULL",
        sort: "name-asc",
        query: "cameras:name-asc"
    };
    
    xml productsResponse = check sapCommerceClient->getProductsByCategory(
        baseSiteId, 
        categoryId, 
        {}, 
        productQueries
    );
    io:println("Products in Category '" + categoryId + "':");
    io:println(productsResponse.toString());
    io:println();

    io:println("Step 4: Analyzing additional product categories...");
    string[] additionalCategories = ["smartphones", "laptops", "accessories"];
    
    foreach string category in additionalCategories {
        io:println("Retrieving products for category: " + category);
        sapCommerceClient:GetProductsByCategoryQueries categoryQueries = {
            pageSize: 25,
            currentPage: 0,
            fields: "DEFAULT",
            sort: "price-asc"
        };
        
        xml categoryProducts = check sapCommerceClient->getProductsByCategory(
            baseSiteId, 
            category, 
            {}, 
            categoryQueries
        );
        io:println("Category '" + category + "' product count and details:");
        io:println(categoryProducts.toString());
        io:println();
    }

    io:println("Step 5: Performing inventory analysis with detailed product information...");
    sapCommerceClient:GetProductsByCategoryQueries inventoryQueries = {
        pageSize: 100,
        currentPage: 0,
        fields: "FULL",
        sort: "stock-desc",
        query: "*:stock-desc:inStockFlag:true"
    };
    
    xml inventoryAnalysis = check sapCommerceClient->getProductsByCategory(
        baseSiteId, 
        "brand_canon", 
        {}, 
        inventoryQueries
    );
    io:println("Inventory Analysis for Canon Brand Products:");
    io:println(inventoryAnalysis.toString());
    io:println();

    io:println("=== Product Catalog Management Workflow Complete ===");
    io:println("Summary: Successfully retrieved catalog information, explored catalog versions,");
    io:println("analyzed category structures, and performed inventory analysis across multiple");
    io:println("product categories for comprehensive catalog management.");
}