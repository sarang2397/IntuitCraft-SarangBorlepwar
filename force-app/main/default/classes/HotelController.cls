public with sharing class HotelController {

    /**
     * Gets a list of nearby hotels based on latitude and longitude.
     * @param lat Latitude as String
     * @param lon Longitude as String
     * @return List of HotelResponseWrapper.Hotel
     */
    @AuraEnabled
    public static List<HotelResponseWrapper.Hotel> getNearbyHotels(String lat,String lon){
        HttpRequest req = new HttpRequest();
        Http http = new Http();

        req.setEndpoint('callout:Amadeus/v1/reference-data/locations/hotels/by-geocode?latitude='+lat+'&longitude='+lon+'&radius=5&radiusUnit=KM&hotelSource=ALL');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        try {
            HttpResponse res = http.send(req);
            if (res.getStatusCode() == 200) {
                HotelResponseWrapper parsedResponse = (HotelResponseWrapper) JSON.deserialize(res.getBody(), HotelResponseWrapper.class);
                return parsedResponse.data;
            } else {
                throw new AuraHandledException('API call failed with status ' + res.getStatusCode());
            }
        } catch (System.CalloutException ce) {
            throw new AuraHandledException('Callout failed: ' + ce.getMessage());
        } catch (System.JSONException je) {
            throw new AuraHandledException('Failed to parse response: ' + je.getMessage());
        } catch (Exception e) {
            throw new AuraHandledException('Unexpected error: ' + e.getMessage());
        }
    }

    /**
     * Checks if the current user has submitted feedback in the last 15 days.
     * @return Boolean indicating if recent feedback exists
     */
    @AuraEnabled(cacheable=true)
    public static Boolean hasRecentFeedback() {
        try {

            if (!Schema.sObjectType.User_Feedback__c.isAccessible()) {
                throw new AuraHandledException('You do not have permission to access feedback records.');
            }

            Id userId = UserInfo.getUserId();

            // Query only ID for performance
            List<User_Feedback__c> feedbacks = [
                SELECT Id
                FROM User_Feedback__c
                WHERE User__c = :userId
                AND CreatedDate = LAST_N_DAYS:15
                LIMIT 1
            ];

            return !feedbacks.isEmpty();

        } catch (QueryException qex) {
            System.debug('QueryException in hasRecentFeedback: ' + qex.getMessage());
            throw new AuraHandledException('We could not fetch your feedback. Please try again later.');
        } catch (Exception ex) {
            throw new AuraHandledException('Unexpected error occurred while checking feedback.');
        }
    }



    /**
     * Submits feedback for the current user.
     * @param clarityRating
     * @param timelinessRating
     * @param communicationRating
     * @param overallRating
     * @param comments
     */
    
    @AuraEnabled
    public static void submitFeedback(
            Integer clarityRating,
            Integer timelinessRating,
            Integer communicationRating,
            Integer overallRating,
            String comments
    ) {
        try {
            if (!Schema.sObjectType.User_Feedback__c.isCreateable()) {
                throw new AuraHandledException('You do not have permission to submit feedback.');
            }
            User_Feedback__c feedback = new User_Feedback__c(
                User__c = UserInfo.getUserId(),
                clarityRating__c = clarityRating,
                timelinessRating__c = timelinessRating,
                communicationRating__c = communicationRating,
                overallRating__c = overallRating,
                Comments__c = comments
            );
            insert feedback;
        } catch (DmlException dmlEx) {
            throw new AuraHandledException('Failed to save feedback: ' + dmlEx.getDmlMessage(0));

        } catch (NullPointerException npe) {
            throw new AuraHandledException('Feedback submission failed: missing required values.');

        } catch (Exception ex) {
            throw new AuraHandledException('Unexpected error occurred while submitting feedback. Please contact your admin.');
        }
    }


    /**
     * Gets hotel offers for a given hotel and dates.
     * @param hotelId
     * @param checkInDate
     * @param checkOutDate
     * @param roomQuantity
     * @return AmadeusHotelOffersResponse or error wrapper
     */

    @AuraEnabled
    public static AmadeusHotelOffersResponse getHotelOffers(String hotelId, String checkInDate, String checkOutDate, String roomQuantity,String noOfAdults) {
    // MOCK: Return a sample response if hotelId is 'mock'
    if (hotelId == 'mock') {
        AmadeusHotelOffersResponse mockResponse = new AmadeusHotelOffersResponse();
        mockResponse.data = new List<AmadeusHotelOffersResponse.HotelOfferData>();

        AmadeusHotelOffersResponse.HotelOfferData offerData = new AmadeusHotelOffersResponse.HotelOfferData();
        offerData.type = 'hotel-offer';
        offerData.available = true;
        offerData.self = 'https://test.com/hotel/1';

        // Hotel info
        offerData.hotel = new AmadeusHotelOffersResponse.Hotel();
        offerData.hotel.type = 'hotel';
        offerData.hotel.hotelId = 'MOCK1';
        offerData.hotel.chainCode = 'MOCKCHAIN';
        offerData.hotel.dupeId = 'DUP1';
        offerData.hotel.name = 'Mock Hotel';
        offerData.hotel.cityCode = 'NYC';
        offerData.hotel.latitude = 40.7128;
        offerData.hotel.longitude = -74.0060;

        // Offer
        offerData.offers = new List<AmadeusHotelOffersResponse.Offer>();
        AmadeusHotelOffersResponse.Offer offer = new AmadeusHotelOffersResponse.Offer();
        offer.id = 'OFFER1';
        offer.checkInDate = checkInDate;
        offer.checkOutDate = checkOutDate;
        offer.rateCode = 'R1';

        // Price
        offer.price = new AmadeusHotelOffersResponse.Price();
        offer.price.currenci = 'USD';
        offer.price.base = '150.00';
        offer.price.total = '180.00';
        offer.price.variations = null;

        // Room
        offer.room = new AmadeusHotelOffersResponse.Room();
        offer.room.type = 'DELUXE';
        offer.room.typeEstimated = new AmadeusHotelOffersResponse.TypeEstimated();
        offer.room.typeEstimated.category = 'DELUXE';
        offer.room.typeEstimated.beds = 1;
        offer.room.typeEstimated.bedType = 'KING';
        offer.room.description = new AmadeusHotelOffersResponse.Description();
        offer.room.description.text = 'A deluxe king room with city view.';
        offer.room.description.lang = 'en';

        // Guests
        offer.guests = new AmadeusHotelOffersResponse.Guests();
        offer.guests.adults = 2;

        // Policies
        offer.policies = new AmadeusHotelOffersResponse.Policies();
        offer.policies.paymentType = 'guarantee';
        offer.policies.refundable = new AmadeusHotelOffersResponse.Refundable();
        offer.policies.refundable.cancellationRefund = 'FULL';

        offerData.offers.add(offer);
        mockResponse.data.add(offerData);

        return mockResponse;
    }

    // ...existing code...
    String endpoint = 'callout:Amadeus/v3/shopping/hotel-offers?hotelIds=' + hotelId +
                      '&adults='+noOfAdults+'&checkInDate=' + checkInDate +
                      '&roomQuantity='+roomQuantity+'&paymentPolicy=NONE';

    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setMethod('GET');
    req.setEndpoint(endpoint);
    req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

    HttpResponse res;
    try {
        res = http.send(req);
        if (res.getStatusCode() == 200) {
            return (AmadeusHotelOffersResponse) JSON.deserialize(res.getBody(), AmadeusHotelOffersResponse.class);
        } else {
            System.debug('Error: ' + res.getStatus() + ' ' + res.getBody());
            throw new AuraHandledException('Hotel API error: ' + res.getStatus()+ ' ' + res.getBody());
        }
    } catch (Exception ex) {
        throw new AuraHandledException('Failed to get hotel offers: ' + ex.getMessage());
    }
}
}
