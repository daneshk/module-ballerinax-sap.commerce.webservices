import ballerina/io;
import ballerinax/sap.commerce.webservices as sapCommerceClient;

configurable string clientId = "your_client_id";
configurable string clientSecret = "your_client_secret";
configurable string serviceUrl = "http://localhost:9001/occ/v2";
configurable string baseSiteId = "electronics";
configurable string userId = "customer@example.com";

public function main() returns error? {

    sapCommerceClient:ConnectionConfig connectionConfig = {
        auth: {
            clientId: clientId,
            clientSecret: clientSecret,
            tokenUrl: "http://localhost:9001/occ/v2/authorizationserver/oauth/token"
        }
    };

    sapCommerceClient:Client commerceClient = check new (connectionConfig, serviceUrl);

    io:println("=== Customer Service Ticket Management Workflow ===");
    io:println();

    io:println("Step 1: Retrieving available ticket categories...");
    sapCommerceClient:GetTicketCategoriesQueries categoryQueries = {
        fields: "DEFAULT"
    };

    sapCommerceClient:TicketCategoryList|error categoryResult = commerceClient->getTicketCategories(
        baseSiteId,
        {},
        categoryQueries
    );

    if categoryResult is error {
        io:println("Error retrieving ticket categories: " + categoryResult.message());
        return categoryResult;
    }

    io:println("Available ticket categories:");
    sapCommerceClient:TicketCategory[]? ticketCategories = categoryResult.ticketCategories;
    if ticketCategories is sapCommerceClient:TicketCategory[] {
        foreach sapCommerceClient:TicketCategory category in ticketCategories {
            string categoryId = category.id;
            string categoryName = category.name ?: "N/A";
            io:println("  - ID: " + categoryId + ", Name: " + categoryName);
        }
    }
    io:println();

    io:println("Step 2: Creating a new support ticket for product complaint...");
    sapCommerceClient:TicketCategory selectedCategory = {
        id: "COMPLAINT",
        name: "Product Complaint"
    };

    sapCommerceClient:TicketAssociatedObject associatedOrder = {
        code: "00001234",
        'type: "Order"
    };

    sapCommerceClient:TicketStarter ticketPayload = {
        ticketCategory: selectedCategory,
        associatedTo: associatedOrder,
        subject: "Defective smartphone screen - immediate replacement needed",
        message: "Customer purchased a smartphone last week and the screen started flickering after 3 days of normal use. The device shows vertical lines and is becoming unusable. Customer is requesting immediate replacement under warranty."
    };

    sapCommerceClient:CreateTicketQueries ticketQueries = {
        fields: "DEFAULT"
    };

    sapCommerceClient:Ticket|error ticketResult = commerceClient->createTicket(
        baseSiteId,
        userId,
        ticketPayload,
        {},
        ticketQueries
    );

    if ticketResult is error {
        io:println("Error creating ticket: " + ticketResult.message());
        return ticketResult;
    }

    string ticketId = ticketResult.id ?: "";
    string ticketSubject = ticketResult.subject ?: "N/A";
    string ticketStatus = ticketResult.status?.name ?: "N/A";
    string ticketCreatedAt = ticketResult.createdAt ?: "N/A";

    io:println("Ticket created successfully!");
    io:println("  - Ticket ID: " + ticketId);
    io:println("  - Subject: " + ticketSubject);
    io:println("  - Status: " + ticketStatus);
    io:println("  - Created: " + ticketCreatedAt);
    io:println();

    io:println("Step 3: Adding follow-up communication to the ticket...");
    sapCommerceClient:TicketEvent followUpEvent = {
        message: "Follow-up: Customer has provided photos of the defective screen. The issue appears to be a manufacturing defect. Escalating to technical team for warranty replacement approval. Customer has been informed about the 24-48 hour processing time.",
        addedByAgent: true,
        author: "support.agent@company.com"
    };

    sapCommerceClient:CreateTicketEventQueries eventQueries = {
        fields: "DEFAULT"
    };

    sapCommerceClient:TicketEvent|error eventResult = commerceClient->createTicketEvent(
        baseSiteId,
        ticketId,
        userId,
        followUpEvent,
        {},
        eventQueries
    );

    if eventResult is error {
        io:println("Error creating ticket event: " + eventResult.message());
        return eventResult;
    }

    string eventCode = eventResult.code ?: "N/A";
    string eventAuthor = eventResult.author ?: "N/A";
    string eventMessage = eventResult.message;
    boolean eventAddedByAgent = eventResult.addedByAgent ?: false;
    string eventCreatedAt = eventResult.createdAt ?: "N/A";

    io:println("Follow-up event added successfully!");
    io:println("  - Event Code: " + eventCode);
    io:println("  - Author: " + eventAuthor);
    io:println("  - Message: " + eventMessage);
    io:println("  - Added by Agent: " + eventAddedByAgent.toString());
    io:println("  - Created At: " + eventCreatedAt);
    io:println();

    io:println("=== Customer Service Workflow Completed Successfully ===");
    io:println("The complete ticket management flow has been demonstrated:");
    io:println("1. ✓ Retrieved available ticket categories for proper classification");
    io:println("2. ✓ Created a new support ticket for the customer's product complaint");
    io:println("3. ✓ Added follow-up communication with additional details and updates");
    io:println();
    io:println("The customer service representative can now continue tracking and managing this ticket through its resolution.");
}
