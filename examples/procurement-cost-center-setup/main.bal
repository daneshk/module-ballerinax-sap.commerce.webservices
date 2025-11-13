import ballerina/io;
import ballerinax/sap.commerce.webservices;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string tokenUrl = "http://localhost:9001/occ/v2/authorizationserver/oauth/token";
configurable string serviceUrl = "http://localhost:9001/occ/v2";
configurable string baseSiteId = "powertools";
configurable string userId = "procurement.manager@company.com";

public function main() returns error? {
    // Initialize the SAP Commerce client
    webservices:ConnectionConfig config = {
        auth: {
            clientId: clientId,
            clientSecret: clientSecret,
            tokenUrl: tokenUrl
        }
    };

    webservices:Client sapClient = check new (config, serviceUrl);
    io:println("SAP Commerce client initialized successfully");

    // Step 1: Create a new cost center for the Marketing Department
    webservices:B2BCostCenter costCenterPayload = {
        code: "CC-MKTG-2024",
        name: "Marketing Department Cost Center 2024",
        activeFlag: true,
        currency: {
            isocode: "USD",
            name: "US Dollar",
            symbol: "$",
            active: true
        }
    };

    webservices:CreateCostCenterQueries costCenterQueries = {
        fields: "FULL"
    };

    webservices:B2BCostCenter createdCostCenter = check sapClient->createCostCenter(
        baseSiteId, 
        costCenterPayload, 
        {},
        costCenterQueries
    );
    
    string? costCenterNameOpt = createdCostCenter.name;
    string costCenterName = costCenterNameOpt is string ? costCenterNameOpt : "Unknown";
    string? costCenterCodeOpt = createdCostCenter.code;
    string costCenterCode = costCenterCodeOpt is string ? costCenterCodeOpt : "Unknown";
    io:println("Created cost center: " + costCenterName);
    io:println("Cost center code: " + costCenterCode);

    // Step 2: Associate budget with the cost center
    webservices:DoAddBudgetToCostCenterQueries budgetQueries = {
        budgetCode: "BUDGET-MKTG-2024",
        fields: "DEFAULT"
    };

    webservices:B2BSelectionData budgetAssignment = check sapClient->doAddBudgetToCostCenter(
        baseSiteId,
        "CC-MKTG-2024",
        {},
        budgetQueries
    );

    string? budgetIdOpt = budgetAssignment.id;
    string budgetId = budgetIdOpt is string ? budgetIdOpt : "Unknown";
    boolean? budgetActiveOpt = budgetAssignment.active;
    boolean budgetActive = budgetActiveOpt is boolean ? budgetActiveOpt : false;
    io:println("Budget assignment result - ID: " + budgetId);
    io:println("Budget assignment active: " + budgetActive.toString());

    // Step 3: Create a quote request for bulk office supplies
    webservices:QuoteStarter quotePayload = {
        cartId: "00001234"
    };

    webservices:CreateQuoteQueries quoteQueries = {
        fields: "FULL"
    };

    webservices:Quote createdQuote = check sapClient->createQuote(
        baseSiteId,
        userId,
        quotePayload,
        {},
        quoteQueries
    );

    io:println("Quote created successfully");
    string? quoteCodeOpt = createdQuote.code;
    string quoteCode = quoteCodeOpt is string ? quoteCodeOpt : "Unknown";
    string? quoteStateOpt = createdQuote.state;
    string quoteState = quoteStateOpt is string ? quoteStateOpt : "Unknown";
    io:println("Quote code: " + quoteCode);
    io:println("Quote state: " + quoteState);
    
    int? quoteVersion = createdQuote.'version;
    if quoteVersion is int {
        io:println("Quote version: " + quoteVersion.toString());
    } else {
        io:println("Quote version: Unknown");
    }

    io:println("\nB2B Procurement Workflow Completed Successfully!");
    io:println("- Cost center 'CC-MKTG-2024' created for Marketing Department");
    io:println("- Budget 'BUDGET-MKTG-2024' associated with cost center");
    io:println("- Quote request initiated for bulk office supplies procurement");
}