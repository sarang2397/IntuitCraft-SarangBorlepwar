public with sharing class AmadeusHotelOffersResponse {
    
    @AuraEnabled public List<HotelOfferData> data { get; set; }

    public class HotelOfferData {
        @AuraEnabled public String type { get; set; }
        @AuraEnabled public Hotel hotel { get; set; }
        @AuraEnabled public Boolean available { get; set; }
        @AuraEnabled public List<Offer> offers { get; set; }
        @AuraEnabled public String self { get; set; }
    }

    public class Hotel {
        @AuraEnabled public String type { get; set; }
        @AuraEnabled public String hotelId { get; set; }
        @AuraEnabled public String chainCode { get; set; }
        @AuraEnabled public String dupeId { get; set; }
        @AuraEnabled public String name { get; set; }
        @AuraEnabled public String cityCode { get; set; }
        @AuraEnabled public Double latitude { get; set; }
        @AuraEnabled public Double longitude { get; set; }
    }

    public class Offer {
        @AuraEnabled public String id { get; set; }
        @AuraEnabled public String checkInDate { get; set; }
        @AuraEnabled public String checkOutDate { get; set; }
        @AuraEnabled public String rateCode { get; set; }
        @AuraEnabled public RateFamilyEstimated rateFamilyEstimated { get; set; }
        @AuraEnabled public Room room { get; set; }
        @AuraEnabled public Guests guests { get; set; }
        @AuraEnabled public Price price { get; set; }
        @AuraEnabled public Policies policies { get; set; }
        @AuraEnabled public String self { get; set; }
        @AuraEnabled public RoomInformation roomInformation { get; set; }
    }

    public class RateFamilyEstimated {
        @AuraEnabled public String code { get; set; }
        @AuraEnabled public String type { get; set; }
    }

    public class Room {
        @AuraEnabled public String type { get; set; }
        @AuraEnabled public TypeEstimated typeEstimated { get; set; }
        @AuraEnabled public Description description { get; set; }
    }

    public class RoomInformation {
        @AuraEnabled public String description { get; set; }
        @AuraEnabled public String type { get; set; }
        @AuraEnabled public TypeEstimated typeEstimated { get; set; }
    }

    public class TypeEstimated {
        @AuraEnabled public String category { get; set; }
        @AuraEnabled public Integer beds { get; set; }
        @AuraEnabled public String bedType { get; set; }
    }

    public class Description {
        @AuraEnabled public String text { get; set; }
        @AuraEnabled public String lang { get; set; }
    }

    public class Guests {
        @AuraEnabled public Integer adults { get; set; }
    }

    public class Price {
        @AuraEnabled public String currenci { get; set; }
        @AuraEnabled public String base { get; set; }
        @AuraEnabled public String total { get; set; }
        @AuraEnabled public Variations variations { get; set; }
    }

    public class Variations {
        @AuraEnabled public Average average { get; set; }
        @AuraEnabled public List<Change> changes { get; set; }
    }

    public class Average {
        @AuraEnabled public String base { get; set; }
    }

    public class Change {
        @AuraEnabled public String startDate { get; set; }
        @AuraEnabled public String endDate { get; set; }
        @AuraEnabled public String base { get; set; }
    }

    public class Policies {
        @AuraEnabled public List<Cancellation> cancellations { get; set; }
        @AuraEnabled public String paymentType { get; set; }
        @AuraEnabled public Refundable refundable { get; set; }
        @AuraEnabled public Cancellation cancellation { get; set; } // Also handling single cancellation (as per second JSON)
    }

    public class Cancellation {
        @AuraEnabled public Description description { get; set; }
        @AuraEnabled public String policyType { get; set; }
        @AuraEnabled public String type { get; set; } // From second JSON example
    }

    public class Refundable {
        @AuraEnabled public String cancellationRefund { get; set; }
    }
}
