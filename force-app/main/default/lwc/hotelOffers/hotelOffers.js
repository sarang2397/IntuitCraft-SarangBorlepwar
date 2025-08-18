import { LightningElement ,api} from 'lwc';

export default class HotelOffers extends LightningElement {
    @api isOpen = false;
    @api hotelOfferData; // expects the full JSON structure under `data`

    hotelName;
    offers = [];

    connectedCallback() {
        if (this.hotelOfferData && this.hotelOfferData.data?.length > 0) {
            const hotelEntry = this.hotelOfferData.data[0];
            this.hotelName = hotelEntry.hotel.name;

            this.offers = hotelEntry.offers.map(offer => {
                return {
                    id: offer.id,
                    roomType: offer.room.type || 'N/A',
                    category: offer.room.typeEstimated?.category || 'N/A',
                    bedType: offer.room.typeEstimated?.bedType || 'N/A',
                    checkIn: offer.checkInDate,
                    checkOut: offer.checkOutDate,
                    price: offer.price?.total || 'N/A',
                    currency: offer.price?.currency || '',
                    rateCode: offer.rateCode || '',
                    cancellationPolicy: offer.policies?.cancellation?.description?.text || 'Not specified',
                    description: offer.room.description?.text || 'No description available'
                };
            });
        }
    }

    closeModal() {
        this.dispatchEvent(new CustomEvent('close'));
    }
}