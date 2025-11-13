import ballerina/io;
import ballerinax/sap.commerce.webservices as sapCommerceClient;

configurable string clientId = "your_client_id";
configurable string clientSecret = "your_client_secret";
configurable string tokenUrl = "http://localhost:9001/occ/v2/authorizationserver/oauth/token";
configurable string serviceUrl = "http://localhost:9001/occ/v2";

public function main() returns error? {
    sapCommerceClient:ConnectionConfig config = {
        auth: {
            clientId: clientId,
            clientSecret: clientSecret,
            tokenUrl: tokenUrl
        }
    };

    sapCommerceClient:Client sapClient = check new (config, serviceUrl);

    string baseSiteId = "electronics";
    string customerId = "customer123@email.com";
    
    io:println("=== E-commerce Customer Service Management Workflow ===");
    
    io:println("\n1. Retrieving store locations to help customer find nearest physical store...");
    
    sapCommerceClient:GetStoreLocationsQueries locationQueries = {
        query: "New York",
        latitude: 40.7128,
        longitude: -74.0060,
        radius: 50000.0,
        pageSize: 10,
        fields: "FULL"
    };
    
    xml storeLocations = check sapClient->getStoreLocations(baseSiteId, {}, locationQueries);
    io:println("Store locations retrieved successfully:");
    io:println(storeLocations.toString());
    
    io:println("\n2. Creating support ticket for customer's product return request...");
    
    sapCommerceClient:TicketStarter ticketPayload = {
        subject: "Product Return Request - Defective Camera",
        message: "Customer reports that the digital camera purchased last week (Order #ORD-789456) has a malfunctioning flash unit. Customer would like to return the item for a full refund or exchange. Product was purchased online and customer prefers to return at nearest physical store location.",
        ticketCategory: {
            id: "RETURNS",
            name: "Product Returns"
        },
        associatedTo: {
            code: "ORD-789456",
            'type: "Order"
        }
    };
    
    sapCommerceClient:CreateTicketQueries ticketQueries = {
        fields: "FULL"
    };
    
    sapCommerceClient:Ticket createdTicket = check sapClient->createTicket(baseSiteId, customerId, ticketPayload, {}, ticketQueries);
    io:println("Support ticket created successfully:");
    io:println("Ticket ID: ", createdTicket["ticketId"] ?: "N/A");
    io:println("Subject: ", createdTicket["subject"] ?: "N/A");
    io:println("Status: ", createdTicket["status"]?.name ?: "N/A");
    
    string ticketId = <string>(createdTicket["ticketId"] ?: "TKT-001");
    
    io:println("\n3. Creating ticket event to log resolution steps and documentation...");
    
    sapCommerceClient:TicketEvent eventPayload = {
        message: "Resolution Update: Customer service representative verified purchase details and confirmed product is within return policy window. Provided customer with return authorization number RET-2024-001. Customer will return item to Manhattan store location (confirmed nearest store from location search). Attached return shipping label and product inspection checklist for store staff reference.",
        code: "CUSTOMER_UPDATE",
        addedByAgent: true,
        author: "Customer Service Rep - Sarah Johnson",
        toStatus: {
            id: "IN_PROGRESS",
            name: "In Progress"
        }
    };
    
    sapCommerceClient:CreateTicketEventQueries eventQueries = {
        fields: "FULL"
    };
    
    sapCommerceClient:TicketEvent createdEvent = check sapClient->createTicketEvent(baseSiteId, ticketId, customerId, eventPayload, {}, eventQueries);
    io:println("Ticket event created successfully:");
    io:println("Event Author: ", createdEvent.author ?: "N/A");
    io:println("Event Message: ", createdEvent.message);
    io:println("Added by Agent: ", createdEvent.addedByAgent.toString());
    io:println("Status Updated To: ", createdEvent.toStatus?.name ?: "N/A");
    
    io:println("\n=== Customer Service Workflow Completed Successfully ===");
    io:println("Summary:");
    io:println("- Store locations retrieved to assist customer");
    io:println("- Support ticket created for return request tracking");
    io:println("- Resolution steps documented with ticket event");
    io:println("- Customer has clear next steps and return authorization");
}