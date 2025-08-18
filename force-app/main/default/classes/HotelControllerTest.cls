@isTest
public class HotelControllerTest {
    @isTest
    static void testGetNearbyHotels_Mock() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockNearbyHotelsResponse());
        List<HotelResponseWrapper.Hotel> hotels = HotelController.getNearbyHotels('40.7128', '-74.0060');
        Test.stopTest();
        System.assertNotEquals(null, hotels, 'Hotels list should not be null');
    }

    @isTest
    static void testGetHotelOffers_Mock() {
        Test.startTest();
        AmadeusHotelOffersResponse resp = HotelController.getHotelOffers('mock', '2025-08-10', '2025-08-12', '1');
        Test.stopTest();
        System.assertNotEquals(null, resp, 'Response should not be null');
        System.assertEquals(1, resp.data.size(), 'Should return one hotel offer');
        System.assertEquals('Mock Hotel', resp.data[0].hotel.name, 'Hotel name should match mock');
    }

    @isTest
    static void testGetHotelOffers_Callout() {
        // Set up a mock for the real callout
        System.Test.setMock(HttpCalloutMock.class, new MockHotelOffersResponse());
        System.Test.startTest();
        AmadeusHotelOffersResponse resp = HotelController.getHotelOffers('REALID', '2025-08-10', '2025-08-12', '1');
        Test.stopTest();
        System.assertNotEquals(null, resp, 'Response should not be null');
    }

    // Mock for getNearbyHotels
    private class MockNearbyHotelsResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"data":[{"name":"Test Hotel","hotelId":"T1"}]}');
            res.setStatusCode(200);
            return res;
        }
    }

    private class MockHotelOffersResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"data":[{"type":"hotel-offer","hotel":{"name":"Test Real Hotel","hotelId":"REALID"},"available":true,"offers":[]}]}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testHasRecentFeedback_True() {
        // Insert feedback for current user within last 15 days
        User_Feedback__c feedback = new User_Feedback__c(
            User__c = UserInfo.getUserId(),
            clarityRating__c = 5,
            timelinessRating__c = 5,
            communicationRating__c = 5,
            overallRating__c = 5,
            Comments__c = 'Great!'
        );
        insert feedback;

        Test.startTest();
        Boolean hasFeedback = HotelController.hasRecentFeedback();
        Test.stopTest();
        System.assertEquals(true, hasFeedback, 'Should return true if feedback exists');
    }

    @isTest
    static void testHasRecentFeedback_False() {
        // No feedback inserted for current user
        Test.startTest();
        Boolean hasFeedback = HotelController.hasRecentFeedback();
        Test.stopTest();
        System.assertEquals(false, hasFeedback, 'Should return false if no feedback exists');
    }

    @isTest
    static void testSubmitFeedback() {
        Test.startTest();
        HotelController.submitFeedback(4, 4, 4, 4, 'Nice process');
        Test.stopTest();

        List<User_Feedback__c> feedbacks = [
            SELECT Id, clarityRating__c, timelinessRating__c, communicationRating__c, overallRating__c, Comments__c
            FROM User_Feedback__c
            WHERE User__c = :UserInfo.getUserId()
        ];
        System.assert(!feedbacks.isEmpty(), 'Feedback should be inserted');
        System.assertEquals(4, feedbacks[0].clarityRating__c);
        System.assertEquals('Nice process', feedbacks[0].Comments__c);
    }

}