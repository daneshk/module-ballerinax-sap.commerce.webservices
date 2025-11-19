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
    },
    laxDataBinding: true
};
Client? sapCommerceClient = ();

@test:BeforeSuite
function initClient() returns error? {
    sapCommerceClient = check new Client(config, serviceUrl);
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testDeleteCartEntry() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    error? response = check sapClient->removeCartEntry("electronics", "current", 0, "current");
    test:assertTrue(response is (), "Expected no error on successful delete");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetCatalogs() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    CatalogList|xml _ = check sapClient->getCatalogs("electronics");
    // Successfully retrieved catalogs
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetCatalog() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    Catalog|xml _ = check sapClient->getCatalog("electronics", "electronicsProductCatalog");
    // Successfully retrieved catalog
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetCategory() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    CategoryHierarchy|xml _ = check sapClient->getCategories("electronics", "electronicsProductCatalog", "Online", "cameras");
    // Successfully retrieved category
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetCategoryProducts() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    ProductSearchPage|xml _ = check sapClient->getProductsByCategory("electronics", "cameras");
    // Successfully retrieved category products
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetCountries() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    CountryList|xml _ = check sapClient->getCountries("electronics");
    // Successfully retrieved countries
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetCurrencies() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    CurrencyList|xml _ = check sapClient->getCurrencies("electronics");
    // Successfully retrieved currencies
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetLanguages() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    LanguageList|xml _ = check sapClient->getLanguages("electronics");
    // Successfully retrieved languages
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetOrder() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    Order|xml response = check sapClient->getOrder("electronics", "ORDER001");
    if response is Order {
        test:assertTrue(response?.code !is (), "Expected order to have a code");
        test:assertTrue(response?.status !is (), "Expected order to have a status");
        test:assertTrue(response?.totalPrice !is (), "Expected order to have a total price");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetPaymentModes() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    PaymentModeList|xml _ = check sapClient->getPaymentModes("electronics");
    // Successfully retrieved payment modes
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetProductAvailabilities() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    SAPAvailability|xml response = check sapClient->getProductAvailability("electronics", filters = "3318057_A:EA,PC;4112097_B:EA");
    if response is SAPAvailability {
        test:assertTrue((response.availabilityItems ?: []).length() > 0, "Expected a non-empty availability items array");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetProduct() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    Product|xml response = check sapClient->getProduct("electronics", "PHONE001");
    if response is Product {
        test:assertTrue(response?.code !is (), "Expected product to have a code");
        test:assertTrue(response?.name !is (), "Expected product to have a name");
        test:assertTrue(response?.price !is (), "Expected product to have a price");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testSearchProducts() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    ProductSearchPage|xml _ = check sapClient->getProducts("electronics", query = "iphone");
    // Successfully searched products
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetProductSuggestions() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    SuggestionList|xml _ = check sapClient->getSuggestions("electronics", term = "iphone");
    // Successfully retrieved suggestions
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetPromotions() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    PromotionList|xml _ = check sapClient->getPromotions("electronics", 'type = "all");
    // Successfully retrieved promotions
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetStores() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    StoreFinderSearchPage|xml _ = check sapClient->getStoreLocations("electronics", query = "New York");
    // Successfully retrieved store locations
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetUser() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    User|xml response = check sapClient->getUser("electronics", "current");
    if response is User {
        test:assertTrue(response?.uid !is (), "Expected user to have a uid");
        test:assertTrue(response?.name !is (), "Expected user to have a name");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetUserAddresses() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    AddressList|xml _ = check sapClient->getAddresses("electronics", "current");
    // Successfully retrieved user addresses
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetUserCarts() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    CartList|xml _ = check sapClient->getCarts("electronics", "current");
    // Successfully retrieved user carts
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetCart() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    Cart|xml _ = check sapClient->getCart("electronics", "current", "current");
    // Successfully retrieved cart
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetCartDeliveryModes() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    DeliveryModeList|xml _ = check sapClient->getCartDeliveryModes("electronics", "current", "current");
    // Successfully retrieved cart delivery modes
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetCartEntries() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    OrderEntryList|xml _ = check sapClient->getCartEntries("electronics", "current", "current");
    // Successfully retrieved cart entries
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetUserOrder() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    Order|xml response = check sapClient->getUserOrders("electronics", "ORDER001", "current");
    if response is Order {
        test:assertTrue(response?.code !is (), "Expected order to have a code");
        test:assertTrue(response?.status !is (), "Expected order to have a status");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testUpdateUser() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    User userPayload = {
        uid: "current",
        firstName: "John",
        lastName: "Doe"
    };
    error? response = check sapClient->updateUser("electronics", "current", userPayload);
    test:assertTrue(response is (), "Expected no error on successful update");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testRegisterUser() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    UserSignUp userSignUp = {
        uid: "new.user@example.com",
        password: "password123",
        firstName: "New",
        lastName: "User"
    };
    User|xml response = check sapClient->createUser("electronics", userSignUp);
    if response is User {
        test:assertTrue(response?.uid !is (), "Expected registered user to have a uid");
        test:assertTrue(response?.firstName !is (), "Expected registered user to have a first name");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateAddress() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
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
    Address|xml _ = check sapClient->createAddress("electronics", "current", addressPayload);
    // Successfully created address
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateCart() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    Cart|xml _ = check sapClient->createCart("electronics", "current");
    // Successfully created cart
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testAddProductToCart() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    OrderEntry entryPayload = {
        product: {
            code: "NEW-PRODUCT"
        },
        quantity: 1
    };
    CartModification|xml _ = check sapClient->addCartEntry("electronics", "current", "current", entryPayload);
    // Successfully added product to cart
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateOrder() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    Order|xml response = check sapClient->placeOrder("electronics", "current", cartId = "current");
    if response is Order {
        test:assertTrue(response?.code !is (), "Expected created order to have a code");
        test:assertTrue(response?.status !is (), "Expected created order to have a status");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testUpdateCartDeliveryMode() returns error? {
    Client sapClient = check sapCommerceClient.ensureType();
    error? response = check sapClient->replaceCartDeliveryMode("electronics", "current", "current", deliveryModeId = "standard");
    test:assertTrue(response is (), "Expected no error on successful delivery mode update");
}
