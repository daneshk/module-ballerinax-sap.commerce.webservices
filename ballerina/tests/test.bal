// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/os;
import ballerina/test;
import sap.commerce.webservices.mock.server as _;

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string clientId = isLiveServer ? os:getEnv("SAP_CLIENT_ID") : "test_client_id";
configurable string clientSecret = isLiveServer ? os:getEnv("SAP_CLIENT_SECRET") : "test_client_secret";
configurable string serviceUrl = isLiveServer ? "https://api.commerce.sap.com/occ/v2" : "http://localhost:9090/v1";



ConnectionConfig config = {
    auth: {
        clientId: clientId,
        clientSecret: clientSecret
    }
};
final Client sapCommerceClient = check new Client(config, serviceUrl);

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteCartEntry() returns error? {
    error? response = check sapCommerceClient->removeCartEntry("electronics", "current", 0, "current");
    test:assertTrue(response is (), "Expected no error on successful delete");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetCatalogs() returns error? {
    xml _ = check sapCommerceClient->getCatalogs("electronics");
    // Successfully retrieved catalogs
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetCatalog() returns error? {
    xml _ = check sapCommerceClient->getCatalog("electronics", "electronicsProductCatalog");
    // Successfully retrieved catalog
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetCategory() returns error? {
    xml _ = check sapCommerceClient->getCategories("electronics", "electronicsProductCatalog", "Online", "cameras");
    // Successfully retrieved category
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetCategoryProducts() returns error? {
    xml _ = check sapCommerceClient->getProductsByCategory("electronics", "cameras");
    // Successfully retrieved category products
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetCountries() returns error? {
    xml _ = check sapCommerceClient->getCountries("electronics");
    // Successfully retrieved countries
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetCurrencies() returns error? {
    xml _ = check sapCommerceClient->getCurrencies("electronics");
    // Successfully retrieved currencies
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetLanguages() returns error? {
    xml _ = check sapCommerceClient->getLanguages("electronics");
    // Successfully retrieved languages
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetOrder() returns error? {
    Order|xml response = check sapCommerceClient->getOrder("electronics", "ORDER001");
    if response is Order {
        test:assertTrue(response?.code !is (), "Expected order to have a code");
        test:assertTrue(response?.status !is (), "Expected order to have a status");
        test:assertTrue(response?.totalPrice !is (), "Expected order to have a total price");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetPaymentModes() returns error? {
    xml _ = check sapCommerceClient->getPaymentModes("electronics");
    // Successfully retrieved payment modes
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetProductAvailabilities() returns error? {
    SAPAvailability response = check sapCommerceClient->getProductAvailability("electronics", filters = "3318057_A:EA,PC;4112097_B:EA");
    test:assertTrue((response.availabilityItems ?: []).length() > 0, "Expected a non-empty availability items array");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetProduct() returns error? {
    Product|xml response = check sapCommerceClient->getProduct("electronics", "PHONE001");
    if response is Product {
        test:assertTrue(response?.code !is (), "Expected product to have a code");
        test:assertTrue(response?.name !is (), "Expected product to have a name");
        test:assertTrue(response?.price !is (), "Expected product to have a price");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testSearchProducts() returns error? {
    xml _ = check sapCommerceClient->getProducts("electronics", query = "iphone");
    // Successfully searched products
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetProductSuggestions() returns error? {
    xml _ = check sapCommerceClient->getSuggestions("electronics", term = "iphone");
    // Successfully retrieved suggestions
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetPromotions() returns error? {
    xml _ = check sapCommerceClient->getPromotions("electronics", 'type = "all");
    // Successfully retrieved promotions
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetStores() returns error? {
    xml _ = check sapCommerceClient->getStoreLocations("electronics", query = "New York");
    // Successfully retrieved store locations
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetUser() returns error? {
    User|xml response = check sapCommerceClient->getUser("electronics", "current");
    if response is User {
        test:assertTrue(response?.uid !is (), "Expected user to have a uid");
        test:assertTrue(response?.name !is (), "Expected user to have a name");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetUserAddresses() returns error? {
    xml _ = check sapCommerceClient->getAddresses("electronics", "current");
    // Successfully retrieved user addresses
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetUserCarts() returns error? {
    xml _ = check sapCommerceClient->getCarts("electronics", "current");
    // Successfully retrieved user carts
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetCart() returns error? {
    xml _ = check sapCommerceClient->getCart("electronics", "current", "current");
    // Successfully retrieved cart
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetCartDeliveryModes() returns error? {
    xml _ = check sapCommerceClient->getCartDeliveryModes("electronics", "current", "current");
    // Successfully retrieved cart delivery modes
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetCartEntries() returns error? {
    xml _ = check sapCommerceClient->getCartEntries("electronics", "current", "current");
    // Successfully retrieved cart entries
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetUserOrder() returns error? {
    Order|xml response = check sapCommerceClient->getUserOrders("electronics", "ORDER001", "current");
    if response is Order {
        test:assertTrue(response?.code !is (), "Expected order to have a code");
        test:assertTrue(response?.status !is (), "Expected order to have a status");
        test:assertTrue(response?.totalPrice !is (), "Expected order to have a total price");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateUser() returns error? {
    User userPayload = {
        uid: "current",
        firstName: "John",
        lastName: "Doe"
    };
    error? response = check sapCommerceClient->updateUser("electronics", "current", userPayload);
    test:assertTrue(response is (), "Expected no error on successful update");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testRegisterUser() returns error? {
    UserSignUp userSignUp = {
        uid: "new.user@example.com",
        password: "password123",
        firstName: "New",
        lastName: "User"
    };
    User|xml response = check sapCommerceClient->createUser("electronics", userSignUp);
    if response is User {
        test:assertTrue(response?.uid !is (), "Expected registered user to have a uid");
        test:assertTrue(response?.firstName !is (), "Expected registered user to have a first name");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateAddress() returns error? {
    Address addressPayload = {
        titleCode: "mr",
        firstName: "John",
        lastName: "Doe",
        line1: "789 New Street",
        town: "Brooklyn",
        postalCode: "11201",
        country: {
            isocode: "US"
        }
    };
    xml _ = check sapCommerceClient->createAddress("electronics", "current", addressPayload);
    // Successfully created address
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateCart() returns error? {
    xml _ = check sapCommerceClient->createCart("electronics", "current");
    // Successfully created cart
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testAddProductToCart() returns error? {
    OrderEntry entryPayload = {
        product: {
            code: "NEW-PRODUCT"
        },
        quantity: 1
    };
    xml _ = check sapCommerceClient->addCartEntry("electronics", "current", "current", entryPayload);
    // Successfully added product to cart
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateOrder() returns error? {
    Order|xml response = check sapCommerceClient->placeOrder("electronics", "current", cartId = "current");
    if response is Order {
        test:assertTrue(response?.code !is (), "Expected created order to have a code");
        test:assertTrue(response?.status !is (), "Expected created order to have a status");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateCartDeliveryMode() returns error? {
    error? response = check sapCommerceClient->replaceCartDeliveryMode("electronics", "current", "current", deliveryModeId = "standard");
    test:assertTrue(response is (), "Expected no error on successful delivery mode update");
}